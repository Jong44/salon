import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:salon/page/component/QR_Code.dart';

import '../component/Date_Format.dart';
import '../component/Format_Rupiah.dart';

class Detail extends StatefulWidget {
  final keys;

  const Detail({Key? key, required this.keys}) : super(key: key);
  @override
  State<Detail> createState() => DetailState(keys);
}

class DetailState extends State<Detail> {
  final keys;
  DetailState(this.keys);
  bool isLoading = false;
  final fDatabaseProduct = FirebaseDatabase.instance.ref().child("admin").child("product");

  String? nama;
  String? point;
  String? deskripsi;
  String? image;
  String? harga;
  String? userId;
  String? date;

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    var user = await FirebaseAuth.instance.currentUser!.uid.toString();

    var namas = await fDatabaseProduct.child(keys).child("nama").get();
    var points = await fDatabaseProduct.child(keys).child("point").get();
    var deskripsis = await fDatabaseProduct.child(keys).child("deskripsi").get();
    var images = await fDatabaseProduct.child(keys).child("image").get();
    var hargas = await fDatabaseProduct.child(keys).child("harga").get();

    setState(() {
      userId = user;
      nama = namas.value.toString();
      point = points.value.toString();
      deskripsi = deskripsis.value.toString();
      harga = hargas.value.toString();
      image = images.value.toString();
      date = DateFormatter.formatDate(DateTime.now());
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
                        height: 350,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(image!),
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
                              Text("Rambut", style: TextStyle(color: Color(0xffaeaeae), fontSize: 15),),
                              SizedBox(height: 10,),
                              Text(nama!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),)
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Iconsax.crown5, color: Colors.green, size: 20,),
                              SizedBox(width: 5,),
                              Text( point! + " Points", style: TextStyle(color: Color(0xffaeaeae)),)
                            ],
                          )
                        ],
                      )
                  ),
                  Divider(thickness: 1,),
                  Container(
                    height: 100,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Harga Service", style: TextStyle(color: Color(0xffaeaeae), fontSize: 15),),
                        SizedBox(height: 10,),
                        Text(CurrencyFormat.convertToIdr(int.parse(harga!), 2), style: TextStyle(color: Color(0xff0D9488), fontWeight: FontWeight.bold, fontSize: 25),)
                      ],
                    ),
                  ),
                  Divider(thickness: 1,),
                  Container(
                    height: 100,
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
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QR_Code(userId: userId, namaProduct: nama, images: image, points: point, harga: harga, date: date))
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      height: 50,
                      decoration: BoxDecoration(
                          color: Color(0xff0D9488),
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: Text(
                        "Pesan",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15
                        ),
                      ),
                    ),
                  )
                ],
      )
    );
  }

}