import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_trade_x_app/DetailScreen.dart';
import 'package:flutter_trade_x_app/module/Car.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.light(),
    home: HomeApp(),
  ));
}

const Color bodyBackground = Color(0xFFFFFFFF);
const Color car_text_color = Color(0xFF252B3D);

List<Car> carList = new List<Car>();

class HomeApp extends StatefulWidget {
  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Car> parseJson(String response) {
    if (response == null) {
      return [];
    }
    final parsed =
        json.decode(response.toString()).cast<Map<String, dynamic>>();
    return parsed.map<Car>((json) => new Car.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "browse cars",
          style: TextStyle(
              fontFamily: "Roboto", fontSize: 25.0, color: Colors.black),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: bodyBackground,
          appBar: AppBar(
            title: TextField(
              decoration: InputDecoration(
                hintText: "Search by name, brand",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[500],
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            bottom: TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              labelStyle: TextStyle(
                fontSize: 16.0,
                fontFamily: "PatuaOne",
                fontStyle: FontStyle.normal,
              ),
              tabs: [
                Tab(
                  text: "Market",
                ),
                Tab(
                  text: "Auction",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                child: FutureBuilder(
                  future: DefaultAssetBundle.of(context)
                      .loadString('assets/data/cars.json'),
                  builder: (context, snapshot) {
                    var data = json.decode(snapshot.data);
                    var rest = data['cars'] as List;

                    carList =
                        rest.map<Car>((json) => Car.fromJson(json)).toList();

                    return snapshot.data != null
                        ? CarGrid(carList)
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  },
                ),
              ),
              Icon(Icons.directions_transit),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.local_car_wash),
            title: Text(''),
            backgroundColor: bodyBackground,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text(''),
            backgroundColor: bodyBackground,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            title: Text(''),
            backgroundColor: bodyBackground,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            title: Text(''),
            backgroundColor: bodyBackground,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}

class CarGrid extends StatefulWidget {
  var data;

  CarGrid(var data) {
    this.data = data;
  }

  @override
  _CarGridState createState() => _CarGridState(data);
}

class _CarGridState extends State<CarGrid> {
  var data;

  _CarGridState(var data) {
    this.data = data;
  }

  Card makeGridCell(String company, String model, String price,
      String availability, String location, String image) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Text(
                    company,
                    style: TextStyle(
                        fontFamily: "sans-serif",
                        fontSize: 15.0,
                        color: car_text_color),
                  ),
                ),
                Expanded(
                  child: Text(
                    "\$ $price USD",
                    style: TextStyle(
                        fontFamily: "RobotoMono",
                        fontSize: 12.0,
                        color: car_text_color),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: 60.0,
                  child: Image.asset("images/" + image),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: Text(
                    location,
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 12.0,
                        color: Colors.grey),
                  ),
                ),
                Expanded(
                  child: Text(
                    model,
                    style: TextStyle(
                        fontFamily: 'PatuaOne',
                        fontSize: 13.0,
                        color: car_text_color),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              color: Colors.transparent,
              child: new Container(
                  decoration: new BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: new BorderRadius.only(
                        topRight: const Radius.circular(5.0),
                        bottomLeft: const Radius.circular(5.0),
                      )),
                  child: new RotatedBox(
                    quarterTurns: -1,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 5.0, bottom: 5.0, left: 8.0, right: 8.0),
                      child: new Text(
                        "IN STOCK",
                        style: TextStyle(color: Colors.white, fontSize: 11.0),
                      ),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      primary: true,
      padding: EdgeInsets.all(0.5),
      crossAxisCount: 2,
      childAspectRatio: 1.0,
      mainAxisSpacing: 1.0,
      crossAxisSpacing: 1.0,
      children: List.generate(carList.length, (index) {
        return Center(
          child: GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(car: carList[index]),
                ),
              );
            },
            child: makeGridCell(
                carList[index].company,
                carList[index].model,
                carList[index].price,
                carList[index].availability,
                carList[index].location,
                carList[index].image),
          ),
        );
      }),

    );
  }
}
