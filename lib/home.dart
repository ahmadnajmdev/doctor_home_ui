// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:doctor_home_ui/utill/card.dart';
import 'package:doctor_home_ui/utill/catagoriey.dart';
import 'package:floating_navbar/floating_navbar.dart';
import 'package:floating_navbar/floating_navbar_item.dart';
import 'package:flutter/material.dart';
import 'utill/texts.dart';

import 'package:doctor_home_ui/utill/texts.dart';

import 'utill/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: greenClr,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                          child: Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        filled: false,
                        suffixIcon: Icon(
                          Icons.search,
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
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
