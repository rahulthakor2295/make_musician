import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:make_musician/CheckOut/CreditCardOption.dart';
import 'package:make_musician/CheckOut/PaymentOption.dart';

class ShippingInfo extends StatefulWidget {

  double totalamount=0.0;
  ShippingInfo(this.totalamount);

  @override
  State<ShippingInfo> createState() => _ShippingInfoState();
}

class _ShippingInfoState extends State<ShippingInfo> {
  TextEditingController houseNoController = new TextEditingController();
  TextEditingController buildingNameController = new TextEditingController();
  TextEditingController areaNameController = new TextEditingController();
  TextEditingController pincodeController = new TextEditingController();
  
  final _formKey = GlobalKey<FormState>();

//Constructor of Class
  _Dispatch_screenState() {
    Selected_city = _city[0];
  }

//List Of Cities
  final _city = [
    'Ahmedabad',
    'Baroda',
    'Surat',
    'Bharuch',
    'Gandhinagar',
    'Mahesana'
  ];

  String? Selected_city = "Ahmedabad"; //First Dropdown CityName

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Shipping Detail"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(left: 25, right: 25),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Image.asset(
                //Route Of Image
                "images/shipping_pic.jpeg",
                height: 180,
                width: 300,
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    
                    TextFormField(
                      controller: houseNoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "House No",
                        labelText:
                            "House No/Flat No",
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Icons.house),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return "Field must be filled";
                        else if(!RegExp(r'\d').hasMatch(value))
                         return "Only alphabets allowed";
                      },
                    ),
                    SizedBox(height: 10),

                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: buildingNameController,
                      decoration: InputDecoration(
                        hintText: "Apartment Name/Building Name",
                        labelText:
                            "Apartment Name",
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Icons.house),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return "Field must be filled";
                        else if(!RegExp(r'[A-Za-z]').hasMatch(value))
                         return "Only alphabets allowed";
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: areaNameController,
                      decoration: InputDecoration(
                        hintText: "Area Name,Street",
                        labelText:
                            "Area Name/Street",
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Icons.location_city),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) 
                          return "Field must be filled";
                        else if(!RegExp(r'[A-Za-z]').hasMatch(value))
                         return "Only alphabets allowed";
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // DropDown Menu
                    TextFormField(
                      controller: pincodeController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: InputDecoration(
                        hintText: "Pincode",
                        labelText: "Pincode",
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Icons.pin),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) return "Field must be filled";

                        return value.length < 6
                            ? 'Minimum character length is 6'
                            : null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    DropdownButtonFormField(
                      value: Selected_city,
                      items: _city.map((e) {
                        return DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          Selected_city = value;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.blue,
                      ),
                      decoration: InputDecoration(labelText: "City Name"),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          UsethisAdress();
                        },
                        child: Text("PROCEED TO PAY"),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void UsethisAdress() {
    if (_formKey.currentState!.validate()) {

      String Address="${houseNoController.text.trim()},${buildingNameController.text.trim()},\n${areaNameController.text.trim()},${Selected_city}-${pincodeController.text.trim()}";

      //pass the data of form to the order page
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PaymentOption(Address,widget.totalamount)));

      
    }
  }
}
