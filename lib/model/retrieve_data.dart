class Cart{
  late int id;
  late String date;
  late String title;
  late String Email;
  late String Uid;
  late String imageUrl;
  late int price;
  late int description;

  Cart(
      {
        required this.id,
        required this.date,
      required this.title,
      required this.Email,
      required this.Uid,
        required this.imageUrl,
        required this.description,
        required this.price,
      });

  Cart.fromMap(Map<dynamic, dynamic> map) :
      id = map['id'],
      date = map['date'],
      title = map['title'],
      Email = map['Email'],
      Uid = map['Uid'],
        imageUrl = map['imageUrl'],
        description = map['description'],
        price = map['price'];

  Map<String ,Object?> toMap(){
    return {
      'id' :id,
    'date' : date,
   'title' : title,
    'Email' :Email,
    'Uid' :Uid,
    'imageUrl' :imageUrl,
    'description' :description,
    'price':price,
    };
  }

}
