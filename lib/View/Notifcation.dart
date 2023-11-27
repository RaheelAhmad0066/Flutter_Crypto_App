import 'package:crypto/View/RegisterScreen.dart';
import 'package:flutter/material.dart';
import 'Addnotifcation.dart';
import 'home.dart';
import 'navBar.dart';

import 'package:get/get.dart';

class AnotherPage extends StatefulWidget {
  const AnotherPage({
    super.key,
  });

  @override
  State<AnotherPage> createState() => _AnotherPageState();
}

class _AnotherPageState extends State<AnotherPage> {
  void deleteNotification(int index) {
    setState(() {
      notif.removeAt(index);
    });
  }

  List<bool> selectedItems = List.generate(notif.length, (index) => false);
  bool selectAllChecked = false;
  void deleteSelectedNotifications() {
    setState(() {
      for (int i = selectedItems.length - 1; i >= 0; i--) {
        if (selectedItems[i]) {
          notif.removeAt(i);
          selectedItems.removeAt(i);
        }
      }
    });
    selectAllChecked = false;
  }

  void toggleSelectAll() {
    setState(() {
      selectAllChecked = !selectAllChecked;
      selectedItems = List.generate(notif.length, (index) => selectAllChecked);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: color,
        onPressed: () {
          Get.to(AddNotifcation());
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Notification Page',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: ((context) => NavBar())));
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              deleteSelectedNotifications();
            },
          ),
          Checkbox(
            checkColor: Colors.white,
            value: selectAllChecked,
            onChanged: (value) {
              toggleSelectAll();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notif.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Dismissible(
              key: Key(notif[index].title),
              onDismissed: (direction) {
                deleteNotification(index);
                selectedItems.removeAt(index);
              },
              background: Container(
                color: Colors.red,
                child: Icon(Icons.delete, color: Colors.white),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Set the background color to blue
                  borderRadius: BorderRadius.circular(
                      10.0), // Set border radius for rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Add a shadow color
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2), // Offset of the shadow
                    ),
                  ],
                ),
                child: CheckboxListTile(
                  fillColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      // Check if the checkbox is in the checked state
                      if (states.contains(MaterialState)) {
                        return Color(0xffF004BFE); // Color when checked
                      } else {
                        return null; // Default color when unchecked
                      }
                    },
                  ),
                  value: selectedItems[index],
                  onChanged: (value) {
                    setState(() {
                      selectedItems[index] = value!;
                    });
                  },
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.network(
                            notif[index].imag.toString(),
                            height: 40.0,
                            width: 40.0,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            notif[index].title,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight:
                                    FontWeight.bold), // Set text color to white
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Current Price ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.grey),
                          ),
                          Text(
                            notif[index].content,
                            style: TextStyle(
                                color: Colors.black), // Set text color to white
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Chnage Price 24h ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.green),
                          ),
                          Text(
                            notif[index].price.toString(),
                            style: TextStyle(
                                color: Colors.black), // Set text color to white
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Percentage ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.red),
                          ),
                          Text(
                            notif[index].percentage.toString(),
                            style: TextStyle(
                                color: Colors.black), // Set text color to white
                          ),
                          Text(' '),
                          Text(
                            notif[index].price.toString(),
                            style: TextStyle(
                                color: Colors.black), // Set text color to white
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

///// importan code

