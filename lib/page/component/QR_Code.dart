import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QR_Code extends StatefulWidget {
  final userId;
  final images;
  final points;
  final harga;
  final date;
  final namaProduct;


  const QR_Code({Key? key, required this.userId, required this.namaProduct, required this.images, required this.points, required this.harga, required this.date}) : super(key: key);
  @override
  State<QR_Code> createState() =>_QRState(userId, images, points, harga, date, namaProduct);
}

class _QRState extends State<QR_Code> {
  final userId;
  final namaProduct;
  final images;
  final points;
  final harga;
  final date;

  _QRState(this.userId, this.date, this.harga, this.points, this.images, this.namaProduct);

  @override
  Widget build(BuildContext context) {

    String data = "$userId|$namaProduct|$images|$points|$points|$harga|$date";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Text("Code QR", style: TextStyle(color: Colors.black),),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Iconsax.arrow_left, color: Colors.black,),
        ),
        toolbarHeight: 80,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 150),
        child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(35),
            width: 300,
            height: 300,
            decoration: BoxDecoration(
                color: Color(0xff0D9488),
                borderRadius: BorderRadius.circular(30)
            ),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30)
              ),
              child: QrImage(
                data: data,
                version: QrVersions.auto,
                size: 200.0,
              ),
            )
        ),
      )
    );
  }
}