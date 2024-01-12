import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
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
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Side Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
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
  String selectedDropdownValue = '1';

  // Text controllers for text fields
  TextEditingController textController1 = TextEditingController();
  TextEditingController textController2 = TextEditingController();
  TextEditingController textController3 = TextEditingController();
  TextEditingController textController4 = TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Users'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: isLoading
            ? CircularProgressIndicator() // Show loader
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Use the fetched data to populate the dropdown options
                  DropdownButtonFormField<String>(
                    value: selectedDropdownValue,
                    items: rolesData.map((role) {
                      return DropdownMenuItem<String>(
                        value: role['id'].toString(),
                        child: Text(role['description'].toString()),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDropdownValue = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Select a role',
                    ),
                  ),
                  // Text Field 1
                  Container(
                    child: TextFormField(
                      controller: textController1,
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                    ),
                  ),
                  // Text Field 1
                  Container(
                    child: TextFormField(
                      controller: textController2,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  // Text Field 1
                  Container(
                    child: TextFormField(
                      controller: textController3,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                      ),
                    ),
                  ),
                  Container(
                    child: TextFormField(
                      controller: textController3,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                      ),
                    ),
                  ),
                  // Add other widgets as needed
                ],
              ),
      ),
    );
  }
}
