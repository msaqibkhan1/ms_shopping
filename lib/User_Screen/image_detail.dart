import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:ms_shopping/model/CartProvider.dart';
import 'package:ms_shopping/model/Post_model.dart';
import 'package:provider/provider.dart';

class UserImageDetail extends StatefulWidget {
  PostModel postModel;

  UserImageDetail({
    Key? key,
    required this.postModel,
  }) : super(key: key);

  @override
  State<UserImageDetail> createState() => _UserImageDetailState();
}

class _UserImageDetailState extends State<UserImageDetail> {
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          color: Colors.orangeAccent,
          // shape: const CircularNotchedRectangle(), //shape of notch
          child: InkWell(
            onTap: () {
              //Cart(id: index, date: date, title: title, Email: Email, Uid: Uid, imageUrl: imageUrl, description: description, price: price)
              widget.postModel.date;
              cart.addTotalPrice(
                  double.parse(widget.postModel.price.toString()));
              cart.addCounter();
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
          )),
    );
  }
}
// Row(
//   children: [
//     Container(
//       height: 40,
//       width: 40,
//       decoration: const BoxDecoration(
//           borderRadius:
//               BorderRadius.all(Radius.circular(15.0)),
//           color: Colors.white),
//       child: const Center(child: Text("+")),
//     ),
//     const SizedBox(
//       width: 3,
//     ),
//     Container(
//       height: 40,
//       width: 50,
//       decoration: const BoxDecoration(
//           borderRadius:
//               BorderRadius.all(Radius.circular(12.0)),
//           color: Colors.white),
//       child: const Center(child: Text("1")),
//     ),
//     const SizedBox(
//       width: 3,
//     ),
//     Container(
//       height: 40,
//       width: 40,
//       decoration: const BoxDecoration(
//           borderRadius:
//               BorderRadius.all(Radius.circular(15.0)),
//           color: Colors.white),
//       child: const Center(
//         child: Text(
//           "-",
//           style:
//               TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
//     )
//   ],
// ),
