import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:salon/page/component/QR_Code.dart';
import 'package:salon/page/mainPage/Feed.dart';
import 'package:salon/page/mainPage/Feedback.dart';
import 'package:salon/page/mainPage/Homepage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:salon/page/mainPage/Splash.dart';
import 'package:salon/page/mainPage/Survey.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gussy Salon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: Splash(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {

  final fAuth = FirebaseAuth.instance;
  late User loggedinUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user =  await fAuth.currentUser;
      if (user != null){
        loggedinUser = user;
      }
    } catch (e){
      print(e);
    }
  }

  int IndexPage = 0;

  List page = [
    HomePage(),
    Feed(),
    Survey(),
    Feedbacks()
  ];


  void updateIndex(int value){
    setState(() {
      IndexPage = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page[IndexPage],
      bottomNavigationBar: BottomNavigationBar(
        enableFeedback: false,
        onTap: updateIndex,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        iconSize: 20,
        selectedLabelStyle: TextStyle(height: 1.8, fontSize: 12),
        unselectedLabelStyle: TextStyle(height: 1.8, fontSize: 12),
        items: [
          BottomNavigationBarItem(
            icon: IndexPage == 0 ? Icon(Iconsax.home5, color: Color(0xff0D9488),) : Icon(Iconsax.home_1, color: Colors.black,),
            label: "Home",
          ),
          BottomNavigationBarItem(
              icon: IndexPage == 1 ? Icon(Iconsax.element_35, color: Color(0xff0D9488),) : Icon(Iconsax.element_3, color: Colors.black,),
              label: "Feed"
          ),
          BottomNavigationBarItem(
              icon: IndexPage == 2 ? Icon(Iconsax.clipboard_text5, color: Color(0xff0D9488),) : Icon(Iconsax.clipboard_text, color: Colors.black,),
              label: "Survey"
          ),
          BottomNavigationBarItem(
              icon: IndexPage == 3 ? Container(child: Icon(Iconsax.like_shapes5, color: Color(0xff0D9488),), alignment: Alignment.centerLeft, padding: EdgeInsets.only(left: 22),) : Icon(Iconsax.like_shapes, color: Colors.black,),
              label: "Feedback"
          )
        ],

      )
    );
  }

}

