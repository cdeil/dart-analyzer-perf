import 'package:collection/collection.dart';

  /// Model 89 of the synthetic domain.
  class Model89 {
    const Model89({required this.field1, required this.field2, required this.field3, required this.field4, required this.field5, required this.field6});

    factory Model89.fromJson(Map<String, Object?> json) => Model89(
        field1: json['field1'] as String,
    field2: json['field2'] as int,
    field3: json['field3'] as int,
    field4: json['field4'] as String,
    field5: json['field5'] as int,
    field6: json['field6'] as int,
    );

    final String field1;
final int field2;
final int field3;
final String field4;
final int field5;
final int field6;

    Map<String, Object?> toJson() => {
        'field1': field1,
    'field2': field2,
    'field3': field3,
    'field4': field4,
    'field5': field5,
    'field6': field6,
    };

    Model89 copyWith({String? field1, int? field2, int? field3, String? field4, int? field5, int? field6}) => Model89(
        field1: field1 ?? this.field1,
    field2: field2 ?? this.field2,
    field3: field3 ?? this.field3,
    field4: field4 ?? this.field4,
    field5: field5 ?? this.field5,
    field6: field6 ?? this.field6,
    );

    static List<Model89> sortedByField2(Iterable<Model89> items) =>
        items.sorted((a, b) => a.field2.compareTo(b.field2));

    @override
    bool operator ==(Object other) =>
        other is Model89 && other.field1 == field1 && other.field2 == field2;

    @override
    int get hashCode => Object.hash(field1, field2);

    @override
    String toString() => 'Model89(field1: $field1, field2: $field2)';
  }
