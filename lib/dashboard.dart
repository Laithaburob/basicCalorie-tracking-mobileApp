import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:firstproject/lib/foodapi.dart';
import 'package:firstproject/lib/foodlist.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firstproject/signup.dart';
import 'package:firstproject/lib/foodlist.dart';
import 'package:firstproject/lib/foodapi.dart';
import 'package:firstproject/lib/main.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  DietAppDashboard createState() => DietAppDashboard();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diet App Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashPage(password: '', nameController: '',),
    );
  }
}
class DashPage extends StatefulWidget {
  final String nameController;
  final String password;
  final String? date;
  DashPage({Key? key, required this.nameController,required this.password,this.date}) : super(key: key);

  @override
  DietAppDashboard createState() => DietAppDashboard();

}

class DietAppDashboard extends State<DashPage> {


  Future<Map<String, dynamic>> fetchData(String username,
      String password) async {
    var url = Uri.parse("http://192.168.56.1/local/fetch.php");
    var response = await http.post(url, body: {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      String responseBody = response.body;

      if (responseBody.isEmpty) {
        return {
          "success": false,
          "error": "Empty response body",
        };
      }

      try {
        // Attempt to decode the response as JSON
        dynamic decodedData = json.decode(responseBody);
        print(decodedData);
        // Check if the decoded data is a map
        if (decodedData is! Map<String, dynamic>) {
          return {
            "success": false,
            "error": "Invalid response format - not a map",
          };
        }

        Map<String, dynamic> dataList = decodedData;

        // Extract data as before
        String age = dataList['age']?.toString() ?? '';
        String weight = dataList['weight']?.toString() ?? '';
        String height = dataList['height']?.toString() ?? '';
        String gender = dataList['gender']?.toString() ?? '';
        return {
          "success": true,
          "age": age,
          "weight": weight,
          "height": height,
          "gender": gender,
        };
      } catch (e) {
        print("Error decoding JSON: $e");
        print("Response Body: $responseBody");
        return {
          "success": false,
          "error": "Invalid JSON format",
        };
      }
    } else {
      return {
        "success": false,
        "error": "Failed to fetch data",
      };
    }
  }
Future<int>weights(String username, String password) async{
  Map<String, dynamic> myMap;
  try {
    myMap = await fetchData(username, password);
    if (myMap["success"] != true) {
      // Handle the error case
      print("Error: ${myMap["error"]}");
      return 0; // or some default value
    }

    String? age = myMap['age'];
    String weight = myMap['weight'];
    String? height = myMap['height'];
    String? gender = myMap['gender'];
    int weights = int.parse(weight);

    return weights;

  }
  catch (e) {
    print("Error in fetching function: $e");
    return 0; // or some default value
  }
}
  Future<List<List<dynamic>>> calories(String username, String password, String date) async {
    List<List<dynamic>> results = [];

    try {
      List<Map<String, dynamic>> mealList = await fetchmeals(username, password, date);

      for (Map<String, dynamic> mealData in mealList) {
        List<dynamic> result = [];

        String mealType = mealData['meal_type']?.toString() ?? '';

        // Handle calories as String or int based on your database structure
        dynamic calories = mealData['calories'];
        int caloriesValue = (calories is int) ? calories : int.tryParse(calories?.toString() ?? '') ?? 0;

        String name = mealData['name']?.toString() ?? '';

        result.addAll([caloriesValue, name, mealType]);
        results.add(result);
      }
    } catch (e) {
      print("Error in fetching function: $e");
      results.add([0, "", ""]); // or some default values
    }

    return results;
  }



  Future<int> fetching(String username, String password,int cal) async {
    Map<String, dynamic> myMap;
    try {
      myMap = await fetchData(username, password);
      if (myMap["success"] != true) {
        // Handle the error case
        print("Error: ${myMap["error"]}");
        return 0; // or some default value
      }

      String? age = myMap['age'];
      String? weight = myMap['weight'];
      String? height = myMap['height'];
      String? gender = myMap['gender'];

      if (age == null || weight == null || height == null || gender == null) {
        // Handle the case where any of the values are null
        print("Error: One or more values are null");
        return 0; // or some default value
      }

      int user_age = int.parse(age);
      double user_weight = double.parse(weight);
      int user_height = int.parse(height);

      double calorie_intake = 0;
      int user_calorie = 0;

      if (gender == 'Male') {
        calorie_intake =
            88.362 + (13.397 * user_weight) + (4.799 * user_height) -
                (5.677 * user_age);
        user_calorie = calorie_intake.toInt()-cal;
      }

      else if (gender == 'Female') {
        calorie_intake =
            447.593 + (9.247 * user_weight) + (3.098 * user_height) -
                (4.330 * user_age);
        user_calorie = calorie_intake.toInt()-cal;
      }
      return user_calorie;
    } catch (e) {
      print("Error in fetching function: $e");
      return 0; // or some default value
    }

  }
  Future<List<Map<String, dynamic>>> fetchmeals(String username, String password, String date) async {
    var url = Uri.parse("http://192.168.56.1/local/fetchmeal.php");
    var response = await http.post(url, body: {
      'username': username,
      'password': password,
      'date': date,
    });

    if (response.statusCode == 200) {
      String responseBody = response.body;

      if (responseBody.isEmpty) {
        return [
          {
            "success": false,
            "error": "Empty response body",
          }
        ];
      }

      try {
        // Attempt to decode the response as JSON
        dynamic decodedData = json.decode(responseBody);
        print('$decodedData thsu');

        // Check if the decoded data is a list
        if (decodedData is! List) {
          return [
            {
              "success": false,
              "error": "Invalid response format - not a list",
            }
          ];
        }

        // Convert the list of maps to a List<Map<String, dynamic>>
        List<Map<String, dynamic>> dataList = List.castFrom(decodedData);

        print('$dataList hhhhhhhhhhhhh');

        // Return the list of maps
        return dataList;
      } catch (e) {
        print("Error decoding JSON: $e");
        print("Response Body: $responseBody");
        return [
          {
            "success": false,
            "error": "Invalid JSON format",
          }
        ];
      }
    } else {
      return [
        {
          "success": false,
          "error": "Failed to fetch data",
        }
      ];
    }
  }

  @override
  Widget build (BuildContext context) {
    String nameController=widget.nameController;
    String password=widget.password;
    String? date=widget.date;
    DateTime now = DateTime.now();
    String vars=now.toString();
    String test='2024-01-27';
   int cal=0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Diet App Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Your Diet Dashboard!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FutureBuilder<int>(
                  future: fetching(nameController, password,cal),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      int calories = snapshot.data ?? 0;
                      return DietCard(
                        title: 'Calories Consumed',
                        value: '$calories',
                        unit: 'kcal',
                        icon: Icons.local_dining,
                      );
                    }
                  },
                ),
                FutureBuilder<int>(
                  future: weights(nameController, password),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      int weight = snapshot.data ?? 0;
                      return DietCard(
                        title: 'weight',
                        value: '$weight',
                        unit: 'kg',
                        icon: Icons.fitness_center,
                      );
                    }
                  },
                ),

              ],
            ),
            SizedBox(height: 20),
            Text(
              'Today\'s Meals',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      FutureBuilder<List<List<dynamic>>>(
                        future: calories(nameController, password, test),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            List<List<dynamic>> results = snapshot.data ?? [];
                            return Column(
                              children: results.map((result) {
                                 cal = result.isNotEmpty ? result[0] : 0;
                                String name = result.length > 1 ? result[1] : "";
                                String type = result.length > 2 ? result[2] : "";
                                print(type);
                                return MealItem(
                                  mealType: '$type',
                                  description: '$name',
                                  calories: '$cal',
                                  onPressed: () {
                                    // Add your logic to execute when the MealItem is pressed
                                    print('Meal item pressed!');
                                  },
                                );
                              }).toList(),
                            );
                          }
                        },
                      ),


                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DietCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;

  DietCard({required this.title, required this.value, required this.unit, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.green,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              '$value $unit',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class MealItem extends StatelessWidget {
  final String mealType;
  final String description;
  final String calories;
  final VoidCallback? onPressed; // Add this line for onPressed

  MealItem({required this.mealType, required this.description, required this.calories,    this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('$mealType: $description'),
      subtitle: Text('Calories: $calories kcal'),
      leading: Icon(Icons.restaurant),
      onTap: onPressed, // Add this line for onPressed

    );
  }
}
