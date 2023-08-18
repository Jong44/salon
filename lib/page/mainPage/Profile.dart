import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:salon/page/component/Format_Rupiah.dart';
import 'package:salon/page/detail/Detail_Profile.dart';

class Profile extends StatefulWidget {


  const Profile({Key? key}) : super(key: key);
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile>{

  bool isLoading = false;
  String? image_profile;
  String? name;
  String? point;
  String? id;
  var userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future<void> getData() async{
    setState(() {
      isLoading = true;
    });
    var fDatabaseProfile = FirebaseDatabase.instance.ref().child("user").child(userId).child("profile");

    var nama = await fDatabaseProfile.child("nama").once();
    var images = await fDatabaseProfile.child("images").once();
    var idUser = await fDatabaseProfile.child("id").once();
    var points = await fDatabaseProfile.child("point").once();

    setState(() {
      name = nama.snapshot.value.toString();
      image_profile = images.snapshot.value.toString();
      id = idUser.snapshot.value.toString();
      point = points.snapshot.value.toString();
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff0D9488),
        elevation: 0,
        centerTitle: true,
        title: Text(
            "Profile",
          style: TextStyle(
            fontSize: 19
          ),
        ),
        leadingWidth: 100,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(255, 255, 255, 0.1)
            ),
            child: Icon(
                Icons.close
            ),
          ),
        )
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(),)
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            color: Color(0xff0D9488),
            height: 270,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(width: 2, color: Colors.white),
                                  image: DecorationImage(
                                    image: NetworkImage(image_profile ?? "https://firebasestorage.googleapis.com/v0/b/salon-850cf.appspot.com/o/profile%2F6525a08f1df98a2e3a545fe2ace4be47.jpg?alt=media&token=e1276817-2fdf-41d7-9aec-6b8c2d73db4b"),
                                    fit: BoxFit.cover
                                  )
                              ),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Hallo", style: TextStyle(color: Colors.grey, fontSize: 12),),
                                SizedBox(height: 5,),
                                Text(name!, style: TextStyle(color: Colors.white),)
                              ],
                            ),
                          ],
                        )
                    ),
                    TextButton(
                        onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DetailProfile())
                          );
                        },
                        child: Text("Edit Profile", style: TextStyle(color: Colors.white60),)
                    )
                  ],
                ),
                SizedBox(height: 25,),
                Container(
                  color: Colors.white,
                  height: 170,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("assets/Logo1.png"),
                            Text("ID " + id!.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                      Divider(color: Colors.grey.shade400, height: 2,),
                      Container(
                        height: 110,
                        alignment: Alignment.center,
                        child: Text("MEMBERSHIP", style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Color(0xff0D9488)),),
                      )
                    ],
                  ),
                ),

              ],
            ),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: 80,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 8, color: Color.fromRGBO(217, 217, 217, 0.2))
                  )
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: (){},
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      image: DecorationImage(
                          image: AssetImage("assets/frame.png")
                      )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(3),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(width: 1, color: Color(0xffFBBF25))
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Color(0xffFBBF25),
                                  shape: BoxShape.circle
                              ),
                              child: Icon(
                                Iconsax.crown1,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Text("Member Gold", style: TextStyle(color: Colors.white),)
                        ],
                      ),
                      Row(
                        children: [
                          Text( point.toString() + " Points", style: TextStyle(color: Colors.white),),
                          SizedBox(width: 5,),
                          Text("|", style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.w100),),
                          SizedBox(width: 10,),
                          Icon(Iconsax.arrow_right_1, color: Colors.white,),
                          SizedBox(width: 5,),
                        ],
                      )
                    ],
                  ),
                ),
              )
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Text("Riwayat Transaksi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          ),
          Expanded(
              child: FirebaseAnimatedList(
                  query: FirebaseDatabase.instance.ref().child("user").child(userId).child("riwayat"),
                  itemBuilder: (context, snapshot, animation, index){
                    Map riwayat = snapshot.value as Map;

                    riwayat['key'] = snapshot.key;

                    if(riwayat["key"] == null){
                      return Container(
                        alignment: Alignment.center,
                        child: Text("Belum melakukan transaksi"),
                      );
                    }

                    var nama = riwayat['nama_product'];
                    var harga = riwayat['harga'];
                    var images = riwayat['images'];
                    var point = riwayat['point'];
                    var date = riwayat['date'];

                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 3, color: Color.fromRGBO(217, 217, 217, 0.2) ))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(images),
                                    fit: BoxFit.cover
                                  )
                                ),
                              ),
                              SizedBox(width: 10,),
                              Container(
                                width: 100,
                                height: 60,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(nama, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),),
                                    Text("Dapat " + point.toString() + " point", style: TextStyle(color: Color(0xff7B7B7B)),)
                                  ],
                                ),
                              )
                            ],
                          ),
                          Container(
                            width: 120,
                            height: 60,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("- " + CurrencyFormat.convertToIdr(harga, 0), style: TextStyle(fontSize: 17, color: Color(0xff0D9488), fontWeight: FontWeight.w500),),
                                Text(date, style: TextStyle(color: Color(0xff7B7B7B)),)
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }
              )
          )
        ],
      ),
    );
  }
  
}