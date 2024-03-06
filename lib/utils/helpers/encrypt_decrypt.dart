import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

class EncryptDecrypt {
  static String encrypt(String password) {
    Uint8List plaintext = Uint8List.fromList(utf8.encode(password));
    Uint8List passphrase = Uint8List.fromList(
        utf8.encode("izkj9zt/Z7Dkb7MPkXECwmVKo2aB4olInwkytH+8hM4="));

    // Generate random 16 bytes salt and random 16 bytes IV
    SecureRandom secureRandom = getSecureRandom();
    Uint8List salt = secureRandom.nextBytes(16);
    Uint8List iv = secureRandom.nextBytes(16);

    // Derive 32 bytes key via PBKDF2
    Uint8List key = deriveKey(salt, passphrase);

    // Encrypt with AES-256/CBC/PKCS#7 padding
    Uint8List ciphertext = encryptAesCbcPkcs7(plaintext, key, iv);

    // Concat salt|nonce|ciphertext and Base64 encode
    String saltIvCiphertextB64 = concatAndEncode(salt, iv, ciphertext);

    // developer.log("saltIvCiphertextB64 -> $saltIvCiphertextB64");

    return saltIvCiphertextB64;
  }

  static SecureRandom getSecureRandom() {
    List<int> seed =
        List<int>.generate(32, (_) => Random.secure().nextInt(256));
    return FortunaRandom()..seed(KeyParameter(Uint8List.fromList(seed)));
  }

  static Uint8List deriveKey(Uint8List salt, Uint8List passphrase) {
    KeyDerivator derivator = KeyDerivator('SHA-1/HMAC/PBKDF2');
    Pbkdf2Parameters params = Pbkdf2Parameters(salt, 100, 256 ~/ 8);
    derivator.init(params);
    return derivator.process(passphrase);
  }

  static Uint8List encryptAesCbcPkcs7(
      Uint8List plaintext, Uint8List key, Uint8List iv) {
    CBCBlockCipher cipher = CBCBlockCipher(AESEngine());
    ParametersWithIV<KeyParameter> params =
        ParametersWithIV<KeyParameter>(KeyParameter(key), iv);
    PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, Null>
        paddingParams =
        PaddedBlockCipherParameters<ParametersWithIV<KeyParameter>, Null>(
            params, null);
    PaddedBlockCipherImpl paddingCipher =
        PaddedBlockCipherImpl(PKCS7Padding(), cipher);
    paddingCipher.init(true, paddingParams);
    Uint8List ciphertext = paddingCipher.process(plaintext);
    return ciphertext;
  }

  static String concatAndEncode(
      Uint8List salt, Uint8List iv, Uint8List ciphertext) {
    BytesBuilder saltIvCiphertext = BytesBuilder();
    saltIvCiphertext.add(salt);
    saltIvCiphertext.add(iv);
    saltIvCiphertext.add(ciphertext);
    String saltIvCiphertextB64 = base64Encode(saltIvCiphertext.toBytes());
    return saltIvCiphertextB64;
  }

  static String decrypt(String encryptedText) {
    return "";
  }
}
