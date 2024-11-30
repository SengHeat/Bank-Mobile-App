/*
// ignore_for_file: prefer_collection_literals, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:scholarar/controller/auth_controller.dart';
import 'package:scholarar/controller/home_controller.dart';
import 'package:scholarar/controller/localization_controller.dart';
import 'package:scholarar/controller/matching_controller.dart';
import 'package:scholarar/controller/notification_controller.dart';
import 'package:scholarar/controller/payment_controller.dart';
import 'package:scholarar/controller/profile_controller.dart';
import 'package:scholarar/controller/scholarship_controller.dart';
import 'package:scholarar/controller/splash_controller.dart';
import 'package:scholarar/controller/theme_controller.dart';
import 'package:scholarar/data/api/api_client.dart';
import 'package:scholarar/data/model/response/language_model.dart';
import 'package:scholarar/data/repository/auth_repository.dart';
import 'package:scholarar/data/repository/home_repository.dart';
import 'package:scholarar/data/repository/language_repository.dart';
import 'package:scholarar/data/repository/matching_repository.dart';
import 'package:scholarar/data/repository/notification_repository.dart';
import 'package:scholarar/data/repository/payment_repository.dart';
import 'package:scholarar/data/repository/profile_repository.dart';
import 'package:scholarar/data/repository/scholarship_repository.dart';
import 'package:scholarar/helper/network_info.dart';
import 'package:scholarar/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

Future<Map<String, Map<String, String>>> init() async {

  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => NetworkInfo(Get.find()));
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => DioClient(appBaseUrl: AppConstants.baseURL, sharedPreferences: Get.find()));

  // Repository
  Get.lazyPut(() => LanguageRepository());
  Get.lazyPut(() => AuthRepository(dioClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => ScholarshipRepository(dioClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => HomeRepository(dioClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => MatchingRepository(dioClient: Get.find(),sharedPreferences: Get.find()));
  Get.lazyPut(() => ProfileRepository(dioClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => PaymentRepository(dioClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => NotificationRepository(dioClient: Get.find(), sharedPreferences: Get.find()));
  // Controller
  Get.lazyPut(() => SplashController());
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find(), dioClient: Get.find()));
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => AuthController(authRepository: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => ScholarshipController(scholarshipRepository: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => HomeController(homeRepository: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => MatchingController(matchingRepository: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => ProfileController(profileRepository: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => PaymentController(paymentRepository: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => NotificationController(notificationRepository: Get.find(), sharedPreferences: Get.find()));

  // Retrieving localized data
  Map<String, Map<String, String>> languages = Map();
  for (LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues = await rootBundle.loadString('assets/languages/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    Map<String, String> _json = Map();
    mappedJson.forEach((key, value) {
      _json[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = _json;
  }
  return languages;
}
*/
