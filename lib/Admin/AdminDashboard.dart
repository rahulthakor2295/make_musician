import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:make_musician/Admin/AddProduct.dart';
import 'package:make_musician/Admin/ViewProduct.dart';
import 'package:make_musician/Userauthentication/login.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  showConnectionDialog() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text("No Connection"),
        content: const Text("Please Check Your Internet Connectivity"),
        actions: [
          TextButton(
              onPressed: () async {
                Navigator.pop(context, "cancel");
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;

                if (!isDeviceConnected) {
                  showConnectionDialog();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text("OK"))
        ],
      ),
    );
  }

  void getConnectivity() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;

      if (!isDeviceConnected && isAlertSet == false) {
        showConnectionDialog();
        setState(() => isAlertSet = true);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
          },
          child: Container(

            child: Center(child: Icon(Icons.logout)),
          ),
        ),
        backgroundColor: Colors.orange[50],
        appBar: AppBar(
          title: Text("ADMIN DASHBOARD"),
        ),
        body: Container(
            child: Center(
          child: Column(
            children: [
              Text(
                "WELCOME ADMIN...",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 40,
              ),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  SizedBox(height: 80),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    height: 50,
                    color: Colors.lightBlue,
                    elevation: 10,
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        "addProduct",
                      );
                    },
                    child: Text("ADD PRODUCTS",
                        style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      height: 50,
                      color: Colors.lightBlue,
                      elevation: 10,
                      onPressed: () {
                        Navigator.pushNamed(context, "viewProduct");
                      },
                      child: Text(
                        "VIEW PRODUCTS",
                        style: TextStyle(color: Colors.white),
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    height: 50,
                    color: Colors.lightBlue,
                    elevation: 10,
                    onPressed: () {
                      Navigator.pushNamed(context, "viewOrder");
                    },
                    child: Text("VIEW ORDERS",
                        style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ],
          ),
        )));
  }
}
