import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';

import 'package:logitrack/fetch.dart';

class AddMonitoring extends StatefulWidget {
  @override
  _AddMonitoringState createState() => _AddMonitoringState();
}

class _AddMonitoringState extends State<AddMonitoring> {
  bool isLoading = true;
  bool isAllDay = false;

  List<Map<String, dynamic>> driversData = [];
  List<Map<String, dynamic>> platenosData = [];

  String? selectedDriver;
  String? selectedPlate;
  DateTime? selectedDate;
  

  @override
  void initState() {
    super.initState();

    String company_id = '1';
    // Use Future.wait to fetch data from multiple sources concurrently
    Future.wait([
      fetchDataReq('https://logitrackserver-901e112e4d25.herokuapp.com/get-drivers', {'company_id': company_id}),
      fetchDataReq('https://logitrackserver-901e112e4d25.herokuapp.com/get-plateno', {'company_id': company_id}),
    ]).then((List<dynamic> results) {
      // results is a List containing the data from both fetches
      setState(() {
        driversData = results[0] ?? [];
        platenosData = results[1] ?? []; // Handle additional data as needed
        print(platenosData);
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
    });
  }

  TextEditingController txtDate = TextEditingController();
  TextEditingController txtStartTime = TextEditingController();
  TextEditingController txtEndTime = TextEditingController();
  TextEditingController txtOdometer = TextEditingController();
  
  final GlobalKey<FormState> _formMonitoringKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDatePickerMode: DatePickerMode.day,
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        txtDate.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  void _resetForm() {
      _formMonitoringKey.currentState!.reset();
      txtDate.clear();
      txtStartTime.clear();
      txtEndTime.clear();
      txtOdometer.clear();
      // Add additional controllers if needed
      setState(() {
        selectedDriver = null;
        selectedPlate = null;
        selectedDate = null;
        isAllDay = false;
      });
    }

  void _postData() {
    // Get the data from the controller and post it
    Map<String, dynamic> insertPostData = {
      'company_id': '1',
      'driver_id': selectedDriver,
      'plate_no': selectedPlate,
      'date': txtDate.text,
      'start_time': txtStartTime.text,
      'end_time': txtEndTime.text,
      'odometer': txtOdometer.text,
    };

    // manual reset
    _resetForm();
    
    insertData('https://logitrackserver-901e112e4d25.herokuapp.com/insert-monitoring',
            insertPostData)
        .then((data) {
      setState(() {
        isLoading = false;
      });

      showAlert(context, 'Added monitoring succesfully!');
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
          'Add Monitoring',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formMonitoringKey,
        child: Container (
          padding: EdgeInsets.all(20),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                  ),
                )
              : SingleChildScrollView(
                  child: Column (
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ============= DROPDOWN DRIVER ==============
                      Text(
                        'DRIVER',
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
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            'Choose a Driver',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          value: selectedDriver,
                          items: driversData.map((driver) {
                            return DropdownMenuItem<String>(
                             value: driver['id'].toString(),
                              child: Text(driver['username'].toString()),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              selectedDriver = value;
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
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            'Choose a Plate Number',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          value: selectedPlate,
                          items: platenosData.map((plate) {
                            return DropdownMenuItem<String>(
                              value: plate['plateno'].toString(),
                              child: Text(plate['plateno'].toString()),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              selectedPlate = value;
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
                        height: 30.0,
                      ),
                      Text(
                        'ODOMETER',
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
                          controller: txtOdometer,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Odometer';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(16),
                            hintText: 'Odometer',
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
                      
                      // ============= PICKER DATE =============
                      Text(
                        'DATE',
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
                        child: Material(
                          elevation: 0.0,
                          child: InkWell(
                            onTap: () => _selectDate(context),
                            child: TextFormField(
                              controller: txtDate,
                              enabled: false,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please pick a Date';
                                }
                                return null;
                              },
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(16),
                                hintText: 'Select Date',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.bold,
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                 border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15), // Set the border radius
                                  borderSide: BorderSide.none, // Remove the border
                                ),
                                suffixIcon: Icon(
                                  Icons.calendar_today,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 10.0,
                      ),

                      // ============ ALL DAY CHECKBOX ========
                      Row(
                        children: [
                          Checkbox(
                            value: isAllDay,
                            activeColor: Colors.grey.shade600,
                            onChanged: (bool? value) {
                              setState(() {
                                isAllDay = value ?? false;
                                if (isAllDay) {
                                  txtStartTime.text = '00:00:00';
                                  txtEndTime.text = '00:00:00';
                                } else {
                                  txtStartTime.text = '';
                                  txtEndTime.text = '';
                                }
                              });
                            },
                          ),
                          Text(
                            'Track All Day?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      
                      const SizedBox(
                        height: 10.0,
                      ),

                      // ============ START TIME ==============
                      Visibility(
                        visible: !isAllDay, // Hide when isAllDay is true
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'START TIME',
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
                              child: InkWell(
                                onTap: () async {
                                  TimeOfDay? selectedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );

                                  if (selectedTime != null) {
                                    DateTime dateTime = DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day,
                                      selectedTime.hour,
                                      selectedTime.minute,
                                    );
                                    // Handle the selected time
                                    String formattedTime = DateFormat('HH:mm:ss').format(dateTime);

                                    print(formattedTime);
                                    txtStartTime.text = formattedTime;

                                  }
                                },
                                child: TextFormField(
                                  controller: txtStartTime,
                                  enabled: false,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please pick Start Time';
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(16),
                                    hintText: 'Pick Starting Time',
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade200,
                                    suffixIcon: Icon(
                                      Icons.access_time,
                                      color: Colors.grey.shade500,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 30.0,
                            ),
                            
                            // ============ END TIME ==============
                            Text(
                              'END TIME',
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
                              child: InkWell(
                                onTap: () async {
                                  TimeOfDay? selectedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );

                                  if (selectedTime != null) {
                                    DateTime dateTime = DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day,
                                      selectedTime.hour,
                                      selectedTime.minute,
                                    );
                                    // Handle the selected time
                                    String formattedTime = DateFormat('HH:mm:ss').format(dateTime);

                                    print(formattedTime);
                                    txtEndTime.text = formattedTime;

                                  }
                                },
                                child: TextFormField(
                                  controller: txtEndTime,
                                  enabled: false,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please pick End Time';
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(16),
                                    hintText: 'Pick End Time',
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade200,
                                    suffixIcon: Icon(
                                      Icons.access_time,
                                      color: Colors.grey.shade500,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                          ],
                        ),
                      ),
                      // =========== SUBMIT BUTTON =========
                      Container(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey.shade500,
                              minimumSize: const Size.fromHeight(50), // NEW
                            ),
                            onPressed: () {
                              if (_formMonitoringKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
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
                  ),
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

