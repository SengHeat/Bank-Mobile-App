
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:typed_data';

import 'app_constants.dart';


void main() {
  String jsonData = "eyJpdiI6IlFjb1ZybjdUaGNLUEtJc1h1YTE1S1E9PSIsInZhbHVlIjoibGRlTTE2VjJWU0VZaW1RM210dng0b0pFUURPMzFNU00zcE9jbXRaRWRBeWZlalRYaWprYlI0bm1sbmxoM1laQXhvdVNreC9SaXBUOXkrQUVMUjNWYVRzN3grcVFCdzB0TUoycFRIN2Y2eWc9IiwibWFjIjoiMzQxNTI2ZTllYzExMDVlNWRiN2IzYWJlN2ZhY2RkNWMwYTZkYTc4NjFiZjM2NWUxZDAyNTY5YWE1OGFiNzkzOSIsInRhZyI6IiJ9";

  String jsonID = "eyJpdiI6IlV2T3V6OFYrWkZpSVlJNFMzUzhpNFE9PSIsInZhbHVlIjoiYVp3eEZJOVNDNERudVdGckIvOUlTdz09IiwibWFjIjoiYmU5YTYzNTNjN2Y0OGU2NGZlNDdkZTA0ODQyZDNiOTQyMmIzYWE4ZjNiOGYzNTMyNWYxODJmNmVhNzRiYjc2ZCIsInRhZyI6IiJ9";

  String jsonImage = "eyJpdiI6ImhWTWdqNi9KRVM2ZXdQTTJqQ1dLSWc9PSIsInZhbHVlIjoiZUNVdW9FYUROQUxMUlFsWFBrSnNVNG94c29qZ2t0V0JJT3N0Q2trZ0ZLYmlXUmxNQ0Nhd1ZIWk9UT2svT3UvTnlsUk9kVWdjUjdMY3YxSVFxaGZwL1h4YUdLMjFQaW9qcFpjSTlEZ01mdUU5bzlDOWUxb25lbFJhK056b2pnaFhIRmdOSWxZVE9kd2FoemF2STk5UTR3PT0iLCJtYWMiOiI2ODFmZDExMzkxM2I2NTgxODk2MzQwYzQ5NTM1ZWM4MWM1NzMxYmNiNTQxMzg0MzQ5NWExOTFjMzQxNDk2MzFjIiwidGFnIjoiIn0=";

  // Decrypt each field
  var map = EncryptDecryptData.getIvValue(jsonData);
  var maps = EncryptDecryptData.getIvValue(jsonID);
  var mapi = EncryptDecryptData.getIvValue(jsonImage);

  print(EncryptDecryptData.decryptData(jsonImage));

  /*if (map != null && maps != null && mapi != null) {
    String decryptedData = EncryptDecryptData.decryptData(map['value']!, map['iv']!, EncryptDecryptData.appKey);
    String decryptedID = EncryptDecryptData.decryptData(maps['value']!, maps['iv']!, EncryptDecryptData.appKey);
    String decryptedImage = EncryptDecryptData.decryptData(mapi['value']!, mapi['iv']!, EncryptDecryptData.appKey);

    // Print decrypted values
    print("Decrypted Data: $decryptedData");
    print("Decrypted ID: $decryptedID");
    print("Decrypted Image: $decryptedImage");
  } else {
    print("Failed to decode one or more encrypted fields.");
  }*/
}

class EncryptDecryptData {

  static Map<String, String>? getIvValue(String encryptString) {
    try {
      final decoded = utf8.decode(base64.decode(encryptString));
      final map = json.decode(decoded);
      if (map is Map<String, dynamic> && map.containsKey('iv') && map.containsKey('value')) {
        return {
          'iv': map['iv'] as String,
          'value': map['value'] as String,
        };
      } else {
        print("Error: Missing 'iv' or 'value' key in the decoded JSON");
        return null;
      }
    } catch (e) {
      print("Error decoding or parsing the string: $e");
      return null;
    }
  }

  static String decryptData(dynamic encryptString) {

    if(encryptString == null || encryptString == "") {
      return "N/A";
    }

    Map<String, String> ivValue = {};

    try {
      final decoded = utf8.decode(base64.decode(encryptString));
      final map = json.decode(decoded);
      if (map is Map<String, dynamic> && map.containsKey('iv') && map.containsKey('value')) {
        ivValue = {
          'iv': map['iv'] as String,
          'value': map['value'] as String,
        };
      } else {
        print("Error: Missing 'iv' or 'value' key in the decoded JSON");
        return "N/A";
      }
    } catch (e) {
      print("Error decoding or parsing the string: $e");
      return "N/A";
    }

    var encryptedBytes = base64.decode(ivValue['value']!);
    var ivBytes = base64.decode(ivValue['iv']!);
    var keyBytes = base64.decode(AppConstants.appKey);
    final key = encrypt.Key(Uint8List.fromList(keyBytes));
    final iv = encrypt.IV(Uint8List.fromList(ivBytes));
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    try {
      final decrypted = encrypter.decryptBytes(encrypt.Encrypted(encryptedBytes), iv: iv);
      return utf8.decode(decrypted);
    } catch (e) {
      throw Exception("Decryption failed: $e");
    }
  }

  static String encryptData(String plainText, String encryptionKey) {
    var keyBytes = base64.decode(encryptionKey);  // Base64 decode encryption key
    final iv = encrypt.IV.fromLength(16);  // Generate a 16-byte IV for AES
    final key = encrypt.Key(Uint8List.fromList(keyBytes));  // Convert key to the correct format
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));  // Create AES CBC encrypter

    final encrypted = encrypter.encrypt(plainText, iv: iv);  // Encrypt the plain text

    final encryptedValue = base64.encode(encrypted.bytes);  // Base64 encode the encrypted value
    final ivValue = base64.encode(iv.bytes);  // Base64 encode the IV

    // Create a map for the data to be returned
    final resultMap = {
      'iv': ivValue,
      'value': encryptedValue,
      'mac': 'SomeMacValue',
      'tag': 'SomeTag'
    };

    // Convert the map to a JSON string
    final jsonString = json.encode(resultMap);

    // Base64 encode the JSON string
    final base64Json = base64.encode(utf8.encode(jsonString));

    // Return the base64-encoded JSON string
    return base64Json;
  }

}