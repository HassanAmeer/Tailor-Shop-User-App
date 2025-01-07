import 'dart:io';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tailor_admin/constants/appColors.dart';
import 'package:tailor_admin/helpers/nullables.dart';
import 'package:tailor_admin/models/itemModel.dart';

import '../provider/auth.dart';

class EditItemPage extends StatefulWidget {
  final ItemModel data;

  const EditItemPage({super.key, required this.data});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  String? imageUrl;
  File? pickedImage;

  @override
  void initState() {
    super.initState();
    fetchItemData();
  }

  /// Fetch the item's current data from Firestore
  Future<void> fetchItemData() async {
    try {
      setState(() {
        titleController.text = widget.data.title.toString().toNullString();
        sizeController.text = widget.data.size.toString().toNullString();
        descController.text = widget.data.desc.toString().toNullString();
        priceController.text = widget.data.price.toString().toNullString();
        imageUrl = widget.data.image.toString().toNullString();
      });
    } catch (e) {
      EasyLoading.showError("Error loading item data: $e");
    }
  }

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

  /// Save updated data to Firestore
  Future<void> saveItemData() async {
    try {
      EasyLoading.show(status: "Updating item...");

      String? uploadedImageUrl =
          pickedImage != null ? await uploadImageToCloudinary() : imageUrl;

      Map<String, dynamic> updatedData = {
        'title': titleController.text,
        'size': sizeController.text,
        'desc': descController.text,
        'price': double.tryParse(priceController.text) ?? 0.0,
        'image': uploadedImageUrl,
      };

      await FirebaseFirestore.instance
          .collection('items')
          .doc(widget.data.id)
          .update(updatedData);
      Provider.of<AuthVm>(context, listen: false).getItmesF();
      EasyLoading.showSuccess("Item updated successfully!");
      Navigator.pop(context);
    } catch (e, st) {
      debugPrint("💥 Error updating item: $e, st:$st");
      EasyLoading.showError("Error updating item: $e");
    }
  }

  /// Pick a new image
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
        appBar: AppBar(title: const Text("Edit Item")),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(children: [
              // Title
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              // Size
              TextField(
                controller: sizeController,
                decoration: const InputDecoration(
                  labelText: "Size",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Price
              TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: "Price", border: OutlineInputBorder())),
              const SizedBox(height: 16),
              // Description
              TextField(
                  controller: descController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                      labelText: "Description", border: OutlineInputBorder())),
              const SizedBox(height: 16),
              // Image picker
              InkWell(
                  onTap: pickImage,
                  child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      child: pickedImage != null
                          ? Image.file(pickedImage!, fit: BoxFit.cover)
                          : imageUrl != null
                              ? Image.network(imageUrl!, fit: BoxFit.cover)
                              : const Icon(Icons.camera_alt,
                                  color: Colors.grey, size: 50))),
              const SizedBox(height: 16),

              OutlinedButton.icon(
                      onPressed: saveItemData,
                      icon: Icon(Icons.edit),
                      label: const Text("Save Changes"))
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(
                      duration: const Duration(seconds: 2),
                      color: AppColors.primaryColor.withOpacity(0.4))
            ])));
  }
}
