// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Email extends Email {
  @override
  final String value;

  factory _$Email([void Function(EmailBuilder)? updates]) =>
      (new EmailBuilder()..update(updates))._build();

  _$Email._({required this.value}) : super._() {
    BuiltValueNullFieldError.checkNotNull(value, r'Email', 'value');
  }

  @override
  Email rebuild(void Function(EmailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmailBuilder toBuilder() => new EmailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Email && value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Email')..add('value', value))
        .toString();
  }
}

class EmailBuilder implements Builder<Email, EmailBuilder> {
  _$Email? _$v;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  EmailBuilder();

  EmailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _value = $v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Email other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Email;
  }

  @override
  void update(void Function(EmailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Email build() => _build();

  _$Email _build() {
    final _$result = _$v ??
        new _$Email._(
            value: BuiltValueNullFieldError.checkNotNull(
                value, r'Email', 'value'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
