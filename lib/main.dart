import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:secrectjar/pages/authorization.dart';
import 'package:secrectjar/utils/theme/custom_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  const FlutterSecureStorage secureStorage = FlutterSecureStorage();

  var containsEncryptionKey = await secureStorage.containsKey(key: 'key');

  // Creates a key, if doesn't exists
  if (!containsEncryptionKey) {
    List<int> key = Hive.generateSecureKey();
    await secureStorage.write(key: 'key', value: base64Encode(key));
  }

  String? keyStr = await secureStorage.read(key: 'key');

  if (keyStr != null) {
    Uint8List encryptionKey = base64Url.decode(keyStr);

    await Hive.openBox(
      'secrets',
      encryptionCipher: HiveAesCipher(encryptionKey),
    );

    runApp(const MyApp());
  } else {
    throw Exception('Não foi possível configurar o app');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Secrect Jar',
      darkTheme: darkTheme,
      theme: defaultTheme,
      themeMode: ThemeMode.dark,
      home: const Authorization(),
    );
  }
}
