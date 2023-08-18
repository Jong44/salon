import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:io';

import 'Profile.dart';

class Survey extends StatefulWidget {
  @override
  State<Survey> createState() => SurveyState();
}

class SurveyState extends State<Survey> {

  final userId = FirebaseAuth.instance.currentUser!.uid;

  String? name;
  String? images;
  bool isLoading = false;

  Future<void> getData() async {

    setState(() {
      isLoading = true;
    });

    var fDatabaseProfile = FirebaseDatabase.instance.ref().child("user").child(userId).child("profile");

    var nama = await fDatabaseProfile.child("nama").get();
    var img = await fDatabaseProfile.child("images").get();

    setState(() {
      name = nama.value.toString();
      images = img.value.toString();
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  int indexTap = 0;

  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 100,
            leading: Padding(
              padding: EdgeInsets.only(left: 20, top: 18),
              child: Text("Survey", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 17),),
            ),
            actions: [
              InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile())
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffaeaeae,)),
                      borderRadius: BorderRadius.circular(50)
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(images ?? "https://firebasestorage.googleapis.com/v0/b/salon-850cf.appspot.com/o/profile%2F6525a08f1df98a2e3a545fe2ace4be47.jpg?alt=media&token=e1276817-2fdf-41d7-9aec-6b8c2d73db4b"),
                                fit: BoxFit.cover
                            )
                        ),
                      ),
                      Text(name!, style: TextStyle(color: Colors.black, fontSize: 13),)
                    ],
                  ),
                ),
              )
            ]
        ),
        body: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            itemCount: 4,
            itemBuilder: (context, index){
              return Column(
                children: [
                  SizedBox(height: 30,),
                  InkWell(
                    onTap: (){
                      setState(() {
                        indexTap = index;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      height: 100,
                      decoration: BoxDecoration(
                          color: indexTap == index ? Color(0xffECFDFC) : Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(width: 1, color: indexTap == index? Color(0xff0D9488) : Color(0xffeaeaea))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(2),
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(width: 1, color: indexTap == index ? Color(0xff0D9488) : Color(0xff0D9488))
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xff0D9488),
                                          shape: BoxShape.circle
                                      ),
                                      child: Icon(Iconsax.crown5, size: 12, color: Colors.white,),
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Text("Lorem Ipsum", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),)
                                ],
                              ),
                              Text("Lorem Ipsum Dolor Amet Apa ya enaknya", style: TextStyle(color: Colors.grey, fontSize: 13),)
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(3),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                border: Border.all(width: 2, color: indexTap == index ? Color(0xff099699) : Color(0xffeeaeaea)),
                                shape: BoxShape.circle
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: indexTap == index ? Color(0xff099699) : Colors.white,
                                shape: BoxShape.circle
                              ),
                            )
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
        ),
        bottomSheet: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(width: 1, color: Color(0xffeaeaea))
              )
          ),
          child: InkWell(
            onTap: (){
              ModalSuccess();
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xff0D9488),
                  borderRadius: BorderRadius.circular(50)
              ),
              alignment: Alignment.center,
              child: Text("Kirim Survey", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            ),
          ),
        ),

      );
    }
    }

    ModalSuccess(){
      return showModalBottomSheet(
          context: context,
          builder: ((builder) => Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            height: 300,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Color(0xECECFDF3),
                    shape: BoxShape.circle
                  ),
                  child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xffD1FADF),
                          shape: BoxShape.circle
                      ),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Color(0xff039855)),
                          shape: BoxShape.circle
                      ),
                      child: Icon(
                        Icons.check,
                        size: 20,
                        color: Color(0xff039855),
                      ),
                    ),
                  )
                ),
                SizedBox(height: 10,),
                Text("Sukses !", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                SizedBox(height: 15,),
                Text(
                  "Terimakasih sudah mengisi survey dari kami, semoga kami menjadi lebih baik lagi",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey
                  ),
                ),
                SizedBox(height: 20,),
                Divider(thickness: 1.1, color: Colors.grey.shade300,),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color(0xff0D9488),
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child: Text("Beranda", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  ),
                )
              ],
            ),
          ))
      );
  }
}
