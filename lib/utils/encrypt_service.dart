import 'package:encrypt/encrypt.dart' as encrypt_lib;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

const key = 'ULg8BbXF7^si#3Yqs9c9F#v3';

class EncryptService {
  final iv = encrypt_lib.IV.fromLength(16);

  final encrypter = encrypt_lib.Encrypter(
    encrypt_lib.AES(
      encrypt_lib.Key.fromUtf8(key)
    )
  );

  String encrypt(String password) {
    final encryptKey = encrypt_lib.Key.fromUtf8(key);
    final iv = encrypt_lib.IV.fromLength(16);

    final encrypter = encrypt_lib.Encrypter(encrypt_lib.AES(encryptKey));

    final encrypted = encrypter.encrypt(password, iv: iv);

    return encrypted.base64;
  }

  String decrypt(String encryptedInput) {
    return encrypter.decrypt(
      encrypt_lib.Encrypted.fromBase64(encryptedInput),
      iv: iv,
    );
  }

  void copyToClipboard(String encryptedInput, BuildContext context) {
    final decrypted = decrypt(encryptedInput);

    // Copy to clipboard
    Clipboard.setData(
      ClipboardData(text: decrypted)
    );

    // Show toast
    Fluttertoast.showToast(
      msg: "Copiado para sua área de transferência 🤗",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 18,
    );
  }
}