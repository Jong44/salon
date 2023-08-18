import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:salon/page/detail/Detail_Product.dart';

import '../component/Format_Rupiah.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    List kategori = [
      'Semua',
      'Rambut',
      'Nail Art',
      'Eyelash',
      'Coloring'
    ];

    final fDatabaseProduct = FirebaseDatabase.instance.ref().child("admin").child("product");

    int indexKategori = 0;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff0D9488),
        elevation: 0,
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(left: 30, top: 10, bottom: 20),
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              color: Color(0xff0D9488)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Promo Eyelash 20% off", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 23, height: 1.5),),
                      Text('dapatkan dengan mengunduk apkiasi ini', style: TextStyle(color: Colors.white60, height: 1.5),),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              minimumSize: Size(100, 40)
                          ),
                          onPressed: (){},
                          child: Text("Get It Now",style: TextStyle(color: Color(0xff0D9488)),)
                      )
                    ],
                  ),
                ),

              ],
            )
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            width: double.infinity,
            height: 70,
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 1),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xffaeaeae), width: 1,),
                  borderRadius: BorderRadius.circular(50)
              ),
              child: TextField(
                style: TextStyle(fontSize: 15),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Iconsax.search_normal_1, size: 20,),
                    hintText: "Pencarian",
                ),
              ),
            )
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text("Kategori", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
          ),
          Container(
            width: double.infinity,
            height: 50,
            child: ListView.builder(
              itemCount: kategori.length,
              scrollDirection: Axis.horizontal,
              itemExtent: 90,
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              itemBuilder: (BuildContext context, int index){


                return InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: (){
                    setState(() {
                      indexKategori = index;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        color: indexKategori == index  ? Color(0xff0D9488) : Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Color(0xffaeaeae), width: 1)
                    ),
                    child: Text(
                        kategori[index],
                      style: TextStyle(
                        color: indexKategori == index  ? Colors.white : Colors.black
                      ),
                    ),
                  )
                );
              }
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 300,
            child: FirebaseAnimatedList(
              defaultChild: Center(child: CircularProgressIndicator(),),
              query: fDatabaseProduct,
              itemBuilder: (context, snapshot, animation, index){

                Map product = snapshot.value as Map;
                product['key'] = snapshot.key;

                var nama = product['nama'];
                var harga = product['harga'];
                var point = product['point'];
                var image = product['image'];
                var description = product['deskripsi'];

                return InkWell(
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Detail(keys: product['key'],))
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    margin: EdgeInsets.only(top: 5),
                    width: double.infinity,
                    height: 100,
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(image)
                            )
                          ),

                        ),
                        SizedBox(width: 20,),
                        Container(
                          width: 270,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(nama, style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text(CurrencyFormat.convertToIdr(int.parse(harga), 2), style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff0D9488)),),
                                ],
                              ),
                              SizedBox(height: 13,),
                              Text(description, style: TextStyle(color: Color(0xffaeaeae), fontSize: 12),)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            )
          )
        ],
      )
    );
  }
  
}