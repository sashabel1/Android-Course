import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'profile_screen.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const OtpScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> codeControllers =
  List.generate(6, (index) => TextEditingController());

  bool isLoading = false;

  String getCode() {
    return codeControllers.map((controller) => controller.text).join();
  }

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

  Future<void> verifyCode() async {
    final String smsCode = getCode();

    if (smsCode.length != 6) {
      showMessage('Invalid Code', 'Please enter the 6 digit code.');
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: smsCode,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      setState(() {
        isLoading = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });

      showMessage(
        'Verification Failed',
        e.message ?? 'The code is incorrect.',
      );
    }
  }

  @override
  void dispose() {
    for (final controller in codeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget buildCodeBox(int index) {
    return SizedBox(
      width: 45,
      height: 55,
      child: TextField(
        controller: codeControllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: const Color(0xFFEFF3F7),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).nextFocus();
          }

          if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
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
              Icons.verified_user,
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
            Text(
              'Code sent to ${widget.phoneNumber}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) => buildCodeBox(index)),
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
                onPressed: isLoading ? null : verifyCode,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'Verify Phone Number',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Text(
                'Edit Phone Number?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}