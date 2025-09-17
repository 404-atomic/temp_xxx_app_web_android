import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';

String decodeAes(String content, String encipherKey) {
  return _decryptAesCbcPKCS7PaddingToString(content, encipherKey);
}

String encodeAes(String context, String encipherKey) {
  return _encryptAesCbcPKCS7PaddingToString(context, encipherKey);
}

/** AES加密, CBC, PKCS5Padding */
String _encryptAesCbcPKCS7PaddingToString(String content, String encipherKey) {
  final key = Key.fromUtf8(encipherKey);
  final iv = IV.fromUtf8(encipherKey);
//设置cbc模式
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  final decrypted = encrypter.encrypt(content, iv: iv);
  //decrypted转string
  return decrypted.base16;
}

/** AES加密, CBC, PKCS5Padding */
String _decryptAesCbcPKCS7PaddingToString(
    String encrypted, String encipherKey) {
  final key = Key.fromUtf8(encipherKey);
  final iv = IV.fromUtf8(encipherKey);
//设置cbc模式
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  final decrypted = encrypter.decrypt16(encrypted, iv: iv);
  return decrypted;
}
