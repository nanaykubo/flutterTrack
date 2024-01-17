import 'package:flutter/material.dart';

import 'package:logitrack/home.dart';
import 'package:logitrack/add_users.dart';
import 'package:logitrack/add_vehicles.dart';
import 'package:logitrack/add_monitoring.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
Widget build(BuildContext context) {
  return Drawer(
    child: Column(
      children: <Widget>[
        Expanded(
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
                leading: Icon(Icons.dashboard),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddVehicles()),
                  );
                },
              ),
              ListTile(
                title: const Text('Add Monitoring'),
                leading: Icon(Icons.monitor),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddMonitoring()),
                  );
                },
              ),
              // Add more ListTile widgets for additional links
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () {
              // Add your logout logic here
              print("Logout tapped! Implement your logout logic here.");
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.red,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                // Optionally, add additional widgets below the row
                // Container(
                //   child: Text('Additional content'),
                //   margin: EdgeInsets.only(top: 16),
                // ),
              ],
            ),
          ),
        )  
      ],
    ),
  );
}
}
