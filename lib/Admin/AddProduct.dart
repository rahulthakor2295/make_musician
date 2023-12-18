import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:make_musician/Admin/AdminDashboard.dart';

class AddProduct extends StatefulWidget {
  AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  Random random = new Random();

  final productNameController = TextEditingController();
  final productDescController = TextEditingController();
  final productPriceController = TextEditingController();
  final productQuantityController = TextEditingController();
  final productCategoryController = TextEditingController();

  String imgUrl = "";

  List<String> productCategory = [
    "String",
    "WoodWind",
    "Percussion",
    "Keyboard",
    "Brass"
  ];
  String? selectedItem;
  File? files;

  final formKey = GlobalKey<FormState>(); //key for form
//  bool isValid=false;
//  bool isPassVisible=true, isConPassVisible=true;

  PickImage() async {
    ImagePicker imagePicker = ImagePicker();
  XFile?  file = await imagePicker.pickImage(source: ImageSource.gallery);
setState(() {
  files = File(file!.path);
});
    String uniqueName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference refernceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImage = refernceRoot.child('product_images');
    Reference referenceImageToUpload = referenceDirImage.child(uniqueName);

    try {
      await referenceImageToUpload.putFile(File(file!.path));
      imgUrl = await referenceImageToUpload.getDownloadURL();
      print("#asd ==>> $imgUrl");
    } catch (error) {
      print("#error ==>> $error");

    }
  }

  addProductFirebase() async {
//generate random number for product id
    int pro_id = random.nextInt(100);

    Map<String, dynamic> product_data = {
      "product_id": pro_id,
      "product_name": productNameController.text.trim().toLowerCase(),
      "product_desc": productDescController.text.trim(),
      "product_img": imgUrl.trim(),
      "product_category": selectedItem,
      "price": productPriceController.text.trim(),
      "quantity": productQuantityController.text.trim()
    };

    DocumentReference documentReference =
        await FirebaseFirestore.instance.collection("products").doc("$pro_id");
    documentReference.set(product_data);
  }

  DropdownMenuItem<String> buildMenuItem(String productCategory) =>
      DropdownMenuItem(
        value: productCategory,
        child: Text(productCategory,
            style: const TextStyle(
              fontSize: 15,
            )),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(
            top: 80,
            left: 110,
          ),
          child: const Text(
            "ADD PRODUCTS",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ), SizedBox(
          child: SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.only(left: 35, top: 150, right: 35),
                  child: Form(
                    key: formKey, //key for form
                    child: Column(
                      children: [

                        Container(
                          child: Stack(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.black12,
                                radius: 50,
                                child: files != null
                                    ? CircleAvatar(
                                  radius: 46.22,
                                  backgroundImage: FileImage(files!),
                                )
                                    : CircleAvatar(
                                  radius: 46.22,
                                  backgroundImage:
                                  AssetImage('images/noun-images-11204.png'),
                                ),
                              ),
                              Positioned(
                                top: 60.0,
                                right: 0.0,
                                child: Container(
                                  height: 28.0,
                                  width: 28.0,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFF9cc3ff),
                                        Color(0xFF458be6)
                                      ],
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(50.0),
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      onPressed: () {
                                        PickImage();
                                      },
                                      icon: SvgPicture.asset("images/ic_pencil.svg"),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        TextFormField(
                            controller: productNameController,
                            decoration: InputDecoration(
                                hintText: "Enter Product Name",
                                labelText: "Product Name",
                                hintStyle: const TextStyle(color: Colors.white),
                                prefixIcon: const Icon(Icons.person),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Field must be filled";
                              } else {
                                if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
                                  return "Only alphabets allowed.";
                                }
                              }
                            }),
                        const SizedBox(
                          // for margin between 2 textbox
                          height: 10,
                        ),
                        TextFormField(
                            controller: productDescController,
                            decoration: InputDecoration(
                                hintText: "Enter Product Description",
                                labelText: "Product Description",
                                hintStyle: const TextStyle(color: Colors.white),
                                prefixIcon: const Icon(Icons.person),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Field must be filled";
                              } else if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
                                return "Only alphabets allowed.";
                              }
                            }),
                        const SizedBox(
                          // for margin between 2 textbox
                          height: 10,
                        ),
                        const SizedBox(
                          // for margin between 2 textbox
                          height: 10,
                        ),
                        TextFormField(
                            keyboardType: TextInputType.number,
                            controller: productPriceController,
                            // for password field character is in hidden form
                            decoration: InputDecoration(
                                hintText: "Enter Product Price",
                                labelText: "Product Price",
                                hintStyle: const TextStyle(color: Colors.white),
                                prefixIcon: const Icon(Icons.password),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Field must be filled";
                              }
                            }),
                        const SizedBox(
                          // for margin between 2 textbox
                          height: 10,
                        ),
                        TextFormField(
                            controller: productQuantityController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: "Enter Product Quantity",
                                labelText: "Product Quantity",
                                hintStyle: const TextStyle(color: Colors.white),
                                prefixIcon: const Icon(Icons.mobile_friendly),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Field must be filled";
                              } else if (!RegExp(r'\d').hasMatch(value)) {
                                return "Enter Valid Number";
                              }
                            }),
                        Row(
                          children: [
                            const Text(
                              "Select Category",
                              style: TextStyle(fontSize: 20),
                            ),
                            const Spacer(),
                            DropdownButton<String>(
                                value: selectedItem,
                                items:
                                    productCategory.map(buildMenuItem).toList(),
                                onChanged: (val) {
                                  setState(() {
                                    selectedItem = val as String;
                                  });
                                }),
                          ],
                        ),
                        const SizedBox(
                          // for margin between 2 textbox
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //  Padding(
                            //   padding: EdgeInsets.only(left: 10)
                            //   ),

                            Center(
                              child: ElevatedButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      const CircularProgressIndicator();
                                      addProductFirebase();
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AdminDashboard()));
                                      Fluttertoast.showToast(
                                          msg: "Product Added Successfully");
                                    }
                                  },
                                  child: const Text("ADD TO DATABASE")),
                            )

                            // const Text("REGISTER", style: TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold)),
                            // CircleAvatar(

                            //   radius: 25,
                            //   backgroundColor: const Color(0xff4c505b),
                            //   child:IconButton(
                            //     color:Colors.white ,
                            //     onPressed: () async{
                            //        if(formKey.currentState!.validate())
                            //        {
                            //          Map<String,String> user_data ={"firstname": fnameController.text, "lastname": lnameController.text ,"email":emailController.text,"password":passController.text ,"mobile": mobileController.text};

                            //          print(user_data);

                            //          Navigator.pushNamed(context, "home_page");

                            //        }
                            //     },
                            //     icon: const Icon(Icons.arrow_forward),
                            //   )
                            // )
                          ],
                        ),
                      ],
                    ),
                  ))),
        )
      ],
    ));
  }
}
