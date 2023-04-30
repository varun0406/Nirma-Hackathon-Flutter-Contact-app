import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannedDataScreen extends StatelessWidget {
  final String scannedData;
  final String name;
  final String address;
  final String email;
  final String phone;
  final QRViewController controller;
  final AnimationController animationController;

  const ScannedDataScreen({
    Key? key,
    required this.scannedData,
    required this.name,
    required this.address,
    required this.email,
    required this.phone,
    required this.controller,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Scanned Data:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  scannedData,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await _saveContact(name, phone, email);
                          },
                          icon: const Icon(Icons.save),
                          label: const Text('Save to Contacts'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (controller.hasPermissions) {
                              controller.resumeCamera();
                              animationController.repeat(reverse: true);
                            }
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.qr_code),
                          label: const Text('Scan Again'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveContact(String name, String phone, String email) async {}

  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ScannedDataScreen(
            scannedData: scannedData,
            name: _extractName(scannedData),
            address: _extractAddress(scannedData),
            email: _extractEmail(scannedData),
            phone: _extractPhone(scannedData),
            controller: controller,
            animationController: animationController,
          ),
        );
      },
    );
  }

  String _extractName(String scannedData) {
    // code to extract name from scannedData
    return "";
  }

  String _extractAddress(String scannedData) {
    // code to extract address from scannedData
    return "";
  }

  String _extractEmail(String scannedData) {
    // code to extract email from scannedData
    return "";
  }

  String _extractPhone(String scannedData) {
    // code to extract phone from scannedData
    return "";
  }
}
