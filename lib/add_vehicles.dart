import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:logitrack/fetch.dart';

class AddVehicles extends StatefulWidget {
  @override
  _AddVehiclesState createState() => _AddVehiclesState();
}


class _AddVehiclesState extends State<AddVehicles> {

  bool isLoading = true;

    // ONLY DELAYS, NOTHING IMPORTANT
  @override
  void initState() {
    super.initState();
    print("it called");
    Future.delayed(Duration(seconds: 1), () {
      // After the task is complete, stop loading
      _stopLoading();
    });
  }

  void _stopLoading() {
    if (mounted) {
      print("it mounted");
      setState(() {
        isLoading = false;
      });
    }
  }

  TextEditingController txtModel = TextEditingController();
  TextEditingController txtPlateNo = TextEditingController();
  
  final GlobalKey<FormState> _formVehicleKey = GlobalKey<FormState>();

  void _postData() {
    // Get the data from the controller and post it
    Map<String, dynamic> insertPostData = {
      'model': txtModel.text,
      'plateno': txtPlateNo.text,
      'company_id': '1',
    };

    _formVehicleKey.currentState!.reset();

    insertData('https://logitrackserver-901e112e4d25.herokuapp.com/insert-vehicle',
            insertPostData)
        .then((data) {
      setState(() {
        isLoading = false;
      });

      showAlert(context, 'Added vehicle succesfully!');
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
          'Add Vehicles',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formVehicleKey,
        child: Container (
          padding: EdgeInsets.all(20),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                  ),
                )
              : Column (
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MODEL',
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
              Container (
                child: TextFormField(
                  controller: txtModel,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter vehicle Model';
                    }
                    return null;
                  },
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(16),
                    hintText: 'Model',
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
                'PLATE NUMBER',
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
              Container (
                child: TextFormField(
                  controller: txtPlateNo,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter vehicle Plate Number';
                    }
                    return null;
                  },
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(16),
                    hintText: 'Plate Number',
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
                height: 30.0,
              ),
              Container(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey.shade500,
                      minimumSize: const Size.fromHeight(50), // NEW
                    ),
                    onPressed: () {
                      if (_formVehicleKey.currentState!.validate()) {
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
            ]
          )
        )
      ),
    );
  }
}

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
