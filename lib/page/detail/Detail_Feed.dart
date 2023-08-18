import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class DetailFeed extends StatefulWidget {
  final keys;

  const DetailFeed({Key? key, required this.keys}) : super(key: key);
  @override
  State<DetailFeed> createState() => DetailFeedState(keys);
}

class DetailFeedState extends State<DetailFeed> {

  final keys;
  DetailFeedState(this.keys);

  bool isLoading = false;
  final fDatabaseProduct = FirebaseDatabase.instance.ref().child("admin").child("feed");

  String? judul;
  String? kategori;
  String? likes;
  String? deskripsi;
  String? images;

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    var juduls = await fDatabaseProduct.child(keys).child("judul_feed").get();
    var kategoris = await fDatabaseProduct.child(keys).child("kategori").get();
    var likess = await fDatabaseProduct.child(keys).child("likes").get();
    var deskripsis = await fDatabaseProduct.child(keys).child("description").get();
    var imagess = await fDatabaseProduct.child(keys).child("images").get();

    setState(() {
      judul = juduls.value.toString();
      kategori = kategoris.value.toString();
      likes = likess.value.toString();
      deskripsi = deskripsis.value.toString();
      images = imagess.value.toString();
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

    return Scaffold(
        body: isLoading
            ? Center(child: CircularProgressIndicator(),)
            : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:  NetworkImage(images!),
                          fit: BoxFit.cover
                      )
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 50, left: 20),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle
                    ),
                    child: InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Iconsax.arrow_left,
                        color: Colors.white,
                        size: 20,
                      ),
                    )
                )
              ],
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(kategori!, style: TextStyle(color: Color(0xffaeaeae), fontSize: 15),),
                        SizedBox(height: 10,),
                        Text(judul!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),)
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Iconsax.heart5, color: Colors.red, size: 20,),
                        SizedBox(width: 5,),
                        Text(likes.toString() + " likes", style: TextStyle(color: Color(0xffaeaeae)),)
                      ],
                    )
                  ],
                )
            ),
            Divider(thickness: 1,),
            Container(
              height: 90,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Barber", style: TextStyle(color: Color(0xffaeaeae), fontSize: 15),),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text("Dewi Fortuna", style: TextStyle(fontWeight: FontWeight.bold),)
                    ],
                  )
                ],
              ),
            ),
            Divider(thickness: 1,),
            Container(
              height:200,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Deskripsi", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                  SizedBox(height: 10,),
                  Text(deskripsi!, style: TextStyle(color: Color(0xffaeaeae), fontSize: 14, height: 1.5),)
                ],
              ),
            ),
          ],
        )
    );
  }

}