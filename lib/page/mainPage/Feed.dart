import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:salon/page/detail/Detail_Feed.dart';
import 'package:salon/page/mainPage/Profile.dart';

class Feed extends StatefulWidget {
  @override
  State<Feed> createState() => FeedState();
}

class FeedState extends State<Feed> {

  final fDatabaseFeed = FirebaseDatabase.instance.ref().child("admin").child("feed");
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
                child: Text("Feed", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),),
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
          body: Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: FirebaseAnimatedList(
                defaultChild: Center(child: CircularProgressIndicator(),),
                query: fDatabaseFeed,
                itemBuilder: (context, snapshot, animation, index){

                  Map feed = snapshot.value as Map;
                  feed['key'] = snapshot.key;

                  var judul = feed['judul_feed'];
                  var image = feed['images'];
                  var likes = feed['likes'];
                  var description = feed['description'];

                  return InkWell(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DetailFeed(keys: snapshot.key,))
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(width: 1, color: Color(0xfff1f1f1))
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(image),
                                    fit: BoxFit.cover
                                ),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5))
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(judul, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                      Row(
                                        children: [
                                          Icon(Iconsax.heart5, size: 15,),
                                          SizedBox(width: 5,),
                                          Text(likes.toString() +" likes", style: TextStyle(fontSize: 12),)
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 15,),
                                  Text(
                                    description,
                                    style: TextStyle(
                                        color: Color(0xffaeaeae),
                                        height: 1.5
                                    ),
                                  )
                                ],
                              )
                          )
                        ],
                      ),
                    ),
                  );
                }
            ),
          )
      );
    }


  }

}