import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/appColors.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // Controllers
  final TextEditingController appNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController contactUsTextController = TextEditingController();

  // Variables for images
  File? selectedBannerImage;
  File? selectedAppIconImage;
  File? selectedSplashIconImage;

  String? bannerImageUrl;
  String? appIconUrl;
  String? splashIconUrl;

  // Switch states
  bool showBanner = false;
  bool showContactNumber = false;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('app_settings')
          .doc('app')
          .get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          appNameController.text = data['app_name'] ?? '';
          phoneNumberController.text = data['contact_us_number'] ?? '';
          contactUsTextController.text = data['contact_us_text'] ?? '';
          bannerImageUrl = data['banner'];
          appIconUrl = data['app_icon'];
          splashIconUrl = data['splash_icon'];
          showBanner = data['show_banner'] ?? false;
          showContactNumber = data['show_contact_number'] ?? false;
        });
      }
    } catch (e) {
      print('Error loading settings: $e');
    }
  }

  Future<String?> uploadImage(File? imageFile) async {
    if (imageFile == null) return null;

    try {
      final cloudinary = Cloudinary.signedConfig(
        apiKey: "191182111899947",
        apiSecret: "cqOT8xRwcZoaaw9z0bm9bIsQDYE",
        cloudName: "dal3uq1y5",
      );

      final response = await cloudinary.upload(
          file: imageFile.path,
          resourceType: CloudinaryResourceType.image,
          folder: 'app_images',
          fileName: '${DateTime.now().millisecondsSinceEpoch}');

      if (response.isSuccessful) {
        return response.secureUrl;
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
    return null;
  }

  Future<void> saveSettings() async {
    EasyLoading.show(status: 'Saving...');
    try {
      final bannerUrl = selectedBannerImage != null
          ? await uploadImage(selectedBannerImage)
          : bannerImageUrl;
      final appIconUrl = selectedAppIconImage != null
          ? await uploadImage(selectedAppIconImage)
          : this.appIconUrl;
      final splashIconUrl = selectedSplashIconImage != null
          ? await uploadImage(selectedSplashIconImage)
          : this.splashIconUrl;

      final data = {
        'app_name': appNameController.text,
        'contact_us_number': phoneNumberController.text,
        'contact_us_text': contactUsTextController.text,
        'banner': bannerUrl,
        'app_icon': appIconUrl,
        'splash_icon': splashIconUrl,
        'show_banner': showBanner,
        'show_contact_number': showContactNumber,
      };

      await FirebaseFirestore.instance
          .collection('app_settings')
          .doc('app')
          .set(data, SetOptions(merge: true));

      EasyLoading.showSuccess('Settings updated successfully!');
    } catch (e) {
      EasyLoading.showError('Failed to save settings');
      print('Error saving settings: $e');
    }
  }

  Future<void> pickImage(String type) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (type == 'banner') {
          selectedBannerImage = File(pickedFile.path);
        } else if (type == 'app_icon') {
          selectedAppIconImage = File(pickedFile.path);
        } else if (type == 'splash_icon') {
          selectedSplashIconImage = File(pickedFile.path);
        }
      });
    }
  }

  Widget buildImagePicker(
      String label, File? selectedImage, String? imageUrl, String type) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 8),
      GestureDetector(
          onTap: () => pickImage(type),
          child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                  image: selectedImage != null
                      ? DecorationImage(
                          image: FileImage(selectedImage),
                          fit: BoxFit.cover,
                        )
                      : imageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.cover,
                            )
                          : null),
              child: selectedImage == null && imageUrl == null
                  ? Icon(Icons.image, size: 50, color: Colors.grey)
                  : null)),
      SizedBox(height: 20)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Setting Menu')),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(children: [
            TextField(
                controller: appNameController,
                decoration: InputDecoration(labelText: 'App Name')),
            TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(labelText: 'Contact Number')),
            TextField(
                minLines: 3,
                maxLines: 5,
                controller: contactUsTextController,
                decoration: InputDecoration(labelText: 'Contact Us Text')),
            // Text("$selectedBannerImage"),
            // Text("$selectedAppIconImage"),
            // Text("$selectedSplashIconImage"),
            SizedBox(height: 20),
            buildImagePicker(
                'Banner Image', selectedBannerImage, bannerImageUrl, 'banner'),
            buildImagePicker(
                'App Icon', selectedAppIconImage, appIconUrl, 'app_icon'),
            buildImagePicker('Splash Icon', selectedSplashIconImage,
                splashIconUrl, 'splash_icon'),
            SwitchListTile(
                title: Text('Show Banner'),
                value: showBanner,
                onChanged: (value) => setState(() => showBanner = value)),
            SwitchListTile(
                title: Text('Show Contact Number'),
                value: showContactNumber,
                onChanged: (value) =>
                    setState(() => showContactNumber = value)),
            SizedBox(height: 20),
          ])),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(14),
        child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: OutlinedButton.icon(
                    onPressed: saveSettings,
                    label: Text("Save Settings",
                        style: TextStyle(color: AppColors.primaryColor)),
                    icon: Icon(Icons.settings, color: AppColors.primaryColor)))
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(color: Colors.red, duration: Duration(seconds: 2)),
      ),
    );
  }
}
