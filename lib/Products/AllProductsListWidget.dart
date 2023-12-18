// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:make_musician/models/ProductModel.dart';

class AllProductsListWidget extends StatelessWidget{

  final List products =[];
  fetchProducts() async{
    
    var _firestoreinstance = FirebaseFirestore.instance;
    QuerySnapshot qn= await _firestoreinstance.collection("products").get();

    
      if(qn.docs.length > 0) {

      
        // qn.docs.forEach((element) {
        //     products.add(
        //       Product(pro_name: element["product_name"], pro_desc: element["product_desc"], pro_img: element["product_img"], price: element["price"], quantity: element["quantity"])
        //     );
        // });
        for(int i=0; i<qn.docs.length; i++){
          products.add(
            {"product_name":qn.docs[i]["product_name"],
             "product_desc":qn.docs[i]["product_desc"],
             "product_img":qn.docs[i]["product_img"],
             "price":qn.docs[i]["price"],
             "quantity":qn.docs[i]["quantity"]
            });
        }
        

      }
      print(products);
      
   
  }
  @override
  Widget build(BuildContext context){
   
   
    return  GridView.count(
          childAspectRatio: 0.63,
          physics:const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          children: [
            for(int i=1; i<10; i++)
              Container(
                padding: EdgeInsets.only(left: 15 , right: 15 , top:10),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                      InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, "firebase");
                          
                          },
                          child: Container(
                                margin: EdgeInsets.all(10),
                                child: Image.asset("images/product_images/pro_$i.jpg", height: 120, width: 120,),
                          )
                      ),
                      Container(
                          padding: EdgeInsets.only(bottom: 10),
                          alignment: Alignment.centerLeft,
                          child:Text("Product Title",
                                style: TextStyle(fontSize: 18, 
                                                 fontWeight: FontWeight.bold, 
                                                 color: Colors.blue),
                          )

                      ),

                      Container(
                          padding: EdgeInsets.only(bottom: 1),
                          alignment: Alignment.centerLeft,
                          child:Text("description",
                                style: TextStyle(fontSize: 15, 
                                                 fontWeight: FontWeight.bold, 
                                                 color: Colors.black),
                          )
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1),
                        child: Row(
                          children: [
                            Text("5000 Rs.",
                                style: TextStyle(fontSize: 15, 
                                                 fontWeight: FontWeight.bold, 
                                                 color: Colors.black),
                          ),
                          IconButton(
                            padding: EdgeInsets.only(left:35),
                            color: Colors.blue,
                             icon: Icon(Icons.shopping_cart), 
                            onPressed: () { 
                              print("Product Added into cart.");
                             },

                          ),
                          
                          ]),
                        )
                ]),

            )
          ],

    );
  }
}