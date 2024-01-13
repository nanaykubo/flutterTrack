import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:background_locator_2/background_locator.dart';

Future<List<Map<String, dynamic>>?> fetchData(String apiUrl) async {
  try {
    final response = await http.post(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List;
      return responseData.cast<Map<String, dynamic>>();
    } else {
      return null;
    }
  } catch (e) {
    print('Error during API request: $e');
    return null;
  }
}

Future<List<Map<String, dynamic>>?> insertData(
    String apiUrl, Map<String, dynamic> postData) async {
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode(postData), // Convert the Map to JSON
      headers: {
        'Content-Type': 'application/json', // Set the content type to JSON
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List;
      return responseData.cast<Map<String, dynamic>>();
    } else {
      return null;
    }
  } catch (e) {
    print('Error during API request: $e');
    return null;
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Side Menu Flutter App',
      theme: ThemeData(
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blueGrey.shade400,
          ),
          colorScheme: const ColorScheme.light().copyWith(
            background: Colors.white,
          ),
          primarySwatch: Colors.grey,
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.grey,
              selectionColor: Colors.blueGrey.shade100,
              selectionHandleColor: Colors.grey),
          inputDecorationTheme: InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey.shade200)),
          )),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu, // Change this line to use a different icon
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: const Text(
          '',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      drawer: const SideMenu(), // Add a drawer to the Scaffold
      body: const Center(
        child: Text('Home Page Content'),
      ),
    );
  }
}

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            color: Colors.blueGrey.shade300,
            width: double.infinity,
            height: 200,
            padding: EdgeInsets.only(top: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  height: 70,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/profile.jpg'),
                    ),
                  ),
                ),
                const Text(
                  "Angel",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  "Administrator",
                  style: TextStyle(
                    color: Colors.grey[200],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Dashboard'),
            leading:
                Icon(Icons.dashboard), // Add an icon to the left of the title
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          ListTile(
            title: const Text('Add Users'),
            leading: Icon(Icons.person_add),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddUsers()),
              );
            },
          ),
          ListTile(
            title: const Text('Add Vehicles'),
            leading: Icon(Icons.directions_car),
            onTap: () {
              // Handle the tap on Add Vehicles
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: const Text('Add Monitoring'),
            leading: Icon(Icons.monitor),
            onTap: () {
              // Handle the tap on Add Monitoring
              Navigator.pop(context); // Close the drawer
            },
          ),
          // Add more ListTile widgets for additional links
        ],
      ),
    );
  }
}

class AddUsers extends StatefulWidget {
  @override
  _AddUsersState createState() => _AddUsersState();
}

class _AddUsersState extends State<AddUsers> {
  bool isLoading = true;
  List<Map<String, dynamic>> rolesData = [];

  @override
  void initState() {
    super.initState();
    fetchData('https://logitrackserver-901e112e4d25.herokuapp.com/get-roles')
        .then((data) {
      setState(() {
        rolesData = data ?? [];
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
    });
  }

  // Selected dropdown value
  String? selectedValue;

  // Text controllers for text fields
  TextEditingController txtUser = TextEditingController();
  TextEditingController txtPass = TextEditingController();
  TextEditingController txtFirst = TextEditingController();
  TextEditingController txtLast = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _postData() {
    // Get the data from the controller and post it
    Map<String, dynamic> insertPostData = {
      'role_id': selectedValue,
      'company_id': '1',
      'username': txtUser.text,
      'password': txtPass.text,
      'first_name': txtFirst.text,
      'last_name': txtLast.text
    };

    setState(() {
      selectedValue = null;
    });
    _formKey.currentState!.reset();

    insertData('https://logitrackserver-901e112e4d25.herokuapp.com/add-users',
            insertPostData)
        .then((data) {
      setState(() {
        isLoading = false;
      });

      showAlert(context, 'Added users succesfully!');
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back, // or any other back icon you prefer
                color: Colors.white, // Set the color to white
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        ),
        title: const Text(
          'Add Users',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(20),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ROLE',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      // Use the fetched data to populate the dropdown options
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            'Choose a role',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          value: selectedValue,
                          items: rolesData.map((role) {
                            return DropdownMenuItem<String>(
                              value: role['id'].toString(),
                              child: Text(role['description'].toString()),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              selectedValue = value;
                            });
                          },
                          buttonStyleData: ButtonStyleData(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.grey.shade200,
                              ),
                            ),
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'USERNAME',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        child: TextFormField(
                          controller: txtUser,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Username';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16),
                            hintText: 'Username',
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.bold),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'PASSWORD',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        child: TextFormField(
                          controller: txtPass,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Password';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                                fontSize: 16, color: Colors.grey.shade500),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'FIRST NAME',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        child: TextFormField(
                          controller: txtFirst,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your First Name';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16),
                            hintText: 'First Name',
                            hintStyle: TextStyle(
                                fontSize: 16, color: Colors.grey.shade500),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'LAST NAME',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        child: TextFormField(
                          controller: txtLast,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your Last Name';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16),
                            hintText: 'Last Name',
                            hintStyle: TextStyle(
                                fontSize: 16, color: Colors.grey.shade500),
                            filled: true,
                            fillColor: Colors.grey.shade200,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Container(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blueGrey.shade500,
                            minimumSize: const Size.fromHeight(50), // NEW
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });

                              // Perform form submission
                              _postData();
                            }
                          },
                          child: const Text(
                            'Submit',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      // Add other widgets as needed
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

// Function to show the alert with custom text
void showAlert(BuildContext context, String alertText) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text('LogiTrack'),
        content: Text(
          alertText,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'OK',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 16,
              ),
            ),
          ),
        ],
      );
    },
  );
}
