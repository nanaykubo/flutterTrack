import 'package:flutter/material.dart';

import 'package:logitrack/side_menu.dart';
import 'package:logitrack/fetch.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List<Map<String, dynamic>> monitoringData = [];

  String company_id = '1';
  String all_day = '';

  @override
  void initState() {
    super.initState();
    fetchDataReq('https://logitrackserver-901e112e4d25.herokuapp.com/get-monitoring', {'company_id': company_id})
        .then((data) {
      setState(() {
        monitoringData = data ?? [];
        isLoading = false;
      });
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
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, size: 35.0),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8.0), // Add margin if needed
            child: IconButton(
              icon: Icon(Icons.notifications, size: 35.0),
              onPressed: () {
                // Add your notification icon onPressed logic here
              },
            ),
          ),
        ],
      ),

      drawer: const SideMenu(), 
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headers (Dashboard, monitoring list texts)
            Container(
              padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 const Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    'Monitoring List',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800
                    ),
                    textAlign: TextAlign.left,
                  ),
                  // Add more children as needed
                ],
              ),
            ),
            
            const SizedBox(
              height: 16.0,
            ),
            if (monitoringData != null && monitoringData.isNotEmpty) 
              ...monitoringData.map((item) {
                print(item);
                if(item.containsKey('error')) {
                  print("there is an error");
                  return Text('');
                } 
                else {
                  if (item['start_time'] == '00:00:00' && item['end_time'] == '00:00:00') {
                    all_day = "ALL DAY";
                  } else {
                    all_day = item['start_time'] + "-" + item['end_time'];
                  }

                  List<String> stats = ['PENDING', 'ON GOING', 'DONE'];

                  return Column(
                    children: [
                      Card(
                        margin: EdgeInsets.all(0),
                        color: Colors.white,
                        elevation: 0,
                        child: ListTile(
                          title: Text(
                            'Monitor No# ${item['id']}',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(all_day),
                                  Text('Assigned Driver: ${item['first_name']}'),
                                ],
                              ),
                              // Status text widget
                              Text(
                                ' ${stats[item['status']]}', // Replace with the correct key for status
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                              ),
                            ],
                          ),
                          // You can customize the ListTile further based on your needs
                        ),
                      ),
                      if (monitoringData.last != item)
                      Divider(
                        color: Colors.grey.shade600, // Adjust color as needed
                        height: 0.3,       // Adjust height as needed
                      ),
                    ],
                  );
                }
            }).toList(),
          ],
        ),
      ),
    );
  }
}