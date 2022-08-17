import 'package:flutter/material.dart';
import 'package:CVoca/db.dart';
import 'package:CVoca/Model/WordcardDBModel.dart';
import 'package:CVoca/style.dart';

class WordModify extends StatefulWidget {
  final int cardId;
  const WordModify({Key? key, required this.cardId}) : super(key: key);

  @override
  State<WordModify> createState() => _WordModifyState();
}

class _WordModifyState extends State<WordModify> {
  String word = '';
  String mean = '';
  String? pronun = '';
  String? explain = '';
  int bookId = 0;
  TextEditingController wordController = TextEditingController();
  TextEditingController meanController = TextEditingController();
  TextEditingController pronunController = TextEditingController();
  TextEditingController explainController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getWord(widget.cardId);
  }

  Future modifyWord() async {
    await CardManager.instance.update(
      WordCard(
        id: widget.cardId,
        word: word,
        mean: mean,
        pronun: pronun,
        explain: explain,
        bookid: bookId,
      ),
    );
  }

  Future getWord(int id) async {
    WordCard card = await CardManager.instance.getCard(id);
    setState(() {
      wordController.text = card.word;
      meanController.text = card.mean;
      pronunController.text = card.pronun!;
      explainController.text = card.explain!;
      bookId = card.bookid;
    });
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
                      "Edit Word",
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
                            setState(() {
                              word = wordController.text;
                              mean = meanController.text;
                              pronun = pronunController.text;
                              explain = explainController.text;
                            });
                            await modifyWord();
                            Navigator.pop(context);
                          })
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
