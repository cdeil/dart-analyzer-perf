"""Generate a deterministic synthetic Flutter + Riverpod pub workspace for analyzer benchmarks.

The workspace mirrors the shape of a mid-sized production app: one shared package with
models, repositories, Riverpod providers and widgets, and two apps that consume it.
Only hand-written Riverpod 3 APIs are used (Notifier, AsyncNotifier, Provider,
NotifierProvider, ConsumerWidget), so no code generation step is needed.

A few deliberate rule violations are planted as sentinels so that diagnostic parity
checks have positive findings to compare; they are listed in SENTINELS.

Usage: python3 generate_workspace.py OUT_DIR [--models N] [--providers N] [--widgets N] [--screens N]
"""
import argparse
import textwrap
from pathlib import Path

FLUTTER_SDK_CONSTRAINT = '^3.13.0'

SENTINELS = [
    ('packages/core/lib/src/providers/sentinel_public_field.dart', 'avoid_public_notifier_properties'),
    ('apps/app_a/lib/screens/sentinel_dispose_screen.dart', 'avoid_ref_inside_state_dispose'),
]


def write(path: Path, content: str):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(textwrap.dedent(content).lstrip())


def model(i: int) -> str:
    fields = [('field1', 'String'), ('field2', 'int'), ('field3', 'int'),
              ('field4', 'String'), ('field5', 'int'), ('field6', 'int')]
    ctor = ', '.join(f'required this.{n}' for n, _ in fields)
    decls = '\n'.join(f'  final {t} {n};' for n, t in fields)
    from_json = ',\n'.join(
        f"      {n}: json['{n}'] as {t}" for n, t in fields)
    to_json = ',\n'.join(f"      '{n}': {n}" for n, _ in fields)
    copy_params = ', '.join(f'{t}? {n}' for n, t in fields)
    copy_body = ',\n'.join(f'      {n}: {n} ?? this.{n}' for n, _ in fields)
    return f'''
    import 'package:collection/collection.dart';

    /// Model {i} of the synthetic domain.
    class Model{i} {{
      const Model{i}({{{ctor}}});

      factory Model{i}.fromJson(Map<String, Object?> json) => Model{i}(
    {from_json},
      );

    {decls}

      Map<String, Object?> toJson() => {{
    {to_json},
      }};

      Model{i} copyWith({{{copy_params}}}) => Model{i}(
    {copy_body},
      );

      static List<Model{i}> sortedByField2(Iterable<Model{i}> items) =>
          items.sorted((a, b) => a.field2.compareTo(b.field2));

      @override
      bool operator ==(Object other) =>
          other is Model{i} && other.field1 == field1 && other.field2 == field2;

      @override
      int get hashCode => Object.hash(field1, field2);

      @override
      String toString() => 'Model{i}(field1: $field1, field2: $field2)';
    }}
    '''


def repository(i: int, models: int) -> str:
    m = i % models
    return f'''
    import 'dart:async';

    import 'package:core/src/models/model_{m}.dart';

    /// Repository {i}: an in-memory store with asynchronous access.
    class Repository{i} {{
      Repository{i}(this.seed);

      final int seed;
      final Map<String, Model{m}> _items = {{}};

      Future<List<Model{m}>> list() async {{
        await Future<void>.delayed(const Duration(milliseconds: 1));
        return Model{m}.sortedByField2(_items.values);
      }}

      Future<Model{m}?> find(String id) async => _items[id];

      Future<void> upsert(Model{m} item) async {{
        _items[item.field1] = item;
      }}

      Future<void> remove(String id) async {{
        _items.remove(id);
      }}

      Stream<int> count() async* {{
        yield _items.length;
      }}
    }}
    '''


