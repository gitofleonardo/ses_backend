import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  final callback;
  MainDrawer({Key key, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ConstrainedBox(
      constraints: BoxConstraints(minWidth: double.infinity),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: DecoratedBox(
              decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [Colors.blue, Colors.blueAccent])),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: 120, maxHeight: 120),
                      child: ClipOval(
                        child: Image(image: AssetImage("images/azimiao.png")),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Administrator",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text("系统概览"),
                  onTap: () {
                    callback(0);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("用户管理"),
                  onTap: () {
                    callback(1);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person_remove),
                  title: Text("用户举报管理"),
                  onTap: () {
                    callback(2);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.comment),
                  title: Text("用户评论举报管理"),
                  onTap: () {
                    callback(3);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.comment_bank_sharp),
                  title: Text("交易评论举报管理"),
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text("商品举报管理"),
                  onTap: () {
                    callback(4);
                  },
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
