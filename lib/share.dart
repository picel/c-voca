import 'package:flutter/material.dart';
import 'package:CVoca/style.dart';

class Share extends StatelessWidget {
  const Share({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
        Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: MaterialButton(
                        onPressed: () {},
                        child: Text("FILE"),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: MaterialButton(
                        onPressed: () {},
                        child: Text("QR CODE"),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: MaterialButton(
                        onPressed: () {},
                        child: Text("LINK"),
                      ),
                    ),
                  ],
                )
              ],
            ))
      ]),
    );
  }
}
