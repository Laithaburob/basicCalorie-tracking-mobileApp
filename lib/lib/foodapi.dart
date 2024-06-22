import 'dart:convert';
import 'package:firstproject/lib/foodlist.dart';
import 'package:http/http.dart' as http;

class Foodapi {
  // const axios = require('axios');
  //
  // const options = {
  //   method: 'GET',
  //   url: 'https://nutrition-by-api-ninjas.p.rapidapi.com/v1/nutrition',
  //   params: {
  //     query: '1lb brisket with fries'
  //   },
  //   headers: {
  //     'X-RapidAPI-Key': 'ee91acc5c3msh8acf838ccf2aac6p1dd219jsnd3cda9fe4652',
  //     'X-RapidAPI-Host': 'nutrition-by-api-ninjas.p.rapidapi.com'
  //   }
  // };
  static Future<List<Foodlist>> getFood(String name) async {
    var url = Uri.https(
        'nutrition-by-api-ninjas.p.rapidapi.com',
        '/v1/nutrition',
        {"query": "1lb ${name}"}
    );
    final response = await http.get(url, headers: {
      "X-RapidAPI-Key": "91d80a2a14mshd1dc87dd85d10b5p1eac91jsn4b0e9328e1fd",
      "X-RapidAPI-Host": "nutrition-by-api-ninjas.p.rapidapi.com"
    });

    List<dynamic> data = jsonDecode(response.body);

    List<Map<String, dynamic>> foodData = List<Map<String, dynamic>>.from(data);

    List<Foodlist> foodList = foodData
        .map((item) => Foodlist.fromJson(item))
        .toList();

    return foodList;
  }

}
