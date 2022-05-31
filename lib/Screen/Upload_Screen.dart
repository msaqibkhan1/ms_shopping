import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ms_shopping/Screen/Home_Screen.dart';

import 'loading.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? pickedImage;
  bool loading = false;

  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var priceController = TextEditingController();
  var oldPriceController = TextEditingController();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void dailog(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              Column(
                children: [
                  InkWell(
                    onTap: () async {
                      pickedimageCamera();
                      Navigator.of(context).pop();
                    },
                    child: const ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text('Camera'),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      pickedimageGallery();
                      Navigator.of(context).pop();
                    },
                    child: const ListTile(
                      leading: Icon(Icons.storage),
                      title: Text('Gallery'),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Upload Screen'),
      ),
      body: loading
          ? const Loading()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        dailog(context);
                      },
                      child: Container(
                          height: MediaQuery.of(context).size.height * .5,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                          ),
                          child: pickedImage != null
                              ? ClipRect(
                                  child: Image.file(
                                    pickedImage!.absolute,
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.contain,
                                  ),
                                )
                              : Container(
                                  height:
                                      MediaQuery.of(context).size.height * .5,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                  ),
                                  child: const Icon(Icons.camera_alt))),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Title',
                        labelText: 'Title',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Description',
                        labelText: 'Description',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: priceController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Price',
                        labelText: 'Price',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: oldPriceController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Old Price',
                        labelText: 'Old Price',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String title = titleController.text.trim();
          String description = descriptionController.text.trim();
          String price =priceController.text.trim();
          String oldPrice = oldPriceController.text.trim();

          if (pickedImage != null) {
            if (title.isEmpty || description.isEmpty || price.isEmpty || oldPrice.isEmpty) {
              Fluttertoast.showToast(msg: 'Please fill the TextField');
            } else {
              setState(() {
                loading = true;
              });
              try {
                int date = DateTime.now().millisecondsSinceEpoch;

                firebase_storage.Reference ref = firebase_storage
                    .FirebaseStorage.instance
                    .ref()
                    .child('Ms.khan')
                    .child("$date.jpg");
                UploadTask uploadTask = ref.putFile(pickedImage!.absolute);
                await Future.value(uploadTask);
                var newUrl = await ref.getDownloadURL();
                // upload to fireStore database
                final User? user = _auth.currentUser;
                await FirebaseFirestore.instance
                    .collection("images")
                    .doc(date.toString())
                    .set({
                  "imageUrl": newUrl,
                  'date': date.toString(),
                  'Uid': user!.uid,
                  'Email': user.email.toString(),
                  'title': titleController.text.toString(),
                  'description': descriptionController.text.toString(),
                  'price': priceController.text.trim(),
                  'oldPrice' : oldPriceController.text.trim(),
                }).then((value) {
                  Fluttertoast.showToast(msg: 'Post Published');
                  setState(() {
                    loading = false;
                  });
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const HomeScreen()));
                }).onError((error, stackTrace) {
                  Fluttertoast.showToast(msg: 'Try again');
                  setState(() {
                    loading = false;
                  });
                });
              } on FirebaseAuthException catch (e) {
                Fluttertoast.showToast(msg: e.message!);
                setState(() {
                  loading = false;
                });
              }
            }
          } else {
            Fluttertoast.showToast(msg: 'Please Select the image');
          }
        },
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.cloud_upload_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        //bottom navigation bar on scaffold
        color: Colors.orangeAccent,
        shape: const CircularNotchedRectangle(), //shape of notch
        notchMargin:
            5, //notche margin between floating button and bottom appbar
        child: Row(
          children: const <Widget>[
            SizedBox(
              height: 60,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: Center(child: Text('Upload')),
              ),
            )
          ],
        ),
      ),
    );
  }

//picked image with gallery
  pickedimageGallery() async {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return;

    pickedImage = File(file.path);
    setState(() {});
  }

  // picked image with Camera
  pickedimageCamera() async {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.camera);
    if (file == null) return;

    pickedImage = File(file.path);
    setState(() {});
  }
}
