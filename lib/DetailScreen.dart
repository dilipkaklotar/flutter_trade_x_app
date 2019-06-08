import 'package:flutter/material.dart';
import 'package:flutter_trade_x_app/module/Car.dart';

class DetailScreen extends StatelessWidget {
  final Car car;

  DetailScreen({Key key, @required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(car.model),
      ),
      body: Image.asset("images/" + car.image),
    );
  }
} 