def provider(i: int, models: int, repos: int) -> str:
    r = i % repos
    m = r % models
    keep_alive = 'true' if i % 5 == 0 else 'false'
    return f'''
    import 'dart:async';

    import 'package:flutter_riverpod/flutter_riverpod.dart';

    import 'package:core/src/models/model_{m}.dart';
    import 'package:core/src/repositories/repository_{r}.dart';

    final repository{i}Provider = Provider<Repository{r}>(
      (ref) => Repository{r}({i}),
      isAutoDispose: !{keep_alive},
    );

    /// Items notifier {i}: loads and edits [Model{m}] values.
    class Items{i}Notifier extends AsyncNotifier<List<Model{m}>> {{
      @override
      FutureOr<List<Model{m}>> build() async {{
        final repository = ref.watch(repository{i}Provider);
        return repository.list();
      }}

      Future<void> add(Model{m} item) async {{
        final repository = ref.read(repository{i}Provider);
        await repository.upsert(item);
        ref.invalidateSelf();
      }}

      Future<void> remove(String id) async {{
        final repository = ref.read(repository{i}Provider);
        await repository.remove(id);
        ref.invalidateSelf();
      }}
    }}

    final items{i}Provider =
        AsyncNotifierProvider<Items{i}Notifier, List<Model{m}>>(
      Items{i}Notifier.new,
      isAutoDispose: !{keep_alive},
    );

    /// Selection notifier {i}: tracks the selected item id.
    class Selection{i}Notifier extends Notifier<String?> {{
      @override
      String? build() => null;

      void select(String? id) => state = id;

      void clear() => state = null;
    }}

    final selection{i}Provider =
        NotifierProvider<Selection{i}Notifier, String?>(
      Selection{i}Notifier.new,
      isAutoDispose: !{keep_alive},
    );

    final selectedItem{i}Provider = Provider<Model{m}?>((ref) {{
      final id = ref.watch(selection{i}Provider);
      final items = ref.watch(items{i}Provider).value ?? const [];
      if (id == null) return null;
      for (final item in items) {{
        if (item.field1 == id) return item;
      }}
      return null;
    }}, isAutoDispose: !{keep_alive});
    '''


def service(i: int) -> str:
    return f'''
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

    /// Service {i}: touches the heavy dependencies a real app pulls into analysis.
    class Service{i} {{
      Service{i}(this.dio, this.preferences);

      final Dio dio;
      final SharedPreferences preferences;

      Future<Map<String, Object?>> fetch(String path) async {{
        final response = await dio.get<Map<String, Object?>>(path);
        return response.data ?? const {{}};
      }}

      Future<void> remember(String key, String value) =>
          preferences.setString('service{i}.$key', value);

      Future<bool> open(Uri uri) => launchUrl(uri);

      Future<Uint8List> render(String title) async {{
        final document = pw.Document();
        document.addPage(pw.Page(build: (context) => pw.Text(title)));
        return document.save();
      }}

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
    }}
    '''


def widget(i: int, providers: int) -> str:
    p = i % providers
    return f'''
    import 'package:flutter/material.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart';
    import 'package:intl/intl.dart';

    import 'package:core/src/providers/provider_{p}.dart';

    /// Widget {i}: lists the items of provider {p}.
    class ItemsList{i} extends ConsumerWidget {{
      const ItemsList{i}({{super.key, this.onSelected}});

      final ValueChanged<String?>? onSelected;

      @override
      Widget build(BuildContext context, WidgetRef ref) {{
        final items = ref.watch(items{p}Provider);
        final selected = ref.watch(selection{p}Provider);
        final format = NumberFormat.decimalPattern();
        return items.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error: $error')),
          data: (values) => ListView.builder(
            itemCount: values.length,
            itemBuilder: (context, index) {{
              final item = values[index];
              return ListTile(
                key: ValueKey(item.field1),
                selected: item.field1 == selected,
                title: Text(item.field1),
                subtitle: Text(format.format(item.field2)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () =>
                      ref.read(items{p}Provider.notifier).remove(item.field1),
                ),
                onTap: () {{
                  ref.read(selection{p}Provider.notifier).select(item.field1);
                  onSelected?.call(item.field1);
                }},
              );
            }},
          ),
        );
      }}
    }}

    /// Detail card {i}: shows the selected item of provider {p}.
    class ItemCard{i} extends ConsumerWidget {{
      const ItemCard{i}({{super.key}});

      @override
      Widget build(BuildContext context, WidgetRef ref) {{
        final item = ref.watch(selectedItem{p}Provider);
        if (item == null) {{
          return const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('Nothing selected')));
        }}
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.field1, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('${{item.field2}} / ${{item.field3}}'),
                TextButton(
                  onPressed: () => ref.read(selection{p}Provider.notifier).clear(),
                  child: const Text('Clear'),
                ),
              ],
            ),
          ),
        );
      }}
    }}
    '''


