import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ProfilePage extends StatefulWidget {
  final String name;
  final String email;
  ProfilePage({required this.name, required this.email});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String imagePath = '';
  final picker = ImagePicker();

  Future<void> _showDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text('Select image from gallery'),
                  onTap: () {
                    selectImage();
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text('Take a photo'),
                  onTap: () {
                    takePhoto();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  void selectImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File? croppedFile = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      if (croppedFile != null) {
        setState(() {
          imagePath = croppedFile.path;
        });
      }
    }
  }

  void takePhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File? croppedFile = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      if (croppedFile != null) {
        setState(() {
          imagePath = croppedFile.path;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.brown,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white.withOpacity(0.5),
              child: imagePath != ''
                  ? Image.file(File(imagePath))
                  : IconButton(
                      iconSize: 50,
                      icon: Icon(
                        Icons.add_a_photo,
                      ),
                      onPressed: _showDialog,
                    ),
            ),
            ListTile(
              title: Text(
                'Name: ${widget.name}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: null,
              ),
            ),
            ListTile(
              title: Text(
                'E-mail: ${widget.email}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: null,
              ),
            )
          ],
        ),
      ),
    );
  }
}
