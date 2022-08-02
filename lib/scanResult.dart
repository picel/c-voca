import 'dart:convert';

import 'package:CVoca/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:CVoca/style.dart';
import 'package:http/http.dart' as http;

class ScanResult extends StatefulWidget {
  final String scanResult;
  const ScanResult({Key? key, required this.scanResult}) : super(key: key);

  @override
  State<ScanResult> createState() => _ScanResultState();
}

class _ScanResultState extends State<ScanResult> {
  List bookTitles = [];
  List bookColors = [];
  List<List> cards = [];
  bool isValid = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    if (!widget.scanResult.startsWith('https://go.picel.net')) {
      setState(() {
        isValid = false;
        isLoading = false;
        return;
      });
    }
    http.Response response = await http.get(Uri.parse(widget.scanResult));
    String jsonData = utf8.decode(response.bodyBytes);
    var dataset = json.decode(jsonData);
    setState(() {
      for (var i = 0; i < dataset.length; i++) {
        bookTitles.add(dataset[i]['bookname']);
        bookColors.add(dataset[i]['bookcolor']);
        for (var j = 0; j < dataset[i]['count']; j++) {
          cards.add([
            i,
            dataset[i]['cards'][j]['word'],
            dataset[i]['cards'][j]['mean'],
            dataset[i]['cards'][j]['pronun'],
            dataset[i]['cards'][j]['explain'],
          ]);
        }
      }
      print(cards);
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isValid ? "Scan Complete" : "Scan Failed",
                    style: newTextStyle.titleText,
                  ),
                ],
              ),
            ),
            isLoading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : isValid
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: bookTitles.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.all(15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          bookTitles[index],
                                          style: newTextStyle.titleText,
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Color(
                                                int.parse(bookColors[index])),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          width: 50,
                                          height: 50,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                'Download ${bookTitles.length} books',
                                style:
                                    TextStyle(fontSize: 15, color: Colors.blue),
                              ),
                            )
                          ],
                        ),
                      )
                    : Container(
                        child: Center(
                          child: Column(
                            children: [
                              Text("Invalid QR Code",
                                  style: newTextStyle.subTitleText),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                              ),
                              Column(
                                children: [
                                  Text(
                                    "but we read this one",
                                    style: newTextStyle.subTitleText,
                                  ),
                                  Text(widget.scanResult),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
