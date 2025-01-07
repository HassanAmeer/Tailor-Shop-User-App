import 'dart:io';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tailor_admin/provider/auth.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  File? pickedImage;

  /// Upload the image to Cloudinary
  Future<String?> uploadImageToCloudinary() async {
    if (pickedImage == null) return null;

    try {
      final cloudinary = Cloudinary.signedConfig(
        apiKey: "191182111899947",
        apiSecret: "cqOT8xRwcZoaaw9z0bm9bIsQDYE",
        cloudName: "dal3uq1y5",
      );

      final response = await cloudinary.upload(
          file: pickedImage!.path,
          fileBytes: await pickedImage!.readAsBytes(),
          resourceType: CloudinaryResourceType.image,
          folder: 'items',
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

  /// Save the new item to Firestore
  Future<void> saveNewItem() async {
    try {
      EasyLoading.show(status: "Adding new item...");

      // Upload image to Cloudinary
      String? uploadedImageUrl = await uploadImageToCloudinary();
      if (uploadedImageUrl == null) {
        EasyLoading.showError("Please select an image");
        return;
      }

      // Prepare data
      Map<String, dynamic> newItemData = {
        'title': titleController.text,
        'size': sizeController.text,
        'desc': descController.text,
        'price': double.tryParse(priceController.text) ?? 0.0,
        'image': uploadedImageUrl,
        'updateAt': FieldValue.serverTimestamp(),
      };

      // Save to Firestore
      await FirebaseFirestore.instance.collection('items').add(newItemData);
      Provider.of<AuthVm>(context, listen: false).getItmesF();
      EasyLoading.showSuccess("Item added successfully!");
      Navigator.pop(context);
    } catch (e, st) {
      debugPrint("💥 Error adding item: $e, st:$st");
      EasyLoading.showError("Error adding item: $e");
    }
  }

  /// Pick an image from the gallery
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        pickedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add New Item")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Title
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Size
            TextField(
              controller: sizeController,
              decoration: const InputDecoration(
                labelText: "Size",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Description
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Price
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Price",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Image Picker
            InkWell(
              onTap: pickImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: pickedImage != null
                    ? Image.file(
                        pickedImage!,
                        fit: BoxFit.cover,
                      )
                    : const Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                        size: 50,
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Add Button
            ElevatedButton(
              onPressed: saveNewItem,
              child: const Text("Add Item"),
            ),
          ],
        ),
      ),
    );
  }
}
