// ignore_for_file: non_constant_identifier_names, curly_braces_in_flow_control_structures, duplicate_ignore, library_private_types_in_public_api

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class EditProfileUI extends StatefulWidget {
  const EditProfileUI({super.key});

  @override
  _EditProfileUIState createState() => _EditProfileUIState();
}

class _EditProfileUIState extends State<EditProfileUI> {
  bool isObscurePassword = true;
  String firstname = "";
  String lastname = "";
  String email = "";
  String mobile_number = "";
  String? profilePic;
  bool isValid = false; //key for form

  static bool isProfileImageUploded =false;
  static bool isProfileUpload =false;

  String imgPath ="";
  String firebaseProfilePic ="";
  String imgUrl ="";
  String profilePicUrl ="";

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController =  TextEditingController();
  TextEditingController mobileController =  TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void getProfileData() async {

   final user = FirebaseAuth.instance.currentUser;
    var var1 = await FirebaseFirestore.instance
        .collection("user_info") //collection name
        .doc(user!.uid) //id
        .get();

    setState(() {
      firstname = var1.data()?['firstname'];
      lastname = var1.data()?['lastname'];
      email = var1.data()?['email'];
      mobile_number = var1.data()?['mobilenumber'];
      profilePicUrl=var1.data()?['profileImg'];
      
    });    
  }

  UploadImage() async{

        String uniqueName =  DateTime.now().millisecondsSinceEpoch.toString();

        Reference refernceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImage = refernceRoot.child('user_profile_icon');
        Reference referenceImageToUpload = referenceDirImage.child(firstname+uniqueName);

        try{
          await referenceImageToUpload.putFile(File(imgPath));
         imgUrl= await referenceImageToUpload.getDownloadURL();


            }
        catch(e){
            if (kDebugMode) {
              print(e);
            }
                    }
  }

  @override
  void initState() {
    getProfileData(); // get The Data
    super.initState();
  }

  saveUserinfo(){
    if (kDebugMode) {
      print("#1234 saveInfo file saveUserinfo  ==>> ");
    }

    try {
      Map<String, dynamic> data = {
        'uid':FirebaseAuth.instance.currentUser?.uid,
        'firstname': firstname,
        'lastname': lastNameController.text,
        'email': emailController.text,
        'mobilenumber': mobileController.text,

        if(firebaseProfilePic.isNotEmpty) 'profileImg' : firebaseProfilePic else  'profileImg' : profilePicUrl,
      };
      if (kDebugMode) {
        print(data);
      }
      if (kDebugMode) {
        print(FirebaseAuth.instance.currentUser!.uid);
      }

      FirebaseFirestore.instance
          .collection('user_info')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(data)
          .whenComplete(() {
            if (kDebugMode) {
              print("#123 data updated ===>> ");
            }
             FirebaseAuth.instance.currentUser!
            .updateDisplayName(firstNameController.text)
            .whenComplete(() {
              setState(() {
                profilePicUrl = firebaseProfilePic;
              });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // getProfileData(); 
    // print(imgPath);
    // print(imgUrl);
    //print("fname:$firstname\nfname:$lastname\nfname:$email\nfname:$mobile_number");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white12,
        title: const Text('User Profile'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.blue,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(children: [
            Center(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        final XFile? pickImage = await ImagePicker().pickImage(
                            source: ImageSource.gallery, imageQuality: 50);
                            
                        if (pickImage != null) {
                          setState(() {
                            imgPath = pickImage.path;
                          });
                        }
                      },
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: const BoxDecoration(
                           shape: BoxShape.circle
                        ),
                        child :Image.network(profilePicUrl)
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    controller: firstNameController =TextEditingController(text:firstname),
                    onChanged: ((value) {
                      firstname = value;
                    }),
                    decoration: const InputDecoration(
                        labelText: "Enter First Name"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Field must be filled";
                      } else if (!RegExp(r'[A-Za-z]').hasMatch(value))
                        // ignore: curly_braces_in_flow_control_structures
                        return "Only alphabets allowed.";
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: lastNameController = TextEditingController(text:lastname),
                    decoration: const InputDecoration(
                      
                        labelText: "Enter Last Name"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Field must be filled";
                      } else if (!RegExp(r'[A-Za-z]').hasMatch(value))
                        return "Only alphabets allowed.";
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: emailController= TextEditingController(text: email),
                    decoration: const InputDecoration(
                  
                        labelText: "Enter Email"),
                    onChanged: (value) {
                      if (value.contains("@gmail.com")) {
                        setState(() {
                          isValid = true;
                        });
                      } else {
                        setState(() {
                          isValid = false;
                        });
                      }
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Field must be filled";
                      } else if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[-\w]{2,4}')
                          .hasMatch(value)) return "Please Enter Valid E-mail";
                      return null;
                    },
                  ),
                  TextFormField(
                      controller: mobileController =TextEditingController(text: mobile_number),
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        
                          labelText: "Enter Mobile Number"),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field must be filled";
                        } else if (!RegExp(r'[0-9]{10}').hasMatch(value))
                          return "Enter Valid Mobile Number";
                        return null;
                      }),
                ]),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // isSaving = false;
                    if (_formKey.currentState!.validate()) {
                      SystemChannels.textInput.invokeListMethod('TextInput.hide');
                      saveInfo();
                    }
                  },
                  child: const Text("SAVE",
                      style: TextStyle(
                          fontSize: 15, letterSpacing: 2, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: TextField(
        obscureText: isPasswordTextField ? isObscurePassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    icon: const Icon(Icons.remove_red_eye, color: Colors.grey),
                    onPressed: () {})
                : null,
            contentPadding: const EdgeInsets.only(bottom: 5),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            )),
      ),
    );
  }

  // String? DownloadUrl;
  Future<String?> uploadImage(File FilePath, String? reference) async {
    try {
      final fileName =
          '${FirebaseAuth.instance.currentUser!.uid}${DateTime.now().second}';
      final Reference fbStorage =
          FirebaseStorage.instance.ref(reference).child(fileName);
      final UploadTask uploadTask = fbStorage.putFile(FilePath);
      await uploadTask.whenComplete(() async {
        firebaseProfilePic =  await fbStorage.getDownloadURL();
      });


    } catch (e) {
      print(e.toString());
      return null;
    }
    return null;
  }

  saveInfo() {
    print("#1234 saveInfo call  ==>> ");
    uploadImage(File(imgPath), 'profile').whenComplete(() {
      saveUserinfo();
    });
  }
}
