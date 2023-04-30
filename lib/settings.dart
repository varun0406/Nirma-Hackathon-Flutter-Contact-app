import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'generateQR.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String businessName = '';
  String businessAddress = '';
  String autoResponseText = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Settings'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'Business',
              icon: Icon(Icons.business_center),
            ),
            Tab(
              text: 'Auto Response Text',
              icon: Icon(Icons.message),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Business tab
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Business Settings',
                  style: TextStyle(fontSize: 20.0),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Business Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      businessName = value;
                    });
                  },
                ),
                const SizedBox(height: 20.0),
                TextField(
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Business Address',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      businessAddress = value;
                    });
                  },
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  child: const Text('Generate QR Code'),
                  onPressed: () {
                    String qrData =
                        'Business Name: $businessName\nBusiness Address: $businessAddress';
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                QRCodeScreen(qrData: qrData)));
                  },
                ),
              ],
            ),
          ),

          // Auto Response Text tab
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Auto Response Text Settings',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Default Auto Response Text',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        autoResponseText = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    child: const Text('Save'),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Auto response text saved.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
