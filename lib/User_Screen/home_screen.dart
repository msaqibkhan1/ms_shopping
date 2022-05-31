import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ms_shopping/Screen/Image_detail.dart';
import 'package:ms_shopping/model/Post_model.dart';

import '../Screen/Setting.dart';
import '../Screen/login_Screen.dart';
import 'image_detail.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String? name;
  bool loading = false;
  final dataRef = FirebaseDatabase.instance.ref().child('Users');

  _getUserDetails() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DatabaseEvent event = await dataRef.child(uid).once();

    Map<String, dynamic> userMap =
    Map<String, dynamic>.from(event.snapshot.value as Map);

    name = userMap['userName'];
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                padding: EdgeInsets.zero,
                child: Container(
                  color: Colors.orangeAccent,
                  child: Center(
                      child: Text(
                        name == null ? '' : name!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                )),
            const ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
            ),
            const ListTile(
              leading: Icon(Icons.feedback),
              title: Text('Feedback'),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Setting()));
              },
              child: const ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
            ),
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Confirmation...'),
                        content: const Text('Do you want to logout'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('No')),
                          TextButton(
                              onPressed: () {
                                FirebaseAuth.instance.signOut();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) {
                                      return const LoginScreen();
                                    }));
                              },
                              child: const Text('Yes')),
                        ],
                      );
                    });
              },
              child: const ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(name == null ? '' : name!),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("images").snapshots(),
        builder: (context, AsyncSnapshot snapshots) {
          if (snapshots.hasData) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              primary: true,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250, mainAxisExtent: 260),
              itemCount: snapshots.data!.docs.length,
              itemBuilder: (context, index) {
                PostModel postModel = PostModel.fromjson(snapshots.data!.docs[index]);
                if (snapshots.hasData) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserImageDetail(postModel: postModel,),
                        ),
                      );
                    },
                    child: Detail(
                      postModel: postModel,),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class Detail extends StatelessWidget {
  PostModel postModel;
  Detail(
      {Key? key,
        required this.postModel,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GridTile(
        footer: Container(
          height: 60,
          color: Colors.orange.withOpacity(.7),
          child: ListTile(
            title: Text(postModel.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )),
            subtitle : Text(
              "                  Rs " + postModel.price,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.white),
            ),
          ),
        ),
        child: Image.network(
          postModel.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
