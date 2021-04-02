import 'package:flutter/material.dart';
import 'package:ses_backend/MainDrawer.dart';
import 'package:ses_backend/overview_page.dart';
import 'package:ses_backend/user_management_page.dart';

/*
 * Login page for administrators.
 */

class MainPage extends StatelessWidget {
  final String token;
  MainPage({Key key, this.token}) : super(key: key) {
    print(token);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPageStateful(),
    );
  }
}

class MainPageStateful extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPageStateful> {
  final _pages = [OverviewPage(), UserManagementPage()];
  var _pageIndex = 0;

  _callbackFunc(int index) {
    Navigator.of(context).pop();
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SES后台管理系统"),
      ),
      drawer: MainDrawer(
        callback: _callbackFunc,
      ),
      body: _pages[_pageIndex],
    );
  }
}
