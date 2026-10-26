import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service 10: touches the heavy dependencies a real app pulls into analysis.
class Service10 {
  Service10(this.dio, this.preferences);

  final Dio dio;
  final SharedPreferences preferences;

  Future<Map<String, Object?>> fetch(String path) async {
    final response = await dio.get<Map<String, Object?>>(path);
    return response.data ?? const {};
  }

  Future<void> remember(String key, String value) =>
      preferences.setString('service10.$key', value);

  Future<bool> open(Uri uri) => launchUrl(uri);

  Future<Uint8List> render(String title) async {
    final document = pw.Document();
    document.addPage(pw.Page(build: (context) => pw.Text(title)));
    return document.save();
  }

  img.Image? decode(Uint8List bytes) => img.decodeImage(bytes);

  Future<void> printDocument(Uint8List bytes) =>
      Printing.layoutPdf(onLayout: (format) async => bytes);

  Future<XFile?> pick() => ImagePicker().pickImage(source: ImageSource.gallery);

  Widget icon(String asset) => SvgPicture.asset(asset);

  GoRouter router() => GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SizedBox()),
    ],
  );
}
