// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Password extends Password {
  @override
  final String value;

  factory _$Password([void Function(PasswordBuilder)? updates]) =>
      (new PasswordBuilder()..update(updates))._build();

  _$Password._({required this.value}) : super._() {
    BuiltValueNullFieldError.checkNotNull(value, r'Password', 'value');
  }

  @override
  Password rebuild(void Function(PasswordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PasswordBuilder toBuilder() => new PasswordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Password && value == other.value;
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
    return (newBuiltValueToStringHelper(r'Password')..add('value', value))
        .toString();
  }
}

class PasswordBuilder implements Builder<Password, PasswordBuilder> {
  _$Password? _$v;

  String? _value;
  String? get value => _$this._value;
  set value(String? value) => _$this._value = value;

  PasswordBuilder();

  PasswordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _value = $v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Password other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Password;
  }

  @override
  void update(void Function(PasswordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Password build() => _build();

  _$Password _build() {
    final _$result = _$v ??
        new _$Password._(
            value: BuiltValueNullFieldError.checkNotNull(
                value, r'Password', 'value'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
