// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors
import 'package:doctor_home_ui/utill/colors.dart';
import 'package:flutter/material.dart';

class DoctorCart extends StatelessWidget {
  final String doctorSpeciality;
  final String doctorName;
  final String doctorImage;
  String BookAppointment = "Book Appointment";
  DoctorCart({
    super.key,
    required this.doctorName,
    required this.doctorSpeciality,
    required this.doctorImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 80),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 200,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage(doctorImage),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                top: 100,
                left: 30,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(doctorSpeciality,
                          style: TextStyle(
                            fontSize: 12,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 150,
                          height: 40,
                          color: buttonClr,
                          child: Center(
                            child: Text(
                              BookAppointment,
                              style: TextStyle(
                                color: greenClr,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
