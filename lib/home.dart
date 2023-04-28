// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_interpolation_to_compose_strings
import 'package:doctor_home_ui/utill/card.dart';
import 'package:doctor_home_ui/utill/catagoriey.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'utill/texts.dart';
import 'utill/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

// WHATSNEW IS HERE...
// converting some (most to be button widgets) to BUTTON
// adding the ( Draggable home package ) from pub.dev website
class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BOTTOMNAVIGATIONBAR part
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              backgroundColor: greenClr,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: buttonClr,
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.map_outlined,
                    color: textGreenClr,
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite_border,
                    color: textGreenClr,
                  ),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings_outlined,
                    color: textGreenClr,
                  ),
                  label: "",
                ),
              ]),
        ),
      ),

      // BACKGROUNDCOLOR [ NOT NECESSARY ]
      backgroundColor: Colors.white,

      // BODY
      body: DraggableHome(
        actions: [
          IconButton(
            onPressed: () {
              print('go to notification screen');
            },
            icon: Icon(
              Icons.notifications_none,
              color: Colors.white,
            ),
          ),
        ],
        appBarColor: greenClr,
        backgroundColor: greenClr,
        headerWidget: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TUESDAY
                      Row(
                        children: [
                          Text(
                            tuesday + ",",
                            style: TextStyle(
                              color: textGreenClr,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            day,
                            style: TextStyle(
                              color: textGreenClr,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      // HIAHMELA part
                      Text(
                        hiAhmela,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),

                  // NOTIFICATIONBUTTON [ THIS IS NOT BUTTON FOR NOW ]
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                        border: Border.all(
                          width: 2,
                          color: textGreenClr,
                        )),
                    child: IconButton(
                      onPressed: () {
                        print('go to notification screen');
                      },
                      icon: Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),

              // SEARCH part
              TextField(
                controller: searchController,
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  filled: false,
                  suffixIcon: IconButton(
                    onPressed: () {
                      print(searchController.text);
                    },
                    icon: Icon(Icons.search),
                    color: textGreenClr,
                  ),
                  hintText: search,
                  hintStyle: TextStyle(
                    color: textGreenClr,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: textGreenClr,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: textGreenClr,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        title: Text('Home'),
        body: [
          SizedBox(
            height: 20,
          ),
          // MOVABLEBODY START FROM HERE
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topDoctors,
                    style: TextStyle(
                      color: greenClr,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 20),

                  // TOPDOCTORS HERE
                  SingleChildScrollView(
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        DoctorCart(
                          doctorName: 'doctorName',
                          doctorSpeciality: 'doctorSpeciality',
                          doctorImage:
                              'https://www.freepnglogos.com/uploads/doctor-png/doctor-bulk-billing-doctors-chapel-hill-health-care-medical-3.png',
                        ),
                        DoctorCart(
                          doctorName: 'doctorName',
                          doctorSpeciality: 'doctorSpeciality',
                          doctorImage:
                              'https://customerthink.com/wp-content/uploads/Doctor-PNG-Images.png',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),

                  // CATEGORY STARTS FROM HERE
                  Text(
                    catagoriey,
                    style: TextStyle(
                      color: greenClr,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CatagorieyCard(
                          catagorieyName: 'Dentist',
                          catagorieyEmoji: '🦷',
                        ),
                        CatagorieyCard(
                          catagorieyName: 'Bone',
                          catagorieyEmoji: '🦴',
                        ),
                        CatagorieyCard(
                          catagorieyName: 'Eye',
                          catagorieyEmoji: '👁️',
                        ),
                        CatagorieyCard(
                          catagorieyName: 'Lungs',
                          catagorieyEmoji: '🫁',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
