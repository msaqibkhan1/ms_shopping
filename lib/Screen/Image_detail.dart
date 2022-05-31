import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:ms_shopping/Screen/Home_Screen.dart';
import 'package:ms_shopping/Screen/Update_Screen.dart';
import 'package:ms_shopping/model/CartProvider.dart';
import 'package:ms_shopping/model/Post_model.dart';
import 'package:provider/provider.dart';

class ImageDetail extends StatefulWidget {
  final PostModel postModel;

  const ImageDetail({
    Key? key,
    required this.postModel,
  }) : super(key: key);

  @override
  State<ImageDetail> createState() => _ImageDetailState();
}

class _ImageDetailState extends State<ImageDetail> {
  bool _ispressed = false;

  Future refresh() async {
    setState(() {});
    return await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(widget.postModel.title + ' Detail'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Confirmation...!'),
                      content: const Text('Are you sure to Delete'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            var storage =
                                FirebaseStorage.instance.ref().child('Ms.khan');
                            storage
                                .child(widget.postModel.id + ".jpg")
                                .delete();
                            var collection =
                                FirebaseFirestore.instance.collection('images');
                            collection.doc(widget.postModel.id).delete();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()));
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    );
                  });
            },
            icon: const Icon(Icons.delete_rounded),
          ),
          const SizedBox(
            width: 10,
          ),
          Center(
            child: Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child) {
                  return Text(value.getCounter().toString());
                },
              ),
              animationDuration: const Duration(milliseconds: 300),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade200,
      body: LiquidPullToRefresh(
        onRefresh: refresh,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Container(
                  height: MediaQuery.of(context).size.height * .5,
                  width: double.infinity,
                  decoration: const BoxDecoration(),
                  child: Image.network(
                    widget.postModel.imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.postModel.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Price',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              widget.postModel.price,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Old Price',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              widget.postModel.oldPrice,
                              style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Description',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: const BoxDecoration(),
                      child: Text(
                          "                 " + widget.postModel.description),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateScreen(
                                        postModel: PostModel(
                                            id: widget.postModel.id,
                                            date: widget.postModel.date,
                                            Email: widget.postModel.Email,
                                            Uid: widget.postModel.Uid,
                                            title: widget.postModel.title,
                                            description:
                                                widget.postModel.description,
                                            imageUrl: widget.postModel.imageUrl,
                                            price: widget.postModel.price,
                                            oldPrice:
                                                widget.postModel.oldPrice),
                                      )));
                        },
                        child: const Icon(Icons.update))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: widget.postModel.id == null ?
      // _ispressed == true?
      BottomAppBar(
              color: Colors.orangeAccent,
              // shape: const CircularNotchedRectangle(), //shape of notch
              child: InkWell(
                onTap: () {
                  cart.removeCounter();
                  setState(() {
                    _ispressed = false;
                  });
                },
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .07,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [Icon(Icons.shopping_cart), Text('Add')],
                  ),
                ),
              ),
            )
          : BottomAppBar(
              color: Colors.orangeAccent,
              // shape: const CircularNotchedRectangle(), //shape of notch
              child: InkWell(
                onTap: () async {
                  uploadCart() ;
                },
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .07,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.shopping_cart),
                      Text('Add To Cart')
                    ],
                  ),
                ),
              ),
            ),
    );
  }
  void uploadCart() async{

    final cart = Provider.of<CartProvider>(context);
    await FirebaseFirestore.instance
        .collection("Cart")
        .doc(widget.postModel.Email).collection('Your CartReview').doc(widget.postModel.id)
        .set({
      'Email': widget.postModel.Email,
      'imageUrl': widget.postModel.imageUrl,
      'price': widget.postModel.price,
      'oldPrice': widget.postModel.oldPrice,
    })
        .then((value) => {
      Fluttertoast.showToast(msg: 'product add to cart'),
      cart.addTotalPrice(
          double.parse(widget.postModel.price)),
      cart.addCounter(),
      setState(() {
        _ispressed = true;
      }),
    })
        .onError((error, stackTrace) => {});
  }
}