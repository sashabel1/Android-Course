import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'otp_screen.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  void showMessage(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> sendCode() async {
    final String phone = phoneController.text.trim();

    if (phone.isEmpty) {
      showMessage('Missing Phone', 'Please enter your phone number.');
      return;
    }

    final String fullPhoneNumber = '+972$phone';

    setState(() {
      isLoading = true;
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: fullPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          isLoading = false;
        });

        showMessage(
          'Verification Failed',
          e.message ?? 'Could not send verification code.',
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          isLoading = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              verificationId: verificationId,
              phoneNumber: fullPhoneNumber,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FB),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.phone_android,
              size: 95,
              color: Colors.green,
            ),
            const SizedBox(height: 25),
            const Text(
              'Phone Verification',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'We need to register your phone before getting started!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 35),
            Row(
              children: [
                Container(
                  height: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: const Text(
                    '+972',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Phone',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: isLoading ? null : sendCode,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'Send the code',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}