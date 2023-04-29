// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors
import 'package:doctor_home_ui/utill/colors.dart';
import 'package:flutter/material.dart';

class DoctorCart extends StatefulWidget {
  final String doctorSpeciality;
  final String doctorName;
  final String doctorImage;

  DoctorCart({
    super.key,
    required this.doctorName,
    required this.doctorSpeciality,
    required this.doctorImage,
  });

  @override
  State<DoctorCart> createState() => _DoctorCartState(
        doctorImage: doctorImage,
        doctorName: doctorName,
        doctorSpeciality: doctorSpeciality,
      );
}

class _DoctorCartState extends State<DoctorCart> {
  _DoctorCartState({
    required this.doctorName,
    required this.doctorSpeciality,
    required this.doctorImage,
  });
  final String doctorSpeciality;
  final String doctorName;
  final String doctorImage;
  String BookAppointment = "Book Appointment";
  bool isBookMarkButtonPressed = false;

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
                    image: NetworkImage(widget.doctorImage),
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
                        widget.doctorName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(widget.doctorSpeciality,
                          style: TextStyle(
                            fontSize: 12,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          onTap: () {
                            print('Book Mark button pressed');
                            setState(() {
                              isBookMarkButtonPressed =
                                  !isBookMarkButtonPressed;
                            });
                          },
                          child: Container(
                            width: 150,
                            height: 40,
                            color: isBookMarkButtonPressed
                                ? Colors.grey[400]
                                : buttonClr,
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
