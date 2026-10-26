// Drives the real PluginServer in-process the way the analysis server does:
// plugin.versionCheck, then analysis.setAnalysisRoots, then wait for idle.
import 'dart:async';
import 'dart:io';

import 'package:analysis_server_plugin/src/plugin_server.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer_plugin/channel/channel.dart';
import 'package:analyzer_plugin/protocol/protocol.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_lint/main.dart' as riverpod_lint;

class ProbeChannel implements PluginCommunicationChannel {
  void Function(Request)? _onRequest;
  final responses = <String, Completer<Response>>{};
  final errors = <String, List<AnalysisError>>{};
  final statusLog = <(int, bool)>[];
  final Stopwatch clock;
  int lastNotificationMs = 0;
  int errorsNotifications = 0;
  final Completer<void> idle = Completer();
  bool sawWorking = false;

  ProbeChannel(this.clock);

  @override
  void close() {}

  @override
  void listen(
    void Function(Request request) onRequest, {
    Function? onError,
    void Function()? onDone,
  }) {
    _onRequest = onRequest;
  }

  Future<Response> send(Request request) {
    var completer = Completer<Response>();
    responses[request.id] = completer;
    _onRequest!(request);
    return completer.future;
  }

  @override
  void sendNotification(Notification notification) {
    lastNotificationMs = clock.elapsedMilliseconds;
    switch (notification.event) {
      case 'analysis.errors':
        var params = AnalysisErrorsParams.fromNotification(notification);
        errors[params.file] = params.errors;
        errorsNotifications++;
      case 'plugin.status':
        var params = PluginStatusParams.fromNotification(notification);
        var analyzing = params.analysis?.isAnalyzing ?? false;
        statusLog.add((clock.elapsedMilliseconds, analyzing));
        if (analyzing) sawWorking = true;
        if (!analyzing && sawWorking && !idle.isCompleted) idle.complete();
      case 'plugin.error':
        stderr.writeln('[probe] plugin.error ${notification.params}');
      default:
        stderr.writeln('[probe] notification ${notification.event}');
    }
  }

  @override
  void sendResponse(Response response) {
    responses.remove(response.id)?.complete(response);
  }
}

Future<void> main(List<String> args) async {
  var clock = Stopwatch()..start();
  var root = args[0];
  var sdkPath = args[1];
  var byteStorePath = args[2];
  var server = PluginServer.new2(
    resourceProvider: PhysicalResourceProvider.INSTANCE,
    plugins: {'riverpod_lint': riverpod_lint.plugin},
  );
  await server.initialize();
  var channel = ProbeChannel(clock);
  server.start(channel);
  stderr.writeln('[probe] started at ${clock.elapsedMilliseconds} ms');

  var version = await channel.send(
    PluginVersionCheckParams(byteStorePath, sdkPath, '1.0.0-alpha.0')
        .toRequest('1'),
  );
  stderr.writeln(
    '[probe] versionCheck at ${clock.elapsedMilliseconds} ms '
    'error=${version.error}',
  );
  var roots = await channel.send(
    AnalysisSetAnalysisRootsParams([root], []).toRequest('2'),
  );
  stderr.writeln(
    '[probe] setAnalysisRoots at ${clock.elapsedMilliseconds} ms '
    'error=${roots.error}',
  );
  await channel.idle.future;
  var idleAt = clock.elapsedMilliseconds;
  // Quiet period: wait until no notification arrived for 500 ms and the
  // last status is idle.
  while (true) {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    var quiet = clock.elapsedMilliseconds - channel.lastNotificationMs > 500;
    var lastIdle = channel.statusLog.isNotEmpty && !channel.statusLog.last.$2;
    if (quiet && lastIdle) break;
  }
  var doneAt = clock.elapsedMilliseconds;
  var lastErrorsAt = channel.lastNotificationMs;
  var lines = <String>[];
  var severities = {'ERROR': 'error', 'WARNING': 'warning', 'INFO': 'info'};
  channel.errors.forEach((file, errors) {
    for (var e in errors) {
      lines.add(
        '${severities[e.severity.name] ?? e.severity.name} - '
        '${p.relative(file, from: root)}:${e.location.startLine}:'
        '${e.location.startColumn} - ${e.message} - ${e.code}',
      );
    }
  });
  lines.sort();
  stdout.writeln('[probe-result] firstIdleMs=$idleAt doneMs=$doneAt '
      'lastNotificationMs=$lastErrorsAt '
      'errorsNotifications=${channel.errorsNotifications} '
      'filesWithErrors=${channel.errors.values.where((e) => e.isNotEmpty).length} '
      'findings=${lines.length} statusTransitions=${channel.statusLog.length}');
  for (var line in lines) {
    stdout.writeln(line);
  }
  var shutdown = await channel.send(PluginShutdownParams().toRequest('3'));
  stderr.writeln(
    '[probe] shutdown at ${clock.elapsedMilliseconds} ms error=${shutdown.error}',
  );
  exit(0);
}
