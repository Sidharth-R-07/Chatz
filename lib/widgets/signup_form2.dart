import 'dart:io';

import 'package:chatz/Auth/auth_service.dart';
import 'package:chatz/decoration.dart';
import 'package:chatz/model/user_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

//enumurator for select gender section
enum Gender {
  male,
  female,
}

class SignUpForm2 extends StatefulWidget {
  final String name;
  final String email;
  final String password;
  final String phone;

  const SignUpForm2({
    super.key,
    required this.email,
    required this.password,
    required this.phone,
    required this.name,
  });

  @override
  State<SignUpForm2> createState() => _SignUpForm2State();
}

class _SignUpForm2State extends State<SignUpForm2> {
  Gender? gender;
  DateTime? pickedDate;
  File? pickedImage;
  final ImagePicker picker = ImagePicker(); //creating a object of Imagepicker
  String bioText = '';
  bool isLoading = false;

//Signup button onPressed function
  _trySubmit(BuildContext context) async {
    final authProvider = Provider.of<AuthService>(context, listen: false);

    setState(() {
      isLoading = true;
    });
    if (pickedDate == null) {
      setState(() {
        isLoading = false;
      });
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).colorScheme.error,
          content: const Text(
            'Please select your Date of birth!',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    } else if (pickedImage == null) {
      setState(() {
        isLoading = false;
      });
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).colorScheme.error,
          content: const Text(
            'Please pick your image!',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    } else if (gender == null) {
      setState(() {
        isLoading = false;
      });
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          backgroundColor: Theme.of(context).colorScheme.error,
          content: const Text(
            'Please select your gender',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    //if form is valid then try to authenticate and store data to firestore

    await authProvider.registerWithEmailAndPassword(
        UserModel(
            name: widget.name,
            email: widget.email,
            phone: int.parse(widget.phone),
            imageUrl: pickedImage!.path,
            userId: 'userId',
            bioText: bioText,
            dateOfBirth: pickedDate!.toIso8601String(),
            createAt: DateTime.now().toIso8601String(),
            gender: gender == Gender.male ? 'Male' : 'Female'),
        widget.password,
        pickedImage!,
        context);

        setState(() {
          isLoading=false;
        });
  }

  //pickImage from gallery and Camera function

  _pickImage(BuildContext ctx, ImageSource imageSource) async {
    try {
      final result = await picker.pickImage(
          source: imageSource, maxHeight: 640, maxWidth: 640);
      if (result == null) {
        return;
      }

      final imageTemporary = File(result.path);

      setState(() {
        pickedImage = imageTemporary;
      });
    } on PlatformException catch (err) {
      return ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image : ${err.message}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHieght = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: deviceWidth * 0.02, vertical: deviceHieght * 0.01),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: pickedImage != null
                ? CircleAvatar(
                    backgroundColor: Color(logoColor),
                    radius: deviceHieght * 0.08,
                    child: CircleAvatar(
                      radius: deviceHieght * 0.07,
                      backgroundColor: Colors.white,
                      backgroundImage: FileImage(
                        pickedImage!,
                      ),
                    ),
                  )
                : CircleAvatar(
                    backgroundColor: Color(logoColor),
                    radius: deviceHieght * 0.08,
                    child: CircleAvatar(
                      radius: deviceHieght * 0.07,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person_2_outlined,
                        size: 60,
                        color: Color(backgroundColor),
                      ),
                    ),
                  ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () => _pickImage(context, ImageSource.gallery),
                icon: Icon(
                  Icons.image_outlined,
                  size: deviceHieght * 0.03,
                  color: Color(logoColor),
                ),
                label: Text(
                  'Gallery',
                  style: TextStyle(
                    fontSize: deviceHieght * 0.02,
                    color: Color(logoColor),
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => _pickImage(context, ImageSource.camera),
                icon: Icon(
                  Icons.camera_alt,
                  size: deviceHieght * 0.03,
                  color: Color(logoColor),
                ),
                label: Text(
                  'Camera',
                  style: TextStyle(
                    fontSize: deviceHieght * 0.02,
                    color: Color(logoColor),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: deviceHieght * 0.01,
          ),
//----------------------Date of birth picker---------------------

          Text(
            'Date Of Birth',
            style: subtitleTextStyle,
          ),
          SizedBox(
            height: deviceHieght * 0.01,
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                  horizontal: deviceWidth * 0.02, vertical: deviceHieght * .01),
              backgroundColor: Color(logoColor),
              shape: const StadiumBorder(),
            ),
            onPressed: () async {
              var _datePicked = await DatePicker.showSimpleDatePicker(
                context,
                textColor: Color(backgroundColor),
                backgroundColor: Color(logoColor),
                initialDate: DateTime(2000),
                firstDate: DateTime(1960),
                lastDate: DateTime(2018),
                dateFormat: "dd-MMMM-yyyy",
                locale: DateTimePickerLocale.en_us,
                looping: true,
              );

              setState(() {
                pickedDate = _datePicked;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.calendar_month_outlined,
                    color: Color(backgroundColor), size: deviceHieght * 0.03),
                const SizedBox(
                  width: 14,
                ),
                Text(
                  pickedDate == null
                      ? 'Select your date of birth'
                      : '${pickedDate!.day} / ${pickedDate!.month} / ${pickedDate!.year}',
                  style: TextStyle(
                      color: Color(backgroundColor),
                      fontSize: deviceHieght * 0.03,
                      fontWeight: FontWeight.w700),
                )
              ],
            ),
          ),

          SizedBox(
            height: deviceHieght * 0.01,
          ),

//-------------------------Gender selection--------------
          Text(
            'Gender',
            style: subtitleTextStyle,
          ),
          SizedBox(
            height: deviceHieght * 0.01,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        gender = Gender.male;
                      });

                      print('Male selected');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: deviceWidth * 0.20,
                      height: deviceHieght * 0.12,
                      decoration: BoxDecoration(
                          color:
                              gender == Gender.male ? Color(logoColor) : null,
                          border: Border.all(color: Color(logoColor)),
                          borderRadius: BorderRadius.circular(20)),
                      child: Image.asset('Assets/images/man (1).png'),
                    ),
                  ),
                   SizedBox(
            height: deviceHieght * 0.01,
          ),
                  Text(
                    'Male',
                    style: TextStyle(
                      fontSize: gender == Gender.male ? 22 : 18,
                      color: Color(logoColor),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        gender = Gender.female;
                      });
                      print('Female selected');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: deviceWidth * 0.20,
                      height: deviceHieght * 0.12,
                      decoration: BoxDecoration(
                          color:
                              gender == Gender.female ? Color(logoColor) : null,
                          border: Border.all(color: Color(logoColor)),
                          borderRadius: BorderRadius.circular(20)),
                      child: Image.asset('Assets/images/woman.png'),
                    ),
                  ),
                   SizedBox(
            height: deviceHieght * 0.01,
          ),
                  Text(
                    'Female',
                    style: TextStyle(
                      fontSize: gender == Gender.female ? 22 : 18,
                      color: Color(logoColor),
                    ),
                  ),
                ],
              )
            ],
          ),

