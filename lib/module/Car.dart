import 'package:json_annotation/json_annotation.dart';

class Car {

  final int id;
  final String company;
  final String model;
  final String price;
  final String availability;
  final String location;
  final String image;

  Car({this.id,
    this.company,
    this.model,
    this.price,
    this.availability,
    this.location,
    this.image});

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
        id: json['id'],
        company: json['company'],
        model: json ['model'],
        price: json ['price'],
        availability: json ['availability'],
        location: json ['location'],
        image: json ['image']
    );
  }
}


