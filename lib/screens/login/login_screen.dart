import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:trasua_delivery/config/colors.dart';
import 'package:trasua_delivery/config/font.dart';
import 'package:trasua_delivery/config/spacing.dart';
import 'package:trasua_delivery/controller/deliver_controller.dart';
import 'package:trasua_delivery/controller/encrypt_controller.dart';
import 'package:trasua_delivery/screens/home/home_screen.dart';

class LoginScreen extends GetView {
  final _txtPhoneNumber = TextEditingController();
  final _rsa = Get.find<DeliverController>();
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange.shade300,
              Colors.orange.shade700,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 8.0,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Đăng nhập',
                        style: CustomFonts.customGoogleNunitoFonts(
                            fontSize: 22.r, color: AppColors.orange100),
                      ),
                      SizedBox(height: AppSpacing.space16),
                      TextField(
                        controller: _txtPhoneNumber,
                        decoration: InputDecoration(
                          labelText: 'Số điện thoại',
                          prefixIcon:
                              const Icon(Icons.phone, color: Colors.orange),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: AppSpacing.space16),
                      ElevatedButton(
                        onPressed: () async {
                          await _rsa.login(_txtPhoneNumber.text);
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.space16,
                              vertical: AppSpacing.space12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Đăng nhập',
                          style: CustomFonts.customGoogleNunitoFonts(
                              fontSize: 13.r, color: AppColors.white100),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
