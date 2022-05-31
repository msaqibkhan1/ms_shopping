import 'package:flutter/material.dart';
import 'package:ms_shopping/Screen/login_Screen.dart';
import 'package:ms_shopping/Selection/Admin_Confirmation.dart';
import 'package:ms_shopping/User_Screen/home_screen.dart';

class Selection extends StatefulWidget {
  const Selection({Key? key}) : super(key: key);

  @override
  State<Selection> createState() => _SelectionState();
}

class _SelectionState extends State<Selection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        title: const Text('Selection'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          //For Admin
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const Password()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height*.05,
                color: Colors.red,
                child: const Align(alignment: Alignment.center,
                    child: Text('Admin',style: TextStyle(color: Colors.white),)),
              ),
            ),
          ),

          // For User
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const UserHomeScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 12.0),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height*.05,
                color: Colors.black,
                child: const Align(alignment: Alignment.center,
                    child: Text('User',style: TextStyle(color: Colors.white),)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
