import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  Future refresh()async{
    setState(() {
    });
    return await Future.delayed(const Duration(seconds: 2));
  }

  final dataRep= FirebaseDatabase.instance.ref().child('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LiquidPullToRefresh(
        onRefresh: refresh,
        child: FirebaseAnimatedList(
          query: dataRep,
          itemBuilder: (BuildContext context,DataSnapshot snapshot,Animation<double> animation, int index){
            var data = snapshot.value as Map;
            return ListTile(
            title: Text(data['email']),
            );
          },
        ),
      ),
    );
  }
}
