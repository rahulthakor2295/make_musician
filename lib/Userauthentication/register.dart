import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:make_musician/models/user_model.dart';
import 'package:make_musician/test_firebase.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = FirebaseAuth.instance;

//storing image path and url of the profile image
  String imgPath="";
  String imgUrl="";

  final _text = TextEditingController();
  final _formKey = GlobalKey<FormState>(); //key for form
  bool isValid = false;
  bool isPassVisible = true, isConPassVisible = true;

  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final mobilenumberController = TextEditingController();

   UploadImage() async{

        String uniqueName =  DateTime.now().millisecondsSinceEpoch.toString();

        Reference refernceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImage = refernceRoot.child('user_profile_icon');
        Reference referenceImageToUpload = referenceDirImage.child("$uniqueName");

        try{
          await referenceImageToUpload.putFile(File(imgPath));
         imgUrl= await referenceImageToUpload.getDownloadURL();

            }

        catch(e){

            print(e);

                }
                print("imgpath $imgPath imgurl $imgUrl");

  }

  @override
  Widget build(BuildContext context) {
   
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/register.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(left: 35),
              child: Text("\n\nCreate Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                  )),
            ),
            
            SizedBox(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(left: 35, top: 250, right: 35),
                  child: Form(
                    key: _formKey, //key for form
                    child: Column(
                      children: [

                        GestureDetector(
                      onTap: () async {
                        final XFile? pickImage = await ImagePicker().pickImage(
                            source: ImageSource.gallery, imageQuality: 50);

                            UploadImage();
                            
                        if (pickImage != null) {
                          setState(() {
                             imgPath = pickImage.path;
                          });
                        }
                      },
                      child: Container(
                        width: 100,
                        height: 80,
                        child: imgPath=="" ? CircleAvatar(
                                radius: 50,
                                child: Image.asset(
                                  "images/icons/profile_icon.png",
                                  width: 100,
                                  height: 100,
                                ),
                                
                              )
                            : CircleAvatar(
                                radius: 50,
                               backgroundImage: FileImage(
                                 File(imgPath),
                                ),
                              ),
                      ),
                        ),
                    
                        TextFormField(
                            controller: firstnameController,
                            decoration: InputDecoration(
                              hintText: "Enter First Name",
                              labelText: "First Name",
                              hintStyle: TextStyle(color: Colors.white),
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Field must be filled";
                              else if (!RegExp(r'[A-Za-z]').hasMatch(value))
                                return "Only alphabets allowed.";
                            }),
                        SizedBox(
                          // for margin between 2 textbox
                          height: 10,
                        ),
                        TextFormField(
                            controller: lastnameController,
                            decoration: InputDecoration(
                                hintText: "Enter Last Name",
                                labelText: "Last Name",
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Field must be filled";
                              else if (!RegExp(r'[A-Za-z]').hasMatch(value))
                                return "Only alphabets allowed.";
                            }),
                        SizedBox(
                          // for margin between 2 textbox
                          height: 10,
                        ),
                        TextFormField(
                            controller: emailController,
                            onChanged: (value) {
                              if (value.contains("@gmail.com")) {
                                setState(() {
                                  isValid = true;
                                });
                              } else
                                setState(() {
                                  isValid = false;
                                });
                            },
                            keyboardType: TextInputType
                                .emailAddress, // email type keyboar displayed
                            decoration: InputDecoration(
                                hintText: "Enter E-Mail",
                                labelText: "E-mail",
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.email),
                                suffixIcon: isValid ? Icon(Icons.check) : null,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Field must be filled";
                              else if (!RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[-\w]{2,4}')
                                  .hasMatch(value))
                                return "Please Enter Valid E-mail";
                            }),
                        SizedBox(
                          // for margin between 2 textbox
                          height: 10,
                        ),
                        TextFormField(
                            controller: passwordController,
                            obscureText:
                                isPassVisible, // for password field character is in hidden form
                            decoration: InputDecoration(
                                hintText: "Enter Password",
                                labelText: "Password",
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.password),
                                suffix: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isPassVisible = !isPassVisible;
                                    });
                                  },
                                  child: Icon(Icons.remove_red_eye_outlined,
                                      color: isPassVisible
                                          ? Colors.grey
                                          : Colors.greenAccent),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Field must be filled";
                              else if (value.length < 8)
                                return "Password must be more than 8 characters";
                              else if (!RegExp(r'(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*\W).*$')
                                  .hasMatch(value))
                                return "Password must contains alphabets lowercase and uppercase and\natleast one special characters";
                              
                            }),
                        SizedBox(
                          // for margin between 2 textbox
                          height: 10,
                        ),
                        TextFormField(
                            controller: confirmPasswordController,
                            obscureText:
                                isConPassVisible, // for password field character is in hidden form
                            decoration: InputDecoration(
                                hintText: "Confirm password",
                                labelText: "Confirm Password",
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.password),
                                suffix: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isConPassVisible = !isConPassVisible;
                                    });
                                  },
                                  child: Icon(Icons.remove_red_eye_outlined,
                                      color: isConPassVisible
                                          ? Colors.grey
                                          : Colors.greenAccent),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Field must be filled";
                              else if (value.length < 8)
                                return "Password must be more than 8 characters";
                              else if (!RegExp(r'[A-Za-z0-9!@#$%^&*_]{8,}')
                                  .hasMatch(value))
                                return "Password must contains alphanumberic and\natleast one special characters";
                              else if(passwordController.text != confirmPasswordController.text)
                                return "Password and Confirm password must be same";
                            }),
                        SizedBox(
                          // for margin between 2 textbox
                          height: 10,
                        ),
                        TextFormField(
                            controller: mobilenumberController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                hintText: "Enter Mobile Number",
                                labelText: "Mobile Number",
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(Icons.mobile_friendly),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value!.isEmpty)
                                return "Field must be filled";
                              else if (!RegExp(r'[0-9]{10}').hasMatch(value))
                                return "Enter Valid Mobile Number";
                            }),
                        SizedBox(
                          // for margin between 2 textbox
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //  Padding(
                            //   padding: EdgeInsets.only(left: 10)
                            //   ),

                            Text("REGISTER",
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            CircleAvatar(
                                radius: 25,
                                backgroundColor: Color(0xff4c505b),
                                child: IconButton(
                                  color: Colors.white,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      
                                      signUp(emailController.text,
                                          passwordController.text);
                                          

                                          // Fluttertoast.showToast(msg: firstnameController.text +lastnameController.text+passwordController.text+confirmPasswordController.text+emailController.text+mobilenumberController.text);
                                    }
                                  },
                                  icon: Icon(Icons.arrow_forward),
                                ))
                          ],
                        ),
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.only(top: 80)),
                            Text("Already have account ?",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black)),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, "login");
                                },
                                child: Text(
                                  "SIGN IN",
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.black,
                                      decoration: TextDecoration.underline),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim())
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
            print(e);

        // Fluttertoast.showToast(msg: e);
      });
    }
  }

  postDetailsToFirestore() async {
    //calling a firestore

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;



//generate random number for product id
  Random random = new Random();
  int user_id =random.nextInt(100);

   Map<String, dynamic> product_data={
    "uid":"${user!.uid}",
    "firstname": firstnameController.text ,
    "lastname": lastnameController.text, 
    "email": emailController.text ,
    "password":passwordController.text,
    "mobilenumber":mobilenumberController.text,
    "profileImg":imgUrl};

   try{

   DocumentReference documentReference = await FirebaseFirestore.instance.collection("user_info").doc(user.uid);
   documentReference.set(product_data);
   }
   catch(e){
    print(e);
   }
   print(product_data);
   
    // UserModel userModel = UserModel();
    // userModel.uid = user!.uid;
    // userModel.firstname = firstnameController.text;
    // userModel.lastname = lastnameController.text;
    // userModel.email = user.email;
    // userModel.password = passwordController.text;
    // userModel.mobilenumber = mobilenumberController.text;

    // Map<String,dynamic> userData=
    // {"uid": "${user.uid}",
    // "firstname": "${firstnameController.text}",
    // "lastname": "${lastnameController.text}",
    // "email": "${emailController.text}",
    // "password": "${passwordController.text}",
    // "mobile": "${mobilenumberController.text}"
    // };

    

    // await firebaseFirestore
    //     .collection("user_info")
    //     .doc(user.uid)
    //     .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Account Created Successfully :");
    Navigator.pushAndRemoveUntil((context),
        MaterialPageRoute(builder: (context) => Test_Firebase()), (Route) => false);

  }
}
