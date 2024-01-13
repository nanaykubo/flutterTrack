import 'package:flutter/material.dart';

import 'package:logitrack/home.dart';
import 'package:logitrack/add_users.dart';

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