//------------------bio description text field-------------------

          SizedBox(
            height: deviceHieght * 0.01,
          ),
          Text(
            'Bio',
            style: subtitleTextStyle,
          ),
         SizedBox(
            height: deviceHieght * 0.01,
          ),
          TextFormField(
            style: TextStyle(
                color: Color(
                  logoColor,
                ),
                fontSize: 22),
            maxLines: 5,
            maxLength: 200,
            onChanged: (val) {
              bioText = val;
            },
            initialValue:
                "Hi, I'm new here! Looking to make some new connections and have interesting conversations.",
            autocorrect: true,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Color(logoColor), width: 3),
              ),
              hintText:
                  "Hi, I'm new here! Looking to make some new connections and have interesting conversations.",
              hintStyle: subtitleTextStyle,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Color(logoColor), width: 1),
              ),
              border: const OutlineInputBorder(),
            ),
          ),

//---------------Signup button-------------------------
  SizedBox(
            height: deviceHieght * 0.01,
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Color(logoColor),
                  ),
                )
              : Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _trySubmit(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding:  EdgeInsets.symmetric(
                          horizontal:deviceWidth*0.04 , vertical: deviceHieght*0.01),
                      backgroundColor: Color(logoColor),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      "SIGNUP",
                      style: TextStyle(
                          color: Color(backgroundColor),
                          letterSpacing: .5,
                          fontSize: deviceHieght*0.03,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
