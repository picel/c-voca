import 'package:CVoca/qrScan.dart';
import 'package:flutter/material.dart';
import 'package:CVoca/style.dart';

class Share extends StatelessWidget {
  const Share({Key? key}) : super(key: key);

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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QRScanner(),
                ),
              );
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
                onPressed: () {},
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
