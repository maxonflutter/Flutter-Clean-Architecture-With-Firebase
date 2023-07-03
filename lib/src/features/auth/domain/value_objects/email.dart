import 'package:built_value/built_value.dart';

part 'email.g.dart';

// Value object are defined by their attributes rather than its identity.
abstract class Email implements Built<Email, EmailBuilder> {
  String get value;

  // Entities tend to represent more complex objects or concepts in
  // your domain, while value objects are used to encapsulate simpler,
  // more atomic concepts or measures. Both play important roles
  // in creating a rich, expressive domain model.
  Email._() {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );

    if (!emailRegExp.hasMatch(value)) {
      throw ArgumentError('Invalid email format');
    }
  }
  factory Email([void Function(EmailBuilder) updates]) = _$Email;
}
