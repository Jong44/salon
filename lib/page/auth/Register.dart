import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:salon/main.dart';

import '../../Service/ServiceAuth.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => RegisterState();
}

class RegisterState extends State<Register> {

  final fAuth = FirebaseAuth.instance;

  var NamaController = TextEditingController();
  var EmailController = TextEditingController();
  var PasswordController = TextEditingController();

  bool isNama = false;
  bool isEmail = false;
  bool isPassword = false;
  bool isSubmit = false;
  bool hidden = true;
  bool isLoading = false;

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    if( isEmail && isPassword && isNama){
      isSubmit = true;
    } else {
      isSubmit = false;
    }
  }

  void errorAlert(BuildContext context, message){
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: EdgeInsets.symmetric(horizontal: 15),
      title: Center(child: Icon(Iconsax.warning_2, size: 50, color: Color(0xff0D9488),),),
      content: Container(child: Text(message, textAlign: TextAlign.center,),),
      actions: [
        ElevatedButton(
          onPressed: (){
            setState(() {
              Navigator.pop(context);
            });
          },
          child: Text("OKE", style: TextStyle(fontSize: 12),),
          style: ElevatedButton.styleFrom(
              primary: Color(0xff0D9488),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              fixedSize: Size(MediaQuery.of(context).size.width, 20)
          ),
        )
      ],
    );

    showDialog(context: context, builder: (context) => alert);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            children: [
              const SizedBox(height: 30,),
              Center(
                child: Image.asset("assets/Logo.png"),
              ),
              const SizedBox(height: 15,),
              const Text(
                "Nama",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(width: 1, color: const Color.fromRGBO(0, 0, 0, 0.3))
                ),
                child: TextField(
                  controller: NamaController,
                  onChanged: (String value) async {
                    setState(() {
                      if(value != ""){
                        isNama = true;
                      } else {
                        isNama = false;
                      }
                    });
                  },
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: "Username"
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              const Text(
                "Email",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(width: 1, color: const Color.fromRGBO(0, 0, 0, 0.3))
                ),
                child: TextField(
                  controller: EmailController,
                  onChanged: (String value) async {
                    setState(() {
                      if(value != ""){
                        isEmail = true;
                      } else {
                        isEmail = false;
                      }
                    });
                  },
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: "contoh@gmail.com"
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              const Text(
                "Password",
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(width: 1, color: const Color.fromRGBO(0, 0, 0, 0.3))
                ),
                child: TextField(
                  controller: PasswordController,
                  onChanged: (String value) async {
                    setState(() {
                      if(value != ""){
                        isPassword = true;
                      } else {
                        isPassword = false;
                      }
                    });
                  },
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black
                  ),
                  obscureText: hidden,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: "Password",
                      suffixIcon: IconButton(
                          alignment: Alignment.center,
                          iconSize: 20,
                          onPressed: (){
                            setState(() {
                              hidden = !hidden;
                            });
                          },
                          icon: hidden
                              ? const Icon(Iconsax.eye_slash, color: Colors.black,) : const Icon(Iconsax.eye, color: Colors.black,)
                      )
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if(isSubmit){
                      final message = await AuthService().registration(
                          email: EmailController.text,
                          password: PasswordController.text,
                          nama: NamaController.text
                      );
                      if(message!.contains('Success')){
                        await Future.delayed(Duration(seconds: 3));
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MainPage())
                        );
                      } else {
                        errorAlert(context, message);
                      }

                      setState(() {
                        isLoading = false;
                      });

                    }
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                      ),
                      primary: isSubmit
                          ? const Color(0xff0D9488)
                          : const Color(0xffEDEDED),
                      minimumSize: Size(0, 50)
                  ),
                  child: isLoading
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(color: Colors.white,)
                      ),
                      const SizedBox(width: 20,),
                      Text("Mohon Tunggu...", style: TextStyle(color: Colors.white),)
                    ],
                  )
                      : Text(
                    "Login",
                    style: TextStyle(
                      color: isSubmit
                          ? Colors.white
                          : Colors.grey,
                    ),
                  )
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 0.3,
                    width: 160,
                    decoration: const BoxDecoration(
                        color: Colors.grey
                    ),
                  ),
                  const Text(
                    "atau",
                    style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.3)
                    ),
                  ),
                  Container(
                    height: 0.3,
                    width: 159,
                    decoration: const BoxDecoration(
                        color: Colors.grey
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              InkWell(

                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: const Color.fromRGBO(0, 0, 0, 0.3)),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/google.png"),
                        const SizedBox(width: 10,),
                        const Text(
                          "Login dengan google",
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    )
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Sudah Punya Akun?",
                    style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.3)
                    ),
                  ),
                  TextButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: const Text("Login")
                  )
                ],
              )
            ],
          ),
        )
    );
  }

}