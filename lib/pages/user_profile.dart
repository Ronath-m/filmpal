import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late File _imageFile;
  final _picker = ImagePicker();
  final _auth = FirebaseAuth.instance;
  late String _userId;
  bool _loading = true;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _userId = _auth.currentUser!.uid;
    _checkProfileImage();
  }

  Future<void> _checkProfileImage() async {
    try {
      final Reference storageRef =
          FirebaseStorage.instance.ref().child('profile_images/$_userId.png');
      final String downloadURL = await storageRef.getDownloadURL();
      setState(() {
        _imageUrl = downloadURL;
        _loading = false;
      });
    } catch (e) {
      print('Profile image not found for $_userId: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _getImageFromCamera() async {
    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImage() async {
    try {
      if (_imageFile == null) {
        // No image to upload
        return;
      }

      final Reference storageRef =
          FirebaseStorage.instance.ref().child('profile_images/$_userId.png');
      await storageRef.putFile(_imageFile);

      // Get the download URL
      final String downloadURL = await storageRef.getDownloadURL();

      // Save the download URL in Firestore or wherever you store user data
      print('Image uploaded. Download URL: $downloadURL');
      setState(() {
        _imageUrl = downloadURL;
      });
    } catch (e) {
      print('Error uploading image: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(
            255, 213, 211, 211), // Set the background color of the app bar
      ),
      body: Container(
        color: Colors.black, // Set black background color
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _loading
                  ? CircularProgressIndicator()
                  : _imageUrl != null
                      ? CircleAvatar(
                          radius: 80,
                          backgroundImage: NetworkImage(_imageUrl!),
                        ) // Display image if available
                      : Container(
                          color: const Color.fromARGB(
                              255, 255, 254, 254), // Placeholder color
                          width: 200,
                          height: 200,
                        ),
              SizedBox(height: 20),
              Text(
                _auth.currentUser!.email ?? '', // Display email
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getImageFromCamera();
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
