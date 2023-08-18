import 'package:flutter/material.dart';

class Accordion extends StatefulWidget {
  final String title;


  const Accordion({Key? key, required this.title})
      : super(key: key);
  @override
  _AccordionState createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  bool _showContent = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: _showContent
                  ? BorderSide(width: 1)
                  : BorderSide(width: 0, color: Colors.transparent)
            )
          ),
          child: ListTile(
            title: Text(widget.title),
            trailing: IconButton(
              icon: Icon(
                  _showContent ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              onPressed: () {
                setState(() {
                  _showContent = !_showContent;
                });
              },
            ),
          ),
        ),
        _showContent
            ? Container(
                padding: EdgeInsets.symmetric(),
                child: TextField(
                  style: TextStyle(
                    fontSize: 14
                  ),
                  maxLines: 7,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: "Ketik FeedBack Kamu",
                    filled: true,
                    fillColor: Color(0xffF5F5F5)
                  ),

                ),
        )
            : Container()
      ]),
    );
  }
}