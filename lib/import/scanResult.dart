import 'dart:convert';

import 'package:CVoca/db.dart';
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
  List cardCount = [];
  List<List> cards = [];
  List<bool> isChecked = [];
  bool isValid = true;
  bool isLoading = true;
  bool isCode = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Color textColorDecision(Color color) {
    if (color.computeLuminance() > 0.5) {
      return Colors.black;
    } else {
      return Colors.white;
    }
  }

  Future saveBook(int index) async {
    var id = await BookManager.instance.getHighestId() + 1;
    await BookManager.instance.add(
      Book(
        id: id,
        bookname: bookTitles[index],
        bookcolor: bookColors[index],
      ),
    );
    print(id);
    print(bookTitles[index]);
    print(bookColors[index]);
    for (int i = 0; i < cards.length; i++) {
      if (cards[i][0] == index) {
        var newId = await CardManager.instance.getHighestId() + 1;
        await CardManager.instance.add(
          WordCard(
            bookid: id,
            id: newId,
            word: cards[i][1],
            mean: cards[i][2],
            pronun: cards[i][3],
            explain: cards[i][4],
          ),
        );
        print("$id $newId");
      }
    }
  }

  Future saveCards(int index, bookId) async {
    for (int i = 0; i < cards.length; i++) {
      if (cards[i][0] == index) {
        print(cards[i]);
        var newId = await CardManager.instance.getHighestId() + 1;
        await CardManager.instance.add(
          WordCard(
            bookid: bookId,
            id: newId,
            word: cards[i][1],
            mean: cards[i][2],
            pronun: cards[i][3],
            explain: cards[i][4],
          ),
        );
      }
    }
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
    // if response is not 200 OK, throw an exception
    if (response.statusCode != 200) {
      setState(() {
        isValid = false;
        isLoading = false;
        isCode = true;
      });
      return;
    }
    String jsonData = utf8.decode(response.bodyBytes);
    var dataset = json.decode(jsonData);
    setState(() {
      for (var i = 0; i < dataset.length; i++) {
        bookTitles.add(dataset[i]['bookname']);
        bookColors.add(dataset[i]['bookcolor']);
        for (var j = 0; j < dataset[i]['cards'].length; j++) {
          cards.add([
            i,
            dataset[i]['cards'][j]['word'],
            dataset[i]['cards'][j]['mean'],
            dataset[i]['cards'][j]['pronun'],
            dataset[i]['cards'][j]['explain'],
          ]);
        }
        cardCount.add(dataset[i]['cards'].length);
      }
      isChecked = List.generate(bookTitles.length, (index) => false);
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
                ? const Center(
                    child: CircularProgressIndicator(),
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
                                        Checkbox(
                                            value: isChecked[index],
                                            onChanged: (value) {
                                              setState(() {
                                                isChecked[index] = value!;
                                              });
                                            }),
                                        Text(
                                          bookTitles[index],
                                          style: newTextStyle.subTitleText,
                                        ),
                                        Container(
                                          child: Center(
                                            child: Text(
                                              "${cardCount[index]}",
                                              style: TextStyle(
                                                color: textColorDecision(Color(
                                                    int.parse(
                                                        bookColors[index]))),
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                              ),
                                            ),
                                          ),
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
                              onPressed: () async {
                                for (int i = 0; i < isChecked.length; i++) {
                                  if (isChecked[i]) {
                                    await saveBook(i);
                                  }
                                }
                                Navigator.pop(context);
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                'Download selected books',
                                style:
                                    TextStyle(fontSize: 15, color: Colors.blue),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                          ],
                        ),
                      )
                    : isCode
                        ? Center(
                            child: Column(
                              children: [
                                Text("File not exists",
                                    style: newTextStyle.subTitleText),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                ),
                                Text(
                                  "code is not correct or link had expired",
                                  style: newTextStyle.subTitleText,
                                ),
                              ],
                            ),
                          )
                        : Center(
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
          ],
        ),
      ),
    );
  }
}
