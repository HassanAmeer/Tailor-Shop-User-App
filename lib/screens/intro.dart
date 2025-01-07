import 'dart:io';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class UpdateIntroSections extends StatefulWidget {
  const UpdateIntroSections({super.key});

  @override
  State<UpdateIntroSections> createState() => _UpdateIntroSectionsState();
}

class _UpdateIntroSectionsState extends State<UpdateIntroSections> {
  List<Map<String, dynamic>> introData = [];
  List<File?> updatedImages = [];
  bool isShow = false;

  /// Fetch intro data from Firestore
  Future<void> fetchIntroData() async {
    try {
      EasyLoading.show(status: "Loading data...");
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('app_settings')
          .doc("intro")
          .get();

      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
      List<dynamic>? fetchedData = data?['intro'] as List<dynamic>?;
      if (fetchedData != null) {
        introData =
            fetchedData.map((e) => Map<String, dynamic>.from(e)).toList();
        updatedImages = List<File?>.filled(introData.length, null);
      }
      isShow = data?['show'] as bool;
      EasyLoading.dismiss();
      setState(() {});
    } catch (e) {
      EasyLoading.showError("Failed to fetch data: $e");
    }
  }

  /// Upload image to Cloudinary
  Future<String?> uploadImageToCloudinary(File image) async {
    try {
      final cloudinary = Cloudinary.signedConfig(
        apiKey: "191182111899947",
        apiSecret: "cqOT8xRwcZoaaw9z0bm9bIsQDYE",
        cloudName: "dal3uq1y5",
      );

      final response = await cloudinary.upload(
          file: image.path,
          fileBytes: await image.readAsBytes(),
          resourceType: CloudinaryResourceType.image,
          folder: 'profile_images',
          fileName: '${DateTime.now().millisecondsSinceEpoch}',
          progressCallback: (count, total) {
            print('Uploading image from file with progress: $count/$total');
          });

      return response.secureUrl;
    } catch (e) {
      EasyLoading.showError("Error uploading image: $e");
      return null;
    }
  }

  /// Save updated intro data
  Future<void> saveIntroData() async {
    try {
      EasyLoading.show(status: "Saving data...");

      // Update images
      for (int i = 0; i < updatedImages.length; i++) {
        if (updatedImages[i] != null) {
          String? imageUrl = await uploadImageToCloudinary(updatedImages[i]!);
          if (imageUrl != null) {
            introData[i]['image'] = imageUrl;
          }
        }
      }

      // Update Firestore document
      await FirebaseFirestore.instance
          .collection('app_settings')
          .doc("intro")
          .update({'intro': introData});

      EasyLoading.showSuccess("Intro sections updated successfully!");
      Navigator.pop(context);
    } catch (e) {
      EasyLoading.showError("Error saving data: $e");
    }
  }

  /// Pick an image for a specific section
  Future<void> pickImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        updatedImages[index] = File(pickedFile.path);
      });
    }
  }

  showHideF(v) async {
    EasyLoading.show(status: "Saving data...");
    await FirebaseFirestore.instance
        .collection('app_settings')
        .doc("intro")
        .update({'show': v});
    isShow = v;
    setState(() {});
    EasyLoading.showSuccess("Saved");
  }

  @override
  void initState() {
    super.initState();
    fetchIntroData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Intro Sections")),
      body: introData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Show/Hide Toggle
                SwitchListTile(
                    title: const Text("Show Introduction Pages"),
                    value: isShow,
                    onChanged: showHideF),
                Divider(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: ScrollController(),
                      itemCount: introData.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                TextField(
                                  decoration: const InputDecoration(
                                    labelText: "Title",
                                    border: OutlineInputBorder(),
                                  ),
                                  controller: TextEditingController(
                                      text: introData[index]['title']),
                                  onChanged: (value) =>
                                      introData[index]['title'] = value,
                                ),
                                const SizedBox(height: 8),

                                // Description
                                TextField(
                                  decoration: const InputDecoration(
                                    labelText: "Description",
                                    border: OutlineInputBorder(),
                                  ),
                                  controller: TextEditingController(
                                      text: introData[index]['desc']),
                                  maxLines: 3,
                                  onChanged: (value) =>
                                      introData[index]['desc'] = value,
                                ),
                                const SizedBox(height: 8),

                                // Image Picker
                                InkWell(
                                  onTap: () => pickImage(index),
                                  child: Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: updatedImages[index] != null
                                        ? Image.file(
                                            updatedImages[index]!,
                                            fit: BoxFit.cover,
                                          )
                                        : introData[index]['image'] != null
                                            ? Image.network(
                                                introData[index]['image'],
                                                fit: BoxFit.cover,
                                              )
                                            : const Icon(
                                                Icons.camera_alt,
                                                color: Colors.grey,
                                                size: 50,
                                              ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: saveIntroData,
        icon: const Icon(Icons.save),
        label: const Text("Save Changes"),
      ),
    );
  }
}
