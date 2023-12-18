import 'package:flutter/material.dart';

class CartBottomBar extends StatelessWidget{

  @override
  Widget build(BuildContext context){

    return BottomAppBar(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
            height: 130,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Amount",
                    style:TextStyle(
                              fontSize: 22, 
                              color: Colors.blue,
                              fontWeight: FontWeight.bold, )
                        ),

                        Text("500000 ₨",
                              style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue
                              ),
                              )
                        ],
                ),

                Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: InkWell(
                      onTap: () => print("Checking out..."),
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.only(left:130)),
                          Text("Checkout",
                                    style:TextStyle(fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                     color: Colors.black)),
                          
                        ],
                      ),
                    )
                )

              ]),
        )
    );
  }
}