def screen(app: str, i: int, widgets: int) -> str:
    w = i % widgets
    return f'''
    import 'package:flutter/material.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart';

    import 'package:core/core.dart';

    class Screen{i} extends ConsumerStatefulWidget {{
      const Screen{i}({{super.key}});

      @override
      ConsumerState<Screen{i}> createState() => _Screen{i}State();
    }}

    class _Screen{i}State extends ConsumerState<Screen{i}> {{
      String? _selected;

      @override
      Widget build(BuildContext context) {{
        return Scaffold(
          appBar: AppBar(title: const Text('{app} screen {i}')),
          body: Row(
            children: [
              Expanded(child: ItemsList{w}(onSelected: (id) => setState(() => _selected = id))),
              const Expanded(child: ItemCard{w}()),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Selected: ${{_selected ?? 'none'}}')),
            ),
            child: const Icon(Icons.info_outline),
          ),
        );
      }}
    }}
    '''


def generate(out: Path, models: int, providers: int, widgets: int, screens: int):
    repos = max(1, providers // 2)
    core = out / 'packages/core'
    write(out / 'pubspec.yaml', f'''
    name: riverpod_bench_workspace
    publish_to: none
    environment:
      sdk: {FLUTTER_SDK_CONSTRAINT}
    workspace:
      - packages/core
      - apps/app_a
      - apps/app_b
    ''')
    write(out / 'analysis_options.yaml', '''
    include: package:flutter_lints/flutter.yaml

    plugins:
      riverpod_lint: 3.1.9

    analyzer:
      exclude:
        - build/**
        - "**/build/**"
    ''')
    write(out / 'README.md', '''
    # Synthetic Flutter + Riverpod workspace

    Generated by `fixtures/generate_workspace.py`; do not edit by hand. The planted rule
    violations listed in the generator's `SENTINELS` are intentional.
    ''')
    write(core / 'pubspec.yaml', f'''
    name: core
    publish_to: none
    resolution: workspace
    environment:
      sdk: {FLUTTER_SDK_CONSTRAINT}
    dependencies:
      flutter:
        sdk: flutter
      flutter_riverpod: ^3.4.3
      riverpod_annotation: ^4.0.7
      collection: ^1.19.0
      intl: ^0.20.0
      meta: ^1.16.0
      dio: ^5.9.0
      flutter_svg: ^2.2.0
      go_router: ^17.0.0
      image: ^4.5.0
      image_picker: ^1.2.0
      pdf: ^3.11.0
      printing: ^5.14.0
      shared_preferences: ^2.5.0
      url_launcher: ^6.3.0
    dev_dependencies:
      flutter_lints: ^6.0.0
      riverpod_lint: ^3.1.9
    ''')
    exports = []
    for i in range(models):
        write(core / f'lib/src/models/model_{i}.dart', model(i))
        exports.append(f"export 'src/models/model_{i}.dart';")
    for i in range(repos):
        write(core / f'lib/src/repositories/repository_{i}.dart', repository(i, models))
        exports.append(f"export 'src/repositories/repository_{i}.dart';")
    for i in range(providers):
        write(core / f'lib/src/providers/provider_{i}.dart', provider(i, models, repos))
        exports.append(f"export 'src/providers/provider_{i}.dart';")
    for i in range(widgets):
        write(core / f'lib/src/widgets/widget_{i}.dart', widget(i, providers))
        exports.append(f"export 'src/widgets/widget_{i}.dart';")
    write(core / 'lib/src/providers/sentinel_public_field.dart', '''
    import 'package:flutter_riverpod/flutter_riverpod.dart';

    /// Sentinel: `avoid_public_notifier_properties` must report `publicCounter`.
    class SentinelPublicFieldNotifier extends Notifier<int> {
      int publicCounter = 0;

      @override
      int build() => 0;

      void increment() => state = ++publicCounter;
    }

    final sentinelPublicFieldProvider =
        NotifierProvider<SentinelPublicFieldNotifier, int>(SentinelPublicFieldNotifier.new);
    ''')
    for i in range(max(1, providers // 8)):
        write(core / f'lib/src/services/service_{i}.dart', service(i))
        exports.append(f"export 'src/services/service_{i}.dart';")
    exports.append("export 'src/providers/sentinel_public_field.dart';")
    write(core / 'lib/core.dart', '/// Shared models, repositories, providers and widgets.\nlibrary;\n\n' + '\n'.join(exports) + '\n')
    for app in ('app_a', 'app_b'):
        app_dir = out / 'apps' / app
        write(app_dir / 'pubspec.yaml', f'''
        name: {app}
        publish_to: none
        resolution: workspace
        environment:
          sdk: {FLUTTER_SDK_CONSTRAINT}
        dependencies:
          flutter:
            sdk: flutter
          flutter_riverpod: ^3.4.3
          core:
            path: ../../packages/core
        dev_dependencies:
          flutter_lints: ^6.0.0
          riverpod_lint: ^3.1.9
        flutter:
          uses-material-design: true
        ''')
        routes = []
        for i in range(screens):
            write(app_dir / f'lib/screens/screen_{i}.dart', screen(app, i, widgets))
            routes.append(f"      '/screen_{i}': (context) => const Screen{i}(),")
        imports = '\n'.join(f"import 'screens/screen_{i}.dart';" for i in range(screens))
        write(app_dir / 'lib/main.dart', f'''
        import 'package:flutter/material.dart';
        import 'package:flutter_riverpod/flutter_riverpod.dart';

        {imports}

        void main() => runApp(const ProviderScope(child: {app.title().replace('_', '')}App()));

        class {app.title().replace('_', '')}App extends StatelessWidget {{
          const {app.title().replace('_', '')}App({{super.key}});

          @override
          Widget build(BuildContext context) {{
            return MaterialApp(
              title: '{app}',
              routes: {{
        {chr(10).join(routes)}
              }},
              home: const Screen0(),
            );
          }}
        }}
        ''')
    write(out / 'apps/app_a/lib/screens/sentinel_dispose_screen.dart', '''
    import 'package:flutter/material.dart';
    import 'package:flutter_riverpod/flutter_riverpod.dart';

    import 'package:core/core.dart';

    /// Sentinel: `avoid_ref_inside_state_dispose` must report the `ref.read` in dispose.
    class SentinelDisposeScreen extends ConsumerStatefulWidget {
      const SentinelDisposeScreen({super.key});

      @override
      ConsumerState<SentinelDisposeScreen> createState() => _SentinelDisposeScreenState();
    }

    class _SentinelDisposeScreenState extends ConsumerState<SentinelDisposeScreen> {
      @override
      void dispose() {
        ref.read(selection0Provider.notifier).clear();
        super.dispose();
      }

      @override
      Widget build(BuildContext context) => const ItemsList0();
    }
    ''')
    total = sum(1 for _ in out.rglob('*.dart'))
    print(f'generated {total} Dart files under {out}')


def main():
    p = argparse.ArgumentParser()
    p.add_argument('out')
    p.add_argument('--models', type=int, default=120)
    p.add_argument('--providers', type=int, default=160)
    p.add_argument('--widgets', type=int, default=160)
    p.add_argument('--screens', type=int, default=60)
    a = p.parse_args()
    generate(Path(a.out), a.models, a.providers, a.widgets, a.screens)


if __name__ == '__main__':
    main()
