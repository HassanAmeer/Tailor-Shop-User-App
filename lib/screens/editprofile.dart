import 'dart:io';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/appColors.dart';
import '../constants/appImages.dart';
import '../screens/homepage.dart';

import '../widgets/logout.dart';
import '../widgets/toast.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => Edit_ProfilePageState();
}

class Edit_ProfilePageState extends State<EditProfilePage> {
  final emailContr = TextEditingController();
  final nameContr = TextEditingController();
  final phoneContr = TextEditingController();

  bool isEditing = false;
  XFile? _profileImage;
  String? uid;

  // Initial values for comparison
  String? name;
  String? phone;
  String? email;
  String? initialProfileImagePath;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<bool> _onWillPop() async {
    // Navigate to HomePage instead of exiting the app
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (Route<dynamic> route) => false);
    return false; // Prevent default back navigation
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      uid = user.uid;

      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        setState(() {
          nameContr.text = name = data['name'] ?? '';
          phoneContr.text = phone = data['phone'] ?? '';
          emailContr.text = email = data['email'] ?? '';

          initialProfileImagePath =
              prefs.getString('profileImage') ?? data['profileImage'];
          if (initialProfileImagePath != null) {
            _profileImage = XFile(initialProfileImagePath!);
          }
        });
      }
    }
  }

  void _toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = pickedImage;
    });
  }

  Future<String?> _uploadImage() async {
    if (_profileImage == null) return null;
    try {
      final cloudinary = Cloudinary.signedConfig(
        apiKey: "191182111899947",
        apiSecret: "cqOT8xRwcZoaaw9z0bm9bIsQDYE",
        cloudName: "dal3uq1y5",
      );

      final response = await cloudinary.upload(
          file: _profileImage!.path,
          fileBytes: await _profileImage!.readAsBytes(),
          resourceType: CloudinaryResourceType.image,
          folder: 'profile_images',
          fileName: '${DateTime.now().millisecondsSinceEpoch}',
          progressCallback: (count, total) {
            print('Uploading image from file with progress: $count/$total');
          });

      if (response.isSuccessful) {
        // print('👉 img resp: ${response}');
        // print('👉Get your image from with ${response.secureUrl}');
      }

      return response.secureUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Future<String?> _uploadImage() async {
  //   if (_profileImage == null) return null;
  //   try {
  //     final storageRef = FirebaseStorage.instance
  //         .ref()
  //         .child('profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
  //     await storageRef.putFile(File(_profileImage!.path));
  //     return await storageRef.getDownloadURL();
  //   } catch (e) {
  //     print('Error uploading image: $e');
  //     return null;
  //   }
  // }

  bool _hasChanges() {
    return nameContr.text != name ||
        phoneContr.text != phone ||
        emailContr.text != email ||
        (_profileImage != null &&
            _profileImage?.path != initialProfileImagePath);
  }

  Future<void> _saveProfileData() async {
    if (!_hasChanges()) {
      snackBarColorF("No changes made", context);
      return;
    }

    EasyLoading.showSuccess("Updating Profile");

    String? imageUrl = await _uploadImage();

    if (imageUrl != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImage', imageUrl);
    }

    Map<String, dynamic> userData = {
      'name': nameContr.text,
      'phone': phoneContr.text,
      'email': emailContr.text,
      'profileImage': imageUrl ?? initialProfileImagePath,
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update(userData);
    snackBarColorF("Profile updated successfully", context);

    Navigator.pop(context);

    setState(() {
      isEditing = false;
      name = nameContr.text;
      phone = phoneContr.text;
      email = emailContr.text;
      initialProfileImagePath = imageUrl ?? initialProfileImagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile',
              style: TextStyle(color: Colors.white, fontSize: 24)),
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            // icon: const Icon(Icons.arrow_back_ios, color: )),// Back arrow icon
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          actions: [
            IconButton(
              icon: Icon(isEditing ? Icons.check : Icons.edit),
              onPressed: () {
                if (isEditing) {
                  _saveProfileData();
                } else {
                  _toggleEdit();
                }
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width * 0.20,
                        backgroundColor: Colors.white,
                        backgroundImage: _profileImage != null &&
                                File(_profileImage!.path).existsSync()
                            ? FileImage(File(_profileImage!.path))
                                as ImageProvider<
                                    Object> // Cast to ImageProvider<Object>
                            : (initialProfileImagePath !=
                                        null &&
                                    initialProfileImagePath!.startsWith('http'))
                                ? NetworkImage(
                                        initialProfileImagePath!)
                                    as ImageProvider<
                                        Object> // Cast to ImageProvider<Object>
                                : const AssetImage(
                                    AppImages
                                        .profile) as ImageProvider<
                                    Object>, // Cast to ImageProvider<Object>
                        child: _profileImage == null &&
                                (initialProfileImagePath == null ||
                                    !initialProfileImagePath!
                                        .startsWith('http'))
                            ? const Icon(Icons.person,
                                size: 60, color: Colors.grey)
                            : null,
                      ),
                      if (isEditing)
                        Positioned(
                          bottom: 0,
                          right: -10,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt,
                                color: AppColors.primaryColor, size: 30),
                            onPressed: _pickImage,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                buildProfileField("Name", nameContr, isEditing),
                buildProfileField("Phone Number", phoneContr, isEditing),
                buildProfileField("Email", emailContr, isEditing,
                    isReadOnly: true),
                const SizedBox(height: 20),
                MainButton(
                  onPressed: isEditing ? _saveProfileData : _toggleEdit,
                  child: Text(
                    isEditing ? "Save" : "Edit",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Logout().exitDialoge(context);
                    },
                    label: Text(
                      "Logout",
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                    icon: Icon(
                      Icons.logout_outlined,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProfileField(
      String label, TextEditingController controller, bool isEnabled,
      {bool isReadOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        CustomTextField(
            controller: controller,
            // isEnabled: isEnabled,
            readOnly: isReadOnly,
            hintText: ''),
        const SizedBox(height: 10),
      ],
    );
  }
}

class MainButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  const MainButton({super.key, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.0),
          gradient: LinearGradient(
            colors: [
              Colors.indigoAccent.withOpacity(0.9),
              // Colors.indigo.withOpacity(0.7),
              Color.fromARGB(255, 70, 5, 210).withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: child,
        )),
      ),
    );
  }
}
