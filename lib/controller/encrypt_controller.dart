import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:trasua_delivery/api/deliver_api.dart';

class RSAEncryptDecrypt extends GetxController {
  late DeliverApi _deliverApi;
  @override
  void onInit() {
    super.onInit();
    _deliverApi = DeliverApi();
  }

  Future writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  String encodeToBase64(String message) {
    List<int> messageBytes = utf8.encode(message);
    return base64Encode(messageBytes);
  }

  String decodeFromBase64(String base64EncodedMessage) {
    List<int> messageBytes = base64Decode(base64EncodedMessage);
    return utf8.decode(messageBytes);
  }

  // void encryptMessage(String messagee) async {
  //   final pubKey = await rootBundle.load("assets/keys/public.pem");
  //   final priKey = await rootBundle.load("assets/keys/private.pem");
  //   //Lấy đường dẫn chính xác của 2 file public và private key
  //   String dir = (await getApplicationDocumentsDirectory()).path;

  //   writeToFile(pubKey, '$dir/publickey.pem');
  //   writeToFile(priKey, '$dir/privatekey.pem');
  //   //Đọc public key và private key từ 2 file trên
  //   final publicKey =
  //       await parseKeyFromFile<RSAPublicKey>(File('$dir/publickey.pem').path);
  //   final privateKey =
  //       await parseKeyFromFile<RSAPrivateKey>(File('$dir/privatekey.pem').path);
  //   //Tạo đối tượng encrypter với public key và private key
  //   final encrypter =
  //       Encrypter(RSA(publicKey: publicKey, privateKey: privateKey));
  //   final encrypted = encrypter.encrypt(messagee);
  //   final decrypted = encrypter.decrypt(encrypted);
  //   // final publicKeyBase64 = base64Encode(publicKeyBytes);
  //   print('Public Key (PEM): ${encrypter}');
  //   print(encrypted.base64);
  // }

  RSAPublicKey parsePublicKeyFromBase64(String base64EncodedPublicKey) {
    Logger().i(base64EncodedPublicKey);
    var publicKey =
        "-----BEGIN PUBLIC KEY-----\n$base64EncodedPublicKey\n-----END PUBLIC KEY-----";
    try {
      // Decode the Base64 string to bytes
      // List<int> publicKeyBytes = base64.decode(base64EncodedPublicKey);

      // // Convert bytes to string
      // String publicKeyStringDecoded = utf8.decode(publicKeyBytes);
      // Parse the RSA public key
      final rsaParser = RSAKeyParser();
      RSAPublicKey rsaPublicKey = rsaParser.parse(publicKey) as RSAPublicKey;

      print("Successfully parsed RSA public key: $rsaPublicKey");
      return rsaPublicKey;
    } catch (e) {
      print("Error parsing RSA public key: $e");
      throw e;
    }
  }

  Future<String> encrypt(String message) async {
    final serverPublicKeyReceived = await requestPublicKey();
    if (serverPublicKeyReceived != "Fail") {
      final serverPublicKey =
          parsePublicKeyFromBase64(serverPublicKeyReceived.toString());
      final priKey = await rootBundle.load("assets/keys/private.pem");
      String dir = (await getApplicationDocumentsDirectory()).path;
      writeToFile(priKey, '$dir/privatekey.pem');
      final privateKey = await parseKeyFromFile<RSAPrivateKey>(
          File('$dir/privatekey.pem').path);
      final encrypter =
          Encrypter(RSA(publicKey: serverPublicKey, privateKey: privateKey));
      final encryptedMessage = encrypter.encrypt(message);
      Logger().i("Cipher text ${encryptedMessage.base64}");
      return encryptedMessage.base64;
    }
    return "Fail";
  }

  Future<String> requestPublicKey() async {
    final response = await _deliverApi.requestPublicKey();
    if (response.status == "Success") {
      return response.data;
    }
    return "Fail";
  }
}
