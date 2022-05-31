import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ms_shopping/Screen/Home_Screen.dart';

class Password extends StatefulWidget {
  const Password({Key? key}) : super(key: key);

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  //String password = 'mskhan1234';
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text('Admin Password'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          InkWell(
            onTap: (){
              String pass= passwordController.text.trim();
              if(pass.isEmpty){
                Fluttertoast.showToast(msg: 'please Enter the Password');
              }
              else if (pass == 'mskhan1234'){
                Fluttertoast.showToast(msg: 'Congratulation your Password is Correct');
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
              }
              else{
                Fluttertoast.showToast(msg: 'Sorry Wrong Password');
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height*.05,
                color: Colors.red,
                child: const Align(alignment: Alignment.center,
                    child: Text('Check',style: TextStyle(color: Colors.white),)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

