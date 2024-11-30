/*
// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'package:get/get_connect/http/src/response/response.dart';

class AuthRepository {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  AuthRepository({required this.dioClient, required this.sharedPreferences});

  Future<void> saveUserToken({String? token}) async {
    dioClient.updateHeader(oldToken: token);
    try {
      await sharedPreferences.setString(AppConstants.token, token ?? "");
    } catch (e) {
      throw e.toString();
    }
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  Future<Response> getUpdateVersion() async {
    try {
      final response = await dioClient.getData(AppConstants.getUpdaterVersion);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> register ( String firstName, String lastName,String email, String password,String confirmPassword, String deviceToken, String referralCode) async {
    Map<String, dynamic> body = {
      'first_name' : firstName,
      'last_name' : lastName,
      //"gender": gender,
      // "phone": phoneNumber,
      // "phone_code": "855",
      "email": email,
      */
/*"otp_verify_code": "123456",*//*

      "password": password,
      "password_confirmation": confirmPassword,
      "accepted_terms_conditions": 1,
      "device_token": deviceToken,
      "referral_code" : referralCode,
    };
    try {
      Response response = await dioClient.postData(
        AppConstants.register, body,
        headers: {
          'Content-Type': 'application/json',
        }
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
  //TODO: verify email code OTP
  Future<Response> verifyEmailCode(String email, String otpEmail) async {
    try {
      final response = await dioClient.postData(
        AppConstants.verifyRegisterOTP,
        {
          "email": email,
          "otp": otpEmail
        }
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  //TODO: resend email code OTP
  Future<Response> resendEmailCode(String email) async {
    try {
      final response = await dioClient.postData(
        AppConstants.resendOTPCode,
        {
          "email": email
        }
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
  //Todo: googleSignIn
  Future<Response> googleSignIn(String accessToken) async {
    try {
      final response = await dioClient.postData(AppConstants.loginWithGoogle, {
        'access_token': accessToken,
      });
      return response;
    } catch (e) {
      throw e.toString();
    }
  }


  //Todo: facebookSignIn
  Future<Response> facebookSignIn(String accessToken) async {
    try {
      final response = await dioClient.postData(AppConstants.loginWithFacebook, {
        'access_token': accessToken,
      });
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
  Future<Response> signInWithPhone() async {
    try {
      Response response = await dioClient.postData(AppConstants.phoneSignIn,{});
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> loginWithPhone(String phone, String password, String deviceToken) async {
    try {
      Response response = await dioClient.postData(AppConstants.login, {
        'phone': phone,
        'password': password,
        'device_token': deviceToken
      });
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> loginWithEmail(String email, String password, String deviceToken) async {
    try {
      Response response = await dioClient.postData(AppConstants.login, {
        'email': email,
        'password': password,
        'device_token': deviceToken
      });
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> changeAvatar(String uuid) async {
    try {
      final response = await dioClient.postData(AppConstants.changeAvatar, {'storage_uuid': uuid});
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> uploadAvatar(XFile file) async {
    try {
      final response = await dioClient.postMultipartData(AppConstants.uploadFile, {}, [MultipartBody('file', file)]);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> changeName(String name) async {
    try {
      Response response = await dioClient.postData(AppConstants.changeUserName, {'name': name,});
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> clearSharedData() async {
    await sharedPreferences.remove(AppConstants.token);
    return true;
  }

  Future<Response> sendOTP(String phone, String phoneCode) async {
    Map<String, String> body = {
      "phone": phone,
      "phone_code": phoneCode.substring(1)
    };
    try {
      final response = await dioClient.postData(
          AppConstants.sendVerificationSMS, body,
          headers: {'Content-Type': 'application/json'}
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> sendOTPEmail(String email) async {
    Map<String, String> body = {
      "email": email
    };
    try {
      final response = await dioClient.postData(
          AppConstants.sendOTPWithEmail, body
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> verifyForgotPasswordOTP({required String email, required String otp}) async {
    Map<String, String> body = {
        "email": email,
        "otp": otp
    };
    try {
      final response = await dioClient.postData(
          AppConstants.verifyOTPWithEmail, body
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> resetForgotPassword({required String email, required String password, required String confirmPassword}) async {

    Map<String, dynamic> body = {
      "email": email,
      "new_password": password,
      "new_password_confirmation": confirmPassword
    };
    try {
      final response = await dioClient.postData(
          AppConstants.resetPassword, body,
          headers: {'Content-Type': 'application/json'}
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> verifyOtp(String phone, String phoneCode, String otpCode) async {
    Map<String, String> body = {
      "phone": phone,
      "phone_code": phoneCode,
      "verification_code": otpCode
    };
    try {
      final response = await dioClient.postData(
        AppConstants.verificationCode, body,
        headers: {'Content-Type': 'application/json'}
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> signOut(String deviceID) async {
    try {
      final response = await dioClient.postData(
        AppConstants.signOut,
        {
          "device_token": deviceID
        }
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
  //TODO: delete Account
  Future<Response> deleteAccount() async {
    try {
      if(isLoggedIn()) {
        final response = await dioClient.deleteData(
          AppConstants.delete,
        );
        return response;
      } else {
        final response = await dioClient.deleteData(
          AppConstants.delete,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer',
          }
        );
        return response;
      }
    } catch (e) {
      // Properly handle any errors
      throw Exception('Failed to delete account: ${e.toString()}');
    }
  }

  Future changePhoneNumber({required String phone, required String phoneCode, required String pin, required String otp}) async{
    try{
      final response = await dioClient.postData(AppConstants.changePhoneNumber, {
        "phone" : phone,
        "phone_code" : phoneCode,
        "pin" : pin,
        "verification_code" : otp
      });
      return response;
    } catch(e){
      throw e.toString();
    }
  }

  Future<Response> createNewPassword({
    required String phone,
    required String phoneCode,
    required String verificationCode,
    required String newPassword,
    required String confirmPassword,
  }) async {
    Map<String, String> body = {
      'phone': phone,
      'phone_code': phoneCode,
      "verification_code": verificationCode,
      'new_password': newPassword,
      'confirm_password': confirmPassword
    };
    try {
      final response = await dioClient.postData(AppConstants.resetPassword, body,headers: {
        'Content-Type': 'application/json',
      });
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> checkPassword(String phone, String phoneCode,String oldPassword) async {
    try {
      final response = await dioClient.postData(
        AppConstants.changePassword,
        {
          'phone': phone,
          'phone_code': phoneCode,
          'old_password': oldPassword,
        }
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> checkCurrentPassword(String currentPassword) async {
    try {
      final response = await dioClient.postData(AppConstants.changePassword, {'current_password': currentPassword});
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> changePassword(String currentPassword, String newPassword, String confirmPassword) async {
    try {
      final response = await dioClient.postData(
        AppConstants.changePassword,
        {
          'current_password': currentPassword,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        }
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> resetDeviceToken(String email) async {
    try {
      final response = await dioClient.postData(
        AppConstants.resetDeviceToken,
        {
          'email': email,
        },
      );
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> getNotification() async {
    try {
      final response = await dioClient.getData(AppConstants.getNotification);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response>getScholarshipNotification() async {
    try {
      final response = await dioClient.getData(AppConstants.getScholarshipNotification);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response>getMatchingNotification() async {
    try {
      final response = await dioClient.getData(AppConstants.getMatchingNotification);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> noficationCount() async {
    try{
      final response = await dioClient.getData(AppConstants.getNotificationCount);
      return response;
    }catch(e){
      throw e.toString();
    }
  }

  Future<Response> unreadNotification(String userId) async {
    try{
      final response = await dioClient.postData(
          AppConstants.unreadNotification,
          {
            'user_id': userId,
          }
      );
      return response;
    }catch(e){
      throw e.toString();
    }
  }

  Future<Response> unreadEachNotification(int userId, int notificationId) async {
    try{
      Map<String, dynamic> body = {
        'user_id': userId,
        'notification_id': notificationId
      };
      final response = await dioClient.postData(AppConstants.unreadEachNotification, body);
      return response;
    }catch(e){
      throw e.toString();
    }
  }

  Future<Response> eachNotificationList(int notificationId) async {
    try {
      final String urlEachNotification = "${AppConstants.getEachNotificationList}$notificationId";
      print("Hello World : ${AppConstants.getEachNotificationList}$notificationId");
      final response = await dioClient.getData(urlEachNotification);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> userReferralCode() async {
    try {
      final response = await dioClient.getData(AppConstants.userReferralCode);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Response> submitReferralCode({required Map<String, String> body}) async {
    try {
      final response = await dioClient.postData(AppConstants.submitReferralCode, body);
      return response;
    } catch (e) {
      throw e.toString();
    }
  }
}


*/
