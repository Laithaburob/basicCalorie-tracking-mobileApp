import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:firstproject/main.dart' as mains;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diet Planning',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PlanningPage(password: '', nameController: '',),
    );
  }
}

class PlanningPage extends StatefulWidget {
  final String nameController;
  final String password;
  final String? name;
  final double? protein;
  final double? carbs;
  final double? fat;
  final double? calories;
  final int? portion;
  PlanningPage({Key? key, required this.nameController,required this.password,this.name,this.protein,this.carbs,this.fat,this.calories,this.portion}) : super(key: key);
  @override
  State<PlanningPage> createState() => _PlanningPageState();


}

class _PlanningPageState extends State<PlanningPage> {

  DateTime? _chosenDateTime;
  String? selectedMeal ="lunch";
  TextEditingController ccomponentController = TextEditingController();
  final List<String> mealOptions = ['breakfast', 'snack', 'lunch','dinner'];

  Future<DateTime> _showDatePicker(BuildContext ctx) async {
    DateTime chosenDateTime = DateTime.now(); // Set initial date and time

    await showCupertinoModalPopup(
      context: ctx,
      builder: (_) => Container(
        height: 500,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: [
            SizedBox(
              height: 400,
              child: CupertinoDatePicker(
                initialDateTime: chosenDateTime,
                onDateTimeChanged: (val) {
                  chosenDateTime = val;
                },
              ),
            ),

            // Close the modal
            CupertinoButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(ctx).pop(chosenDateTime);
              },
            )
          ],
        ),
      ),
    );

    return chosenDateTime;
  }

  void update(portion,name,protein,carbs,fat,calories,username,password,date) async{
    var url = "http://192.168.56.1/local/update.php";
    var urll = Uri.parse(url);

    var response = await http.post(urll, body: {
      "name":name,
      "protein":protein.toString(),
      "carbs":carbs.toString(),
      "fat":fat.toString(),
      "calories":calories.toString(),
      "portions":portion.toString(),
      "date":date,
      "password": password,
      "username": username,
      "meal_type": selectedMeal.toString(),

    });


    if (response.statusCode == 200) {
      try {
        var data = json.decode(response.body);

        if (data == "success") {

          Fluttertoast.showToast(
              msg: "component has been added successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              fontSize: 16.0);

        } else {
          Fluttertoast.showToast(
            msg: "The user and password combination does not exist",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            fontSize: 16.0,
          );
        }
      } catch (e) {
        print("Error decoding JSON: $e");
      }
    } else {
      print("HTTP request failed with status code: ${response.statusCode}");
    }

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => PlanningPage(nameController: users, password: passwords)),
    // );

  }


  void addCompnent(portion,name,protein,carbs,fat,calories,username,password,date) async{
    var url = "http://192.168.56.1/local/addcomp.php";
    var urll = Uri.parse(url);

    var response = await http.post(urll, body: {
      "name":name,
      "protein":protein.toString(),
      "carbs":carbs.toString(),
      "fat":fat.toString(),
      "calories":calories.toString(),
      "portions":portion.toString(),
      "date":date,
      "password": password,
      "username": username,
      "meal_type": selectedMeal.toString(),

    });


    if (response.statusCode == 200) {
      try {
        var data = json.decode(response.body);

        if (data == "success") {

          Fluttertoast.showToast(
              msg: "component has been added successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              fontSize: 16.0);

        } else {
          Fluttertoast.showToast(
            msg: "The user and password combination does not exist",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            fontSize: 16.0,
          );
        }
      } catch (e) {
        print("Error decoding JSON: $e");
      }
    } else {
      print("HTTP request failed with status code: ${response.statusCode}");
    }

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => PlanningPage(nameController: users, password: passwords)),
    // );

  }

  Future plan( username,password,date) async {
    var url = "http://192.168.56.1/local/addcomp.php";
    var urll = Uri.parse(url);
    var response = await http.post(urll, body: {
      "date":date,
      "password": password,
      "username": username,
      "meal_type": selectedMeal.toString(),
    });

    if (response.statusCode == 200) {
      try {
        var data = json.decode(response.body);
        if (data == "success") {
          Fluttertoast.showToast(
              msg: "component has been added successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
            msg: "The user and password combination does not exist",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            fontSize: 16.0,
          );
        }
      } catch (e) {
        print("Error decoding JSON: $e");
        // Handle the error, e.g., show an error message to the user
      }
    } else {
      print("HTTP request failed with status code: ${response.statusCode}");
      // Handle the error, e.g., show an error message to the user
    }
  }

  @override
  DateTime?result;
  Widget build(BuildContext context) {
    String username=widget.nameController;
    String password=widget.password;
    int? portions=widget.portion;
    String? name=widget.name;
    double? protein=widget.protein;
    double? carbs=widget.carbs;
    double? fat=widget.fat;
    double? calories=widget.calories;
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Planning Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[

            DropdownButtonFormField<String>(
              value: selectedMeal,
              items: mealOptions.map((String meal) {
                return DropdownMenuItem<String>(
                  value: meal,
                  child: Text(meal),
                );
              }).toList(),
              onChanged: (value) {
                selectedMeal=value;
              },
              decoration: InputDecoration(labelText: 'Meal'),
            ),
            FilledButton.tonal(
              onPressed: ()async {
                 result = await _showDatePicker(context);
                // print(result);
              },
              child: const Text('choose date'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: ()  {
              print(result);
                addCompnent(portions,name,protein,carbs,fat,calories,username,password,result.toString());
           // plan(username,password,result.toString());
              },
              child: Text('Add meal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => mains.SecondRoute(nameController: username,password: password,)));
              },
              child: Text('Add components'),
            ),
          ],
        ),
      ),
    );
  }
}

class Test{
String? user;
String? password;


  void addCompnent(BuildContext context,name,protein,carbs,fat,calories,String users, String passwords) async{
    var url = "http://192.168.56.1/local/addcomp.php";
    var urll = Uri.parse(url);

    var response = await http.post(urll, body: {
      "name":name,
      "protein":protein.toString(),
      "carbs":carbs.toString(),
      "fat":fat.toString(),
      "calories":calories.toString(),

    });


    if (response.statusCode == 200) {
      try {
        var data = json.decode(response.body);

        if (data == "success") {

          Fluttertoast.showToast(
              msg: "component has been added successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              fontSize: 16.0);

        } else {
          Fluttertoast.showToast(
            msg: "The user and password combination does not exist",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            fontSize: 16.0,
          );
        }
      } catch (e) {
        print("Error decoding JSON: $e");
      }
    } else {
      print("HTTP request failed with status code: ${response.statusCode}");
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PlanningPage(nameController: users, password: passwords)),
    );

  }


}