import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String id;
  String date;
  String Email;
  String Uid;
  String title;
  String description;
  String imageUrl;
  String price;
  String oldPrice;

  PostModel(
      {
        required this.id,
        required this.date,
        required this.Email,
        required this.Uid,
        required this.title,
        required this.description,
        required this.imageUrl,
        required this.price,
        required this.oldPrice,
      });

  factory PostModel.fromjson(DocumentSnapshot map) {
    return PostModel(
      id: map.id,
      date: map['date'],
      Email: map['Email'],
      Uid: map['Uid'],
      title: map['title'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      price: map['price'],
      oldPrice: map['oldPrice'],
    );
  }
}
