import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:io';
import 'package:path/path.dart';

import 'package:image_picker/image_picker.dart';

class DetailProfile extends StatefulWidget {
  const DetailProfile({Key? key}) : super(key: key);

  @override
  State<DetailProfile> createState() => DetailProfileState();
}

class DetailProfileState extends State<DetailProfile> {

  File? image;
  var NamaController = TextEditingController();
  var EmailController = TextEditingController();
  var NomorController = TextEditingController();
  var AlamatController = TextEditingController();
  var PasswordController = TextEditingController();
  
  bool hidden = true;
  bool activeNama = false;
  bool activeEmail = false;
  bool activeAlamat = false;
  bool activeNomor = false;
  bool activePassword = false;

  final fStorage = FirebaseStorage.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  Future openCamera() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      image = File(pickedImage!.path);
    });
    uploadFotoProfile();
  }

  Future openGaleri() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      image = File(pickedImage!.path);
    });
    uploadFotoProfile();
  }

  Future uploadFotoProfile() async {
    String fileName = basename(image!.path);
    await fStorage.ref().child('profile/$fileName').putFile(image!);
    var url = await fStorage.ref().child('profile/$fileName').getDownloadURL();
    FirebaseDatabase.instance.ref().child("user").child(userId).child('profile').child('images').set(url.toString());
    setState(() {
      url_image = url;
    });
  }

  String? url_image;
  bool isLoading = false;


  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    var fDatabaseProfile = FirebaseDatabase.instance.ref().child("user").child(userId).child("profile");

    var nama = await fDatabaseProfile.child("nama").once();
    var email = await fDatabaseProfile.child("email").once();
    var no_hp = await fDatabaseProfile.child("no_hp").once();
    var alamat = await fDatabaseProfile.child("alamat").once();
    var password = await fDatabaseProfile.child("password").once();
    var images = await fDatabaseProfile.child("images").once();

    setState(() {
      NamaController.text = nama.snapshot.value.toString();
      EmailController.text = email.snapshot.value.toString();
      NomorController.text = no_hp.snapshot.value.toString();
      AlamatController.text = alamat.snapshot.value.toString();
      PasswordController.text = password.snapshot.value.toString();
      url_image = images.snapshot.value.toString();
    });

    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveData() async {
    var fDatabaseProfile = FirebaseDatabase.instance.ref().child("user").child(userId).child("profile");
    fDatabaseProfile.set({
      "nama" : NamaController.text,
      "email" : EmailController.text,
      "no_hp" : NomorController.text,
      "alamat" : AlamatController.text,
      "Password" : PasswordController.text
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
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("Edit Profile", style: TextStyle(color: Colors.black, fontSize: 15),),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(
            Iconsax.arrow_left,
            color: Colors.black,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(),)
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(url_image ?? "https://firebasestorage.googleapis.com/v0/b/salon-850cf.appspot.com/o/profile%2F6525a08f1df98a2e3a545fe2ace4be47.jpg?alt=media&token=e1276817-2fdf-41d7-9aec-6b8c2d73db4b"),
                              fit: BoxFit.cover
                            ),
                            shape: BoxShape.circle
                        ),
                      ),
                      SizedBox(width: 15,),
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: (){
                          showModalBottomSheet(
                              context: context,
                              builder: ((builder) => Container(
                                height: 150,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Color(0xedededed),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Foto Profil", style: TextStyle(fontSize: 20),),
                                    SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                            onPressed: (){
                                              openCamera();
                                              Navigator.pop(context);
                                            },
                                            child: Icon(Iconsax.camera, color: Colors.black,),
                                            style: ElevatedButton.styleFrom(
                                                shape: CircleBorder(side: BorderSide(color: Colors.black)),
                                                fixedSize: Size(60, 60),
                                                primary: Colors.transparent,
                                                elevation: 0
                                            )
                                        ),
                                        SizedBox(width: 20,),
                                        ElevatedButton(
                                            onPressed: (){
                                              openGaleri();
                                              Navigator.pop(context);
                                            },
                                            child: Icon(Iconsax.gallery, color: Colors.black,),
                                            style: ElevatedButton.styleFrom(
                                                shape: CircleBorder(side: BorderSide(color: Colors.black)),
                                                fixedSize: Size(60, 60),
                                                primary: Colors.transparent,
                                                elevation: 0
                                            )
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                              )
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 5),
                          child: Text("Ganti foto Profile", style: TextStyle(fontSize: 13),),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Color.fromRGBO(98, 97, 97, 0.3)),
                              borderRadius: BorderRadius.circular(50)
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15,),
                  Text("Nama", style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 15,),
                  InkWell(
                    onTap: (){
                      setState(() {
                        activeNama = !activeNama;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: activeNama
                                  ? Color.fromRGBO(98, 97, 97, 0.3)
                                  : Colors.black
                          ),
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: TextField(
                        controller: NamaController,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: "Nama",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text("Email", style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 15,),
                  InkWell(
                    onTap: (){
                      setState(() {
                        activeEmail = !activeEmail;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: activeEmail
                                  ? Color.fromRGBO(98, 97, 97, 0.3)
                                  : Colors.black
                          ),
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: TextField(
                        controller: EmailController,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: "Email",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text("Nomor HP", style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 15,),
                  InkWell(
                    onTap: (){
                      setState(() {
                        activeNomor = !activeNomor;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: activeNomor
                                  ? Color.fromRGBO(98, 97, 97, 0.3)
                                  : Colors.black
                          ),
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: TextField(
                        controller: NomorController,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: "Nomor HP",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text("Alamat", style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 15,),
                  InkWell(
                    onTap: (){
                      setState(() {
                        activeAlamat = !activeAlamat;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1,
                              color: activeAlamat
                                  ? Color.fromRGBO(98, 97, 97, 0.3)
                                  : Colors.black
                          ),
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: TextField(
                        controller: AlamatController,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: "Alamat",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text("Password", style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 15,),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child: TextField(
                      controller: PasswordController,
                      obscureText: hidden,
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: "********",
                          suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                hidden = !hidden;
                              });
                            },
                            icon: Icon(
                              hidden
                                  ? Iconsax.eye_slash
                                  : Iconsax.eye,
                              color: Colors.black,
                            ),
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          minimumSize: Size(0, 40),
                          primary: Color(0xff0D9488),
                          elevation: 0
                      ),
                      onPressed: (){
                        saveData();
                      },
                      child: Text("Simpan", style: TextStyle(color: Colors.white),)
                  )
                ],
              ),
      )
    );
  }

}