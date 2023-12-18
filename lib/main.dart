import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:make_musician/Admin/AddProduct.dart';
import 'package:make_musician/Admin/AdminDashboard.dart';
import 'package:make_musician/Admin/AdminLogin.dart';
import 'package:make_musician/Admin/ViewOrder.dart';
import 'package:make_musician/Admin/ViewProduct.dart';
import 'package:make_musician/CheckOut/CashOnDelivery.dart';
import 'package:make_musician/Categories/Category_Brass.dart';
import 'package:make_musician/Categories/Category_Keyboard.dart';
import 'package:make_musician/Categories/Category_Percussion.dart';
import 'package:make_musician/Categories/Category_String.dart';
import 'package:make_musician/Categories/Category_WoodWind.dart';
import 'package:make_musician/InvoicePdf.dart';
import 'package:make_musician/MyOrderPage.dart';
import 'package:make_musician/Cart/ShoppingCart.dart';
import 'package:make_musician/MyProfile.dart';
import 'package:make_musician/CheckOut/CreditCardOption.dart';
import 'package:make_musician/CheckOut/PaymentOption.dart';
import 'package:make_musician/Products/ProductDetail2.dart';
import 'package:make_musician/CheckOut/ShippingInfo.dart';
import 'package:make_musician/SearchProduct.dart';
import 'package:make_musician/forget_password.dart';
import 'package:make_musician/Userauthentication/login.dart';
import 'package:make_musician/Userauthentication/otp.dart';
import 'package:make_musician/Userauthentication/phone.dart';
import 'package:make_musician/Userauthentication/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:make_musician/reset_password.dart';
import 'package:make_musician/test_firebase.dart';

Future main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseAnalytics analytics  =  FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: checkLoginStatus(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data == false) {
            return Login();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.blue,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return const Test_Firebase();
        },
      ),
   

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});


//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
      //debugShowCheckedModeBanner: false,
      //initialRoute: "login",
      //title: 'Flutter Demo',
      routes: {
        "phone": (context) => MyPhone(),
        "otp": (context) => MyOtp(),
        "login":(context) => Login(),
        "register":(context) => Register(),
        "forget_password": (context) => Forget_Password(),
        "myProfile": (context) => EditProfileUI(),
        "cart": (context) => ShoppingCart(),
        "myorder": (context) => MyOrderPage(),
        //"product_detail2": (context) =>ProductDetail2()
        "search": (context) => SearchProduct(""),
        "reset_password": (context) => Reset_Password(),
        "firebase": (context) => Test_Firebase(),
        "shippingInfo": (context) => ShippingInfo(0.0),
        "paymentOption": (context) => PaymentOption("",0.0),
        "creditCardOption": (context) => CreditCardPayment("",0.0),
        "cashOnDeliverOption": (context)=> CashOnDelivery(""),
        "pdfFile": (context) =>pdfFile(),

        //admin pages routes
        "adminLogin": (context) => AdminLogin(),
        "adminDashboard": (context) => AdminDashboard(),
        "addProduct": (context) => AddProduct(),
        "viewProduct": (context) =>ViewProduct(),
        "viewOrder": (context) => ViewOrder(),
        
        
        //category page routes
        "String": (context) => StringCategory(),
        "Keyboard": (context) => KeyboardCategory(),
        "Percussion": (context) => PercussionCategory(),
        "WoodWind": (context) => WoodWindCategory(),
        "Brass": (context) => BrassCategory(),
      },
      
    ),
  );
}
  
  final Storage = new FlutterSecureStorage();

Future<bool> checkLoginStatus() async {
  String? Value = await Storage.read(key: "uid");
  if (Value == null) {
    return false;
  } else {
    return true;
  }

}



