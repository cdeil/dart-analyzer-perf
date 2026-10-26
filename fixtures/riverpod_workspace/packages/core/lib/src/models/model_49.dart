import 'package:collection/collection.dart';

  /// Model 49 of the synthetic domain.
  class Model49 {
    const Model49({required this.field1, required this.field2, required this.field3, required this.field4, required this.field5, required this.field6});

    factory Model49.fromJson(Map<String, Object?> json) => Model49(
        field1: json['field1'] as int,
    field2: json['field2'] as int,
    field3: json['field3'] as String,
    field4: json['field4'] as int,
    field5: json['field5'] as int,
    field6: json['field6'] as String,
    );

    final int field1;
final int field2;
final String field3;
final int field4;
final int field5;
final String field6;

    Map<String, Object?> toJson() => {
        'field1': field1,
    'field2': field2,
    'field3': field3,
    'field4': field4,
    'field5': field5,
    'field6': field6,
    };

    Model49 copyWith({int? field1, int? field2, String? field3, int? field4, int? field5, String? field6}) => Model49(
        field1: field1 ?? this.field1,
    field2: field2 ?? this.field2,
    field3: field3 ?? this.field3,
    field4: field4 ?? this.field4,
    field5: field5 ?? this.field5,
    field6: field6 ?? this.field6,
    );

    static List<Model49> sortedByField2(Iterable<Model49> items) =>
        items.sorted((a, b) => a.field2.compareTo(b.field2));

    @override
    bool operator ==(Object other) =>
        other is Model49 && other.field1 == field1 && other.field2 == field2;

    @override
    int get hashCode => Object.hash(field1, field2);

    @override
    String toString() => 'Model49(field1: $field1, field2: $field2)';
  }
