import 'package:CVoca/import/scanResult.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:CVoca/db.dart';
import 'package:CVoca/export/export.dart';
import 'package:CVoca/import/qrScan.dart';
import 'package:CVoca/model.dart';
import 'package:flutter/material.dart';
import 'package:CVoca/style.dart';

class Share extends StatefulWidget {
  const Share({Key? key}) : super(key: key);

  @override
  State<Share> createState() => _ShareState();
}

class _ShareState extends State<Share> {
  TextEditingController inputController = TextEditingController();

  Future getBookList() async {
    List<Book> tmpbooks = await BookManager.instance.getBooks();
    List idList = await BookManager.instance.getBookIds();
    return idList;
  }

  codeInput(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Type code'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextField(
                  controller: inputController,
                  decoration: InputDecoration(
                    labelText: 'code',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScanResult(
                      scanResult: "https://go.picel.net/file/" +
                          inputController.text +
                          ".json",
                    ),
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }

  void importOption(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Method'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                MaterialButton(
                  child: const Text('QR Scan'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QRScanner(),
                      ),
                    );
                  },
                ),
                MaterialButton(
                  child: const Text('From code'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    codeInput(context);
                  },
                ),
                MaterialButton(
                  child: const Text('Import from File'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Return'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void backUp(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure to back up all books?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Return'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Confirm'),
              onPressed: () async {
                var bookids = await getBookList();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Export(
                      bookId: bookids,
                    ),
                  ),
                ).then((_) {
                  Navigator.of(context).pop();
                });
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Share",
                  style: newTextStyle.titleText,
                ),
              ],
            ),
          ),
          MaterialButton(
            onPressed: () {},
            color: Colors.pinkAccent,
            height: MediaQuery.of(context).size.height * 0.35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.ios_share_rounded,
                      size: 50,
                    ),
                    Text(
                      "Export",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          MaterialButton(
            onPressed: () async {
              new Future.delayed(Duration.zero, () {
                importOption(context);
              });
            },
            color: Colors.greenAccent,
            height: MediaQuery.of(context).size.height * 0.35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.download_rounded,
                      size: 50,
                    ),
                    Text(
                      "Import",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                onPressed: () async {
                  new Future.delayed(Duration.zero, () {
                    backUp(context);
                  });
                },
                height: MediaQuery.of(context).size.height * 0.1,
                child: Text("Back Up"),
              ),
              MaterialButton(
                onPressed: () {},
                height: MediaQuery.of(context).size.height * 0.1,
                child: Text("Restore"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
