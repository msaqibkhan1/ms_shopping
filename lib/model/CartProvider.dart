import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier{
  int _counter=0;
  int get totalCounter => _counter;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  void _setPrefItem() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('cart_item', _counter);
    pref.setDouble('total_price', _totalPrice);
    notifyListeners();
  }
  void _getPrefItem() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    _counter= pref.getInt('cart_item') ?? 0;
    _totalPrice = pref.getDouble('total_price') ?? 0.0;
    notifyListeners();
  }
  // price
  void addTotalPrice(double productPrice){
    _totalPrice = _totalPrice + productPrice;
    _setPrefItem();
    notifyListeners();
  }
  void removeTotalPrice(double productPrice){
    _totalPrice = _totalPrice-productPrice;
    _setPrefItem();
    notifyListeners();
  }
  double getTotalPrice(){
    _getPrefItem();
    return _totalPrice;
  }

  // Counter
  void addCounter(){
    _counter++;
    _setPrefItem();
    notifyListeners();
  }

  void removeCounter(){
    _counter--;
    _setPrefItem();
    notifyListeners();
  }
  int getCounter(){
    _getPrefItem();
    return _counter;
  }
}