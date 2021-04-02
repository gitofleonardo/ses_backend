import 'package:flutter/cupertino.dart';

class UserManagementPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserManageMentState();
}

class _UserManageMentState extends State<UserManagementPage> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: double.infinity),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
