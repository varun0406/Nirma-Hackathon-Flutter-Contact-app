import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ScannedDataScreen.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  QRScannerState createState() => QRScannerState();
}

class QRScannerState extends State<QRScanner>
    with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    Permission.camera.request();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Scan a QR Code'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.blue,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: const Text(
                'Place QR Code inside the frame',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0, _animation.value * 150),
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 4,
                child: const LinearProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      // Stop the camera and animations
      controller.stopCamera();
      _animationController.stop();
      _animationController.reset();

      String scannedData = scanData.code!;

      // Extract the name, address, email, and phone number from the scanned data
      RegExp exp = RegExp(
          r'BEGIN:VCARD\nFN:(.*?)\nADR:(.*?)\nEMAIL:(.*?)\nTEL:(.*?)\nEND:VCARD');
      Iterable<Match> matches = exp.allMatches(scannedData);
      String name = '';
      String address = '';
      String email = '';
      String phone = '';
      if (matches.isNotEmpty) {
        Match match = matches.first;
        name = match.group(1)!;
        address = match.group(2)!;
        email = match.group(3)!;
        phone = match.group(4)!;
      }

      // Show the scanned data in a popup window
      ScannedDataScreen(
        controller: controller,
        animationController: _animationController,
        scannedData: scannedData,
        name: name,
        address: address,
        email: email,
        phone: phone,
      ).show(context);
    });
  }
}
