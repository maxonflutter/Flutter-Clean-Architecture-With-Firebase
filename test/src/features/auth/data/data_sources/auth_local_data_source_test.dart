import 'package:flutter_clean_architecture_with_firebase/src/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AuthLocalDataSource authLocalDataSource;

  setUp(() {
    authLocalDataSource = AuthLocalDataSource();
  });

  group('AuthLocalDataSource', () {
    test('should write a value to the data source', () {
      const key = 'test_key';
      const value = 'test_value';
      authLocalDataSource.write<String>(key: key, value: value);

      expect(authLocalDataSource.read<String>(key: key), value);
    });

    test('should overwrite a value in the data source', () {
      const key = 'test_key';
      const initialValue = 'initial_value';
      authLocalDataSource.write<String>(key: key, value: initialValue);

      const newValue = 'new_value';
      authLocalDataSource.write<String>(key: key, value: newValue);

      expect(authLocalDataSource.read<String>(key: key), newValue);
    });

    test('should read a value from the data source', () {
      const key = 'test_key';
      const value = 'test_value';
      authLocalDataSource.write<String>(key: key, value: value);

      final result = authLocalDataSource.read<String>(key: key);

      expect(result, value);
    });

    test('should return null if no value is found for the key', () {
      const key = 'non_existent_key';

      final result = authLocalDataSource.read<String>(key: key);

      expect(result, isNull);
    });

    test('should return null if value is not of type T', () {
      const key = 'test_key';
      const value = 123;
      authLocalDataSource.write<int>(key: key, value: value);

      final result = authLocalDataSource.read<String>(key: key);

      expect(result, isNull);
    });
  });
}
