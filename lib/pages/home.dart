import 'package:doctor_home_ui/pages/notification.dart';
import 'package:doctor_home_ui/utill/card.dart';
import 'package:doctor_home_ui/utill/catagoriey.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utill/doctors_list.dart';
import '../utill/texts.dart';
import '../utill/colors.dart';
import 'favpage.dart';
import 'map.dart';
import 'settings.dart';

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
      // BOTTOMNAVIGATIONBAR part [MOVED TO BOTTOMNAV.DART]
      backgroundColor: greenClr,
      // BODY
      body: DraggableHome(
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => NotificationScreen());
            },
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.white,
            ),
          ),
        ],
        appBarColor: greenClr,
        backgroundColor: Colors.white,
        headerWidget: Container(
          color: greenClr,
          child: Padding(
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
                          children: const [
                            Text(
                              "$tuesday,",
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
                        const SizedBox(
                          height: 10,
                        ),

                        // HIAHMELA part
                        const Text(
                          hiAhmela,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),

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
                          Get.to(() => NotificationScreen());
                        },
                        icon: const Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),

                // SEARCH part
                TextField(
                  controller: searchController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    filled: false,
                    suffixIcon: IconButton(
                      onPressed: () {
                        print(searchController.text);
                      },
                      icon: const Icon(Icons.search),
                      color: textGreenClr,
                    ),
                    hintText: search,
                    hintStyle: const TextStyle(
                      color: textGreenClr,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(
                        color: textGreenClr,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: const BorderSide(
                        color: textGreenClr,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        title: const Text('Home'),
        body: [
          const SizedBox(
            height: 20,
          ),
          // MOVABLEBODY START FROM HERE
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    topDoctors,
                    style: TextStyle(
                      color: greenClr,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 20),

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
                  const SizedBox(height: 30),

                  // CATEGORY STARTS FROM HERE
                  const Text(
                    catagoriey,
                    style: TextStyle(
                      color: greenClr,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: const [
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
                  const SizedBox(height: 30),
                  // DoctorList
                  const Text(
                    'Doctor List',
                    style: TextStyle(
                      color: greenClr,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // DOCTORLIST STARTS FROM HERE
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        DoctorsList(
                          doctorName: 'Dr , Sarah Williams',
                          doctorSpeciality: 'Dentist',
                          doctorImage:
                              'https://customerthink.com/wp-content/uploads/Doctor-PNG-Images.png',
                        ),
                        const SizedBox(height: 20),
                        DoctorsList(
                          doctorName: 'Dr , Sarah Williams',
                          doctorSpeciality: 'Dentist',
                          doctorImage:
                              'https://customerthink.com/wp-content/uploads/Doctor-PNG-Images.png',
                        ),
                        const SizedBox(height: 20),
                        DoctorsList(
                          doctorName: 'Dr , Sarah Williams',
                          doctorSpeciality: 'Dentist',
                          doctorImage:
                              'https://customerthink.com/wp-content/uploads/Doctor-PNG-Images.png',
                        )
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
