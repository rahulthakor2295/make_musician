// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:make_musician/Cart/CartBottomBar.dart';

class CartItemsList extends StatelessWidget{

  void OnPressIcon(){
    print("Icon Pressed");
  }

  final List products =[];

  fetchProducts() async{

    var _firestoreinstance = FirebaseFirestore.instance;
    QuerySnapshot qn= await _firestoreinstance.collection("user_cart").get();


    if(qn.docs.length > 0) {


      for(int i=0; i<qn.docs.length; i++){
        products.add(
            {"cart_id": qn.docs[i]["cart_id"],
              "product_name":qn.docs[i]["product_name"],
              "user_id":qn.docs[i]["uid"],
              "product_img":qn.docs[i]["product_img"],
              "price":qn.docs[i]["price"],
              "quantity":qn.docs[i]["quantity"]
            });
      }
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart Page"),
      ),

      body:Container (
        child: Container(
          //padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
            child:Column(
              children: [
                // Expanded(
                //     child: GridView.builder(
                //         scrollDirection: Axis.vertical,
                //         itemCount: products.length,
                //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //             crossAxisCount: 1,
                //             childAspectRatio: 0.83),
                //         itemBuilder: (BuildContext context,index) {
                //           return Card(
                //             color: Colors.blue[50],
                //             elevation: 10,
                //             child: Column(
                //                 children: [
                //                   Container(
                //                     margin: EdgeInsets.all(10),
                //                     child: Image.network(products[index]["product_img"].toString()),
                //                   ),
                //
                //                   // Container(
                //                   //               child:Text(products[index]["pid"],
                //                   //                     style: TextStyle(fontSize: 18,
                //                   //  fontWeight: FontWeight.bold,
                //                   //  color: Colors.blue),
                //                   //               )
                //
                //                   //           ),
                //
                //                   Container(
                //                       padding: EdgeInsets.only(bottom: 10),
                //                       alignment: Alignment.center,
                //                       child:Text(products[index]["product_name"],
                //                         style: TextStyle(fontSize: 18,
                //                             fontWeight: FontWeight.bold,
                //                             color: Colors.blue),
                //                       )
                //
                //                   ),
                //
                //
                //                   Container(
                //                     child:Text(products[index]["price"].toString()+" ₹",
                //                       style: TextStyle(fontSize: 15,
                //                           fontWeight: FontWeight.bold,
                //                           color: Colors.black),
                //                     ),
                //                   )
                //                 ]),
                //           );
                //
                //         }
                //     )
                // )
              ],
            )



        ),
      ),




    );
    
  }
}