import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:salon/page/component/Accordion.dart';

import 'Profile.dart';

class Feedbacks extends StatefulWidget {
  @override
  State<Feedbacks> createState() => FeedbackState();
}

class FeedbackState extends State<Feedbacks> {
  
  var FeedBackController = TextEditingController();
  bool isSubmit = false;

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
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    FeedBackController.dispose();
  }
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
           leading: Padding(
             padding: EdgeInsets.only(left: 20, top: 18),
             child: Text("FeedBack", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),),
           ),
           leadingWidth: 100,
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
       body: Padding(
         padding: EdgeInsets.symmetric(horizontal: 25),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Image.network("https://firebasestorage.googleapis.com/v0/b/salon-c3e71.appspot.com/o/Page%2Fpage%202.png?alt=media&token=2fab35bb-ba15-4ec2-92bb-90357b6de4d2", alignment: Alignment.center,),
             Center(
               child: Text(
                 "Bantu kami untuk menjadi lebih baik lagi",
                 textAlign: TextAlign.center,
                 style: TextStyle(
                     color: Colors.grey
                 ),
               ),
             ),
             SizedBox(height: 60,),
             Text(
               "Feedback",
               style: TextStyle(
                   fontSize: 20,
                   fontWeight: FontWeight.w500
               ),
             ),
             SizedBox(height: 20,),
             Column(
               children: [
                 Container(
                   alignment: Alignment.centerLeft,
                   padding: EdgeInsets.symmetric(horizontal: 15),
                   width: double.infinity,
                   height: 50,
                   decoration: BoxDecoration(
                       border: Border.all(width: 1, color: Color(0xffEAEAEA))
                   ),
                   child: Text("Feedback", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                 ),
                 Container(
                   decoration: BoxDecoration(
                       border: Border.all(width: 1, color: Color(0xffEAEAEA))
                   ),
                   child: TextField(
                     controller: FeedBackController,
                     style: TextStyle(
                         fontSize: 13
                     ),
                     onChanged: (String value) async {
                       if(value == ""){
                         setState(() {
                           isSubmit = false;
                         });
                       } else {
                         setState(() {
                           isSubmit = true;
                         });
                       }
                     },
                     maxLines: 8,
                     decoration: InputDecoration(
                         filled: true,
                         fillColor: Color(0xffF5F5F5),
                         border: InputBorder.none,
                         focusedBorder: InputBorder.none,
                         hintText: "Ketik Feedback Kamu"
                     ),
                   ),
                 )
               ],
             )

           ],
         ),
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
             if(isSubmit){
               FirebaseDatabase.instance.ref().child("admin").child("feedback").push().set({
                 "feedback" : FeedBackController.text,
                 "userId" : userId
               });
               ModalSuccess();
             }
           },
           child: Container(
             decoration: BoxDecoration(
                 color: isSubmit
                     ? Color(0xff0D9488)
                     : Color(0xffEDEDED),
                 borderRadius: BorderRadius.circular(50)
             ),
             alignment: Alignment.center,
             child: Text("Kirim Feedback", style: TextStyle(
                 color: isSubmit
                     ? Colors.white
                     : Colors.grey,
                 fontWeight: FontWeight.bold),
             ),
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