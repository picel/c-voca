import 'package:CVoca/db.dart';
import 'package:CVoca/style.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Export extends StatefulWidget {
  final List bookId;
  const Export({Key? key, required this.bookId}) : super(key: key);

  @override
  State<Export> createState() => _ExportState();
}

class _ExportState extends State<Export> {
  var isLoading;
  String code = '';

  @override
  void initState() {
    super.initState();
    isLoading = true;
    fileUpload();
  }

  Future fileUpload() async {
    var url = Uri.parse('https://go.picel.net/upload/json/');

    var data = await BookManager.instance.getBooksJson(widget.bookId);

    //send data as text
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: data,
    );
    var code = response.body;
    setState(() {
      this.code = code;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    "Share",
                    style: newTextStyle.titleText,
                  ),
                ],
              ),
            ),
            isLoading
                ? CircularProgressIndicator()
                : Container(
                    margin: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "QR Code",
                          style: newTextStyle.titleText,
                        ),
                        Image.network(
                            'https://chart.googleapis.com/chart?cht=qr&chs=256x256&chl=https://go.picel.net/file/' +
                                code +
                                '.json'),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Code", style: newTextStyle.titleText),
                        Text(
                          code,
                          style: newTextStyle.subTitleText,
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
