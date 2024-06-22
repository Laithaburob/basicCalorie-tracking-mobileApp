import 'dart:convert';
import 'package:firstproject/lib/foodapi.dart';
import 'package:firstproject/lib/foodlist.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firstproject/second.dart';
import 'package:firstproject/lib/nutrient.dart';

import 'package:firstproject/signup.dart';
import 'package:firstproject/lib/foodlist.dart';
import 'package:firstproject/lib/foodapi.dart';
import 'package:firstproject/dashboard.dart';
export 'lib/main.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'diet app';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  String selectedGoal = 'lose weight';
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final List<String> goal = [
    'lose weight',
    'maintain weight',
    'gain weight',
    'gain musceles'
  ];

  Future login(BuildContext cont) async {
    var url = "http://192.168.56.1/local/mylocal.php";
    var urll = Uri.parse(url);
    var response = await http.post(urll, body: {
      "username": nameController.text,
      "password": passwordController.text,
    });
    var data = json.decode(response.body);
    if (data == "Username and Password is correct") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondRoute(nameController: nameController.text,password: passwordController.text,),
        ),
      );
    } else {
      Fluttertoast.showToast(
        msg: "the user and the password combination does not exist",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Calorie Tracking Application',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Sign in',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                //forgot password screen
              },
              child: const Text(
                'Forgot Password',
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () {
                    login(context);
                  },
                )),
            Row(
              children: <Widget>[
                const Text('Does not have account?'),
                TextButton(
                  child: const Text(
                    'Sign up',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignupPage()));
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        ));
  }
}

class SecondRoute extends StatefulWidget {
   final String nameController;
   final String password;

  SecondRoute({Key? key, required this.nameController,required this.password}) : super(key: key);

  @override
  _SecondRouteState createState() => _SecondRouteState();
}


class _SecondRouteState extends State<SecondRoute> with SingleTickerProviderStateMixin{

  late String userss;
  late String passwords;
  List<Foodlist> _foodlists = [];
  TextEditingController _searchController = TextEditingController();
  TextEditingController portion = TextEditingController();
  late TabController _tabController;
  String name = "banana";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    int? portions=0;
    getFood(portions);
    userss = widget.nameController;
    passwords = widget.password;
    _tabController = TabController(length: 3, vsync: this);
  }


  Future<void> getFood(int protion) async {
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

        _foodlists[i].fat_total=double.parse(_foodlists[i].fat_total.toStringAsFixed(2));
        _foodlists[i].calories=double.parse( _foodlists[i].calories.toStringAsFixed(2));
        _foodlists[i].protein=double.parse(_foodlists[i].protein.toStringAsFixed(2));
        _foodlists[i].carbohydrates=double.parse(_foodlists[i].carbohydrates.toStringAsFixed(2));
      }
      else{
        _foodlists[i].serving = _foodlists[i].serving / _foodlists[i].serving;
        _foodlists[i].fat_total=double.parse(_foodlists[i].fat_total.toStringAsFixed(2));
        _foodlists[i].calories=double.parse( _foodlists[i].calories.toStringAsFixed(2));
        _foodlists[i].protein=double.parse(_foodlists[i].protein.toStringAsFixed(2));
        _foodlists[i].carbohydrates=double.parse(_foodlists[i].carbohydrates.toStringAsFixed(2));
      }
      _foodlists[i].fat_total=_foodlists[i].fat_total*protion;
      _foodlists[i].calories= _foodlists[i].calories*protion;
      _foodlists[i].protein=_foodlists[i].protein*protion;
      _foodlists[i].carbohydrates=_foodlists[i].carbohydrates*protion;
      _foodlists[i].serving=protion*_foodlists[i].serving;

    }
  }


void addCompnent(name,protein,carbs,fat,calories,username) async{
  var url = "http://192.168.56.1/local/addcomp.php";
  var urll = Uri.parse(url);

  var response = await http.post(urll, body: {
    "name":name,
    "protein":protein.toString(),
    "carbs":carbs.toString(),
    "fat":fat.toString(),
    "calories":calories.toString(),
    "username":username,

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
  _MyStatefulWidgetState testing = _MyStatefulWidgetState();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Food Nutrient",
            style: TextStyle(fontSize: 28),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        name = value;
                        int portions = int.tryParse(portion.text) ?? 0; // Use int.tryParse to handle potential parsing errors
                        getFood(portions);
                      });
                    },
                  ),
                  TextField(
                    controller: portion,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Portion',
                      prefixIcon: Icon(Icons.food_bank),
                    ),
                    onChanged: (value) {
                      setState(() {

                        int portions = int.tryParse(portion.text) ?? 0; // Use int.tryParse to handle potential parsing errors
                        getFood(portions);
                      });
                    },
                  ),
                ],
              ),
            ),
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Content for Tab 1
                  ListView.builder(
                    itemCount: _foodlists.length,
                    itemBuilder: (context, index) {
                      return InkWell(onTap: (){
                      },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${_foodlists[index].name}",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "calories: ${_foodlists[index].calories}",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "fats: ${_foodlists[index].fat_total}",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "protien: ${_foodlists[index].protein}",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "serving: ${_foodlists[index].serving}",
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                "carbohydrates: ${_foodlists[index].carbohydrates}",
                                style: TextStyle(fontSize: 20),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  int? p =int.tryParse(portion.text);
                                  Navigator.push(
                                     context,
                                     MaterialPageRoute(builder: (context) =>  PlanningPage(nameController: userss, password: passwords,name:_foodlists[index].name, protein:_foodlists[index].protein, carbs:_foodlists[index].carbohydrates, fat: _foodlists[index].fat_total, calories:_foodlists[index].calories,portion:p)),
                                   );

                                   //PlanningPage(nameController: userss, password: passwords,name:_foodlists[index].name, protein:_foodlists[index].protein, carbs:_foodlists[index].carbohydrates, fat: _foodlists[index].fat_total, calories:_foodlists[index].calories);
                                  // testing.addCompnent(_foodlists[index].name, _foodlists[index].protein, _foodlists[index].carbohydrates,  _foodlists[index].fat_total, _foodlists[index].calories,userss,passwords);
                                },
                                child: Text("add component"),
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  // Content for Tab 2

                ],

              ),

            ),
          ],
        ),
        bottomNavigationBar: TabBar(
          labelColor: Colors.blueGrey,
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(color: Colors.blue),
          unselectedLabelStyle: TextStyle(color: Colors.grey),
          controller: _tabController,
          tabs: [
            Tab(
              icon: Icon(
                  Icons.home,
                color: Colors.grey,
              ),
              text: 'home',
            ),
            Tab(
              icon: Icon(
                Icons.fitness_center,
                color: Colors.grey,
              ),
              text: 'My progress',
            ),
            Tab(
              icon: Icon(
                Icons.dining,
                color: Colors.grey,
              ),
              text: 'meal planning',
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                break;
              case 1:
                Navigator.of(context).push(

                  MaterialPageRoute(builder: (context) => DashPage(nameController:userss,password:passwords)),
                );
                break;
              case 2:
                Navigator.of(context).push(

                  MaterialPageRoute(builder: (context) => PlanningPage(nameController:userss,password:passwords)),
                );
                break;
            }
          },
        ),
      ),
    );
  }
}