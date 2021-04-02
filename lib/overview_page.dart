import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ses_backend/ServerConfig.dart';

class OverviewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OverviewState();
}

class _OverviewState extends State<OverviewPage> {
  var _ramUsedPercent = 0.0;
  var _cpuUsedPercent = 0.0;
  var _serverArch = "Linux";
  var _adminUsername = "";
  var _adminUserUid = 0;

  @override
  void initState() {
    super.initState();
    _startGetUserInfo();
    _startGetServerInfo();
    Timer.periodic(Duration(milliseconds: 2000), (timer) {
      _startGetServerInfo();
    });
  }

  _startGetServerInfo() {
    final future = _getServerInfo();
    future.onError((error, stackTrace) {
      return error.toString();
    });
    future.then((value) {
      final data = json.decode(value);
      switch (data["result"]) {
        case "SUCCESS":
          if (mounted) {
            setState(() {
              _serverArch = data["arch"];
              _ramUsedPercent = data["ramUsed"];
              _cpuUsedPercent = data["cpuUsed"];
            });
          }

          break;
        default:
          break;
      }
    });
  }

  _startGetUserInfo() {
    final userFuture = _getUserInfo();
    userFuture.onError((error, stackTrace) {
      return error.toString();
    });
    userFuture.then((value) {
      final data = json.decode(value);
      switch (data["result"]) {
        case "SUCCESS":
          if (mounted) {
            _adminUserUid = data["uid"];
            _adminUsername = data["username"];
          }
          break;
      }
    });
  }

  Future<String> _getServerInfo() async {
    if (mounted) {
      final dio = Dio();
      final response = await dio.get("$serverBaseUrl/admin/serverinfo",
          queryParameters: {"token": token});
      return response.toString();
    }
    return null;
  }

  Future<String> _getUserInfo() async {
    if (mounted) {
      final dio = Dio();
      final response = await dio
          .get("$serverBaseUrl/admin/info", queryParameters: {"token": token});
      return response.toString();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: double.infinity),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: 800, maxWidth: 800),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Expanded(
                      child: Card(
                          shadowColor: Colors.white,
                          color: Colors.blue,
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "系统管理员",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 21),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: ClipOval(
                                      child: Image.asset(
                                        "images/azimiao.png",
                                        width: 80,
                                        height: 80,
                                      ),
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text(
                                    "用户名: $_adminUsername",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Text(
                                    "用户UID: $_adminUserUid",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ))),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 800),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Card(
                    color: Colors.blue,
                    shadowColor: Colors.white,
                    elevation: 15,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 800),
                            child: Stack(
                              children: [
                                Positioned(
                                    child: Text(
                                  "服务器概况",
                                  style: TextStyle(
                                      fontSize: 21, color: Colors.white),
                                )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              "服务器架构: $_serverArch",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              "RAM Used (%): ${(_ramUsedPercent * 100).toInt()}%",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: LinearProgressIndicator(
                                value: _ramUsedPercent,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.green)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              "CPU Used (%): ${(_cpuUsedPercent * 100).toInt()}%",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: LinearProgressIndicator(
                              value: _cpuUsedPercent,
                              valueColor: AlwaysStoppedAnimation(Colors.green),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
