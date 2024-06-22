import 'dart:convert';

import 'package:firstproject/lib/foodapi.dart';
import 'package:firstproject/lib/foodlist.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firstproject/signup.dart';
import 'package:firstproject/lib/foodlist.dart';
import 'package:firstproject/lib/foodapi.dart';
import 'package:firstproject/main.dart';

export 'lib/second.dart';
class DetailPage extends StatefulWidget {
  List<Foodlist> _foodlists = [];

  DetailPage(this._foodlists);

  String name='';
  bool _isLoading = true;

  @override
  State<DetailPage> createState() => _DetailPageState();


}

class _DetailPageState extends State<DetailPage> {
  List<Foodlist> _foodlists = [];
  String name = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getFood();
  }

  Future<void> getFood() async {
    _foodlists = await Foodapi.getFood(name);

    setState(() {
      _isLoading = false;
    });

    for (int i = 0; i < _foodlists.length; i++) {
      if (_foodlists[i].serving > 1) {
        _foodlists[i].fat_total =
            _foodlists[i].fat_total / _foodlists[i].serving;
        _foodlists[i].calories = _foodlists[i].calories / _foodlists[i].serving;
        _foodlists[i].protein = _foodlists[i].protein / _foodlists[i].serving;
        _foodlists[i].carbohydrates =
            _foodlists[i].carbohydrates / _foodlists[i].serving;
        _foodlists[i].serving = _foodlists[i].serving / _foodlists[i].serving;
        _foodlists[i].fat_total =
            double.parse(_foodlists[i].fat_total.toStringAsFixed(2));
        _foodlists[i].calories =
            double.parse(_foodlists[i].calories.toStringAsFixed(2));
        _foodlists[i].protein =
            double.parse(_foodlists[i].protein.toStringAsFixed(2));
        _foodlists[i].carbohydrates =
            double.parse(_foodlists[i].carbohydrates.toStringAsFixed(2));
      }
      else {
        _foodlists[i].serving = _foodlists[i].serving / _foodlists[i].serving;
        _foodlists[i].fat_total =
            double.parse(_foodlists[i].fat_total.toStringAsFixed(2));
        _foodlists[i].calories =
            double.parse(_foodlists[i].calories.toStringAsFixed(2));
        _foodlists[i].protein =
            double.parse(_foodlists[i].protein.toStringAsFixed(2));
        _foodlists[i].carbohydrates =
            double.parse(_foodlists[i].carbohydrates.toStringAsFixed(2));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('List Display Example'),
        ),
        body: ListView.separated(
          itemCount: _foodlists.length,
          separatorBuilder: (context, index) => Divider(), // Add a divider
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                _foodlists[index].name,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}