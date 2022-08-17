//get word, mean, pronun, explain from user input and add to database
import 'package:flutter/material.dart';
import 'package:CVoca/db.dart';
import 'package:CVoca/Model/WordcardDBModel.dart';
import 'package:CVoca/style.dart';

class WordAdd extends StatefulWidget {
  final int bookId;
  const WordAdd({Key? key, required this.bookId}) : super(key: key);

  @override
  State<WordAdd> createState() => _WordAddState();
}

class _WordAddState extends State<WordAdd> {
  String word = '';
  String mean = '';
  String pronun = '';
  String explain = '';
  TextEditingController wordController = TextEditingController();
  TextEditingController meanController = TextEditingController();
  TextEditingController pronunController = TextEditingController();
  TextEditingController explainController = TextEditingController();

  Future addWord() async {
    //get highest id in database
    int id = await CardManager.instance.getHighestId();
    await CardManager.instance.add(
      WordCard(
        id: id + 1,
        bookid: widget.bookId,
        word: word,
        mean: mean,
        pronun: pronun,
        explain: explain,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    "Add Word",
                    style: newTextStyle.subTitleText,
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextField(
                      controller: wordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Word",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: meanController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Meaning",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: pronunController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Pronunciation (optional)",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: explainController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Explaination (optional)",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        child: const Text('Confirm'),
                        onPressed: () async {
                          if (wordController.text.isEmpty ||
                              meanController.text.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text('Please fill in all fields'),
                                  actions: <Widget>[
                                    MaterialButton(
                                      child: Text('Close'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            setState(() {
                              word = wordController.text;
                              mean = meanController.text;
                              pronun = pronunController.text;
                              if (pronun == '') {
                                pronun = '-';
                              }
                              explain = explainController.text;
                            });
                            await addWord();
                            wordController.clear();
                            meanController.clear();
                            pronunController.clear();
                            explainController.clear();
                          }
                        })
                  ],
                )),
          ],
        ),
      ),
    ));
  }
}
