class AuthLocalDataSource {
  AuthLocalDataSource() : authLocalDataSource = <String, Object?>{};

  final Map<String, Object?> authLocalDataSource;

  void write<T extends Object?>({required String key, T? value}) {
    authLocalDataSource[key] = value;
  }

  T? read<T extends Object?>({required String key}) {
    final value = authLocalDataSource[key];
    if (value is T) return value;
    return null;
  }
}
