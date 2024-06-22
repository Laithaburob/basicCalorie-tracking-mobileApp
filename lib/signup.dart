import 'dart:convert';
import 'package:firstproject/main.dart'as mains;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
export 'lib/signup.dart';




void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignupPage(),
    );
  }
}

class SignupPage extends StatefulWidget {
  get weightController => null;

  @override
  _SignupPageState createState() => _SignupPageState();

}

class _SignupPageState extends State<SignupPage> {
  String selectedGender = 'Male';
  String selectedActivityLevel = 'Low';
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  final List<String> activityLevelOptions = ['Low', 'Moderate', 'High'];

  Future signup(BuildContext cont) async {
    var url = "http://192.168.56.1/local/register.php";
    var urll = Uri.parse(url);
    var response = await http.post(urll, body: {
      "username": usernameController.text,
      "password": passwordController.text,
      "gender": selectedGender,
      "weight": weightController.text,
      "age": ageController.text,
      "activity_level": selectedActivityLevel,
      "height": heightController.text,
    });

    if (response.statusCode == 200) {
      try {
        var data = json.decode(response.body);
        if (data == "success") {

          Navigator.push(cont, MaterialPageRoute(builder: (context) => mains.MyApp()));
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            DropdownButtonFormField<String>(
              value: selectedGender,
              items: genderOptions.map((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (value) {
                setState(() async {

                });
              },
              decoration: InputDecoration(labelText: 'Gender'),
            ),
            DropdownButtonFormField<String>(
              value: selectedActivityLevel,
              items: activityLevelOptions.map((String activityLevel) {
                return DropdownMenuItem<String>(
                  value: activityLevel,
                  child: Text(activityLevel),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedActivityLevel = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Activity Level'),
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: weightController,
              decoration: InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: heightController,
              decoration: InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // You can access the form fields' values here and perform the signup logic.
                signup(context);
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
