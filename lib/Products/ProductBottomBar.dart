import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:make_musician/Products/ProductDetail2.dart';

class ProductBottomBar extends StatelessWidget{


  @override
  Widget build(BuildContext context){

    return BottomAppBar(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
            height: 80,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    alignment: Alignment.center,
                    height: 50,
                  
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: InkWell(
                      onTap: () { 
                               Navigator.pushNamed(context, "cart");
                               
                      },
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.symmetric(horizontal:50)),
                          InkWell(
                            onTap:() {},
                            child: Text("ADD TO CART",
                                      style:TextStyle(fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                       color: Colors.black)),
                          ),
                          
                        ],
                      ),
                    )
                )

              ]),
        )
    );
  }
}