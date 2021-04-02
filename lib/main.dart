import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:ses_backend/main_page.dart';
import 'ServerConfig.dart';

void main() {
  runApp(Login());
}

class Login extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SES后台管理系统',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(title: 'SES后台管理系统'),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  _routeToMainPage(String token) {
    // ignore: non_constant_identifier_names
    Navigator.of(context).pop();
    Navigator.push(context, MaterialPageRoute(builder: (buildContext) {
      return MainPage(
        token: token,
      );
    }));
  }

  _loginAdmin() {
    final username = _usernameController.text;
    final password = _passwordController.text;
    _showLoginDialog();
    final future = _loginMethod(username, password);
    future.onError((error, stackTrace) {
      Navigator.of(context).pop();
      _showErrorDialog("连接失败：发生了不可预知的网络错误。");
      return null;
    });
    future.then((value) {
      Navigator.of(context).pop();
      final items = json.decode(value);
      switch (items["result"]) {
        case "SUCCESS":
          token = items["token"];
          _routeToMainPage(value);
          break;
        case "USER_NOT_FOUND_ERROR":
          _showErrorDialog("用户不存在");
          break;
        case "PASSWORD_NOT_CORRECT":
          _showErrorDialog(
              "密码不正确，剩余${items["retryCount"]}次机会，超过三次输入错误您的帐号就会被锁定。");
          break;
        case "ACCOUNT_NOT_AVAILABLE":
          _showErrorDialog("帐号由于密码输入错误次数过多已被锁定，请找管理员解锁帐号。");
          break;
        default:
          _showErrorDialog("未知错误：${items["result"]}");
      }
    });
  }

  Future<String> _loginMethod(String username, String password) async {
    print(username + password);
    final dio = Dio();
    final formData =
        FormData.fromMap({"username": username, "password": password});
    final response =
        await dio.post("$serverBaseUrl/admin-login", data: formData);
    print(response);
    return response.toString();
  }

  _showLoginDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(20),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text("正在登录"),
                )
              ],
            ),
          );
        });
  }

  _showErrorDialog(String title) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(20),
            content: Text(title),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("确定"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(widget.title),
        ),
        backgroundColor: Colors.blue,
        body: ConstrainedBox(
          constraints: BoxConstraints.expand(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 500,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20.0),
                  child: Card(
                    elevation: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Form(
                            child: Column(
                              children: [
                                TextFormField(
                                  autofocus: true,
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                    labelText: "管理员帐号",
                                    hintText: "用户名",
                                    icon: Icon(Icons.person),
                                  ),
                                  maxLength: 20,
                                  validator: (value) {
                                    return value.trim().length > 0
                                        ? null
                                        : "用户名不能为空";
                                  },
                                ),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      labelText: "管理员密码",
                                      hintText: "密码",
                                      icon: Icon(Icons.lock)),
                                  maxLength: 20,
                                  validator: (value) {
                                    return value.trim().length > 5
                                        ? null
                                        : "密码不能少于6位";
                                  },
                                ),
                                Padding(
                                    padding: EdgeInsets.only(top: 20.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  print("Login pressed");
                                                  if ((_formKey.currentState
                                                          as FormState)
                                                      .validate()) {
                                                    _loginAdmin();
                                                  }
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.all(10.0),
                                                  child: Text("登录"),
                                                ))),
                                      ],
                                    ))
                              ],
                            ),
                            autovalidateMode: AutovalidateMode.always,
                            key: _formKey,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
