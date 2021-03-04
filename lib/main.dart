import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/io_client.dart' as http;
import 'package:openid_client/openid_client.dart';
import 'package:openid_client/openid_client_io.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: OutlinedButton(
          onPressed: () async {
            authenticate();
          },
          child: Text("login"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    Parse().initialize("myappID", "http://192.168.178.65:1337/parse");

    // Parse()
    //     .initialize("myappID", "http://192.168.178.65:1337/parse")
    //     .then((parse) async {
    //   print((await parse.healthCheck()).success);
    //   ParseUser.loginWith("ldap", {"id": "test", "password": "test"},
    //           username: "test")
    //       .then((response) {
    //     if (response.success) {
    //       print((response.result as ParseUser).username);
    //       (response.result as ParseUser).save();
    //     } else {
    //       print(response.error);
    //     }
    //   });
    // });
  }

  authenticate() async {
    // keyclock url : key-clock-url : example : http://localhost:8080
    // my realm : name of your real.m
    var uri = Uri.parse('https://192.168.178.65:8443/auth/realms/master');
    var clientId = 'flutter';
    var scopes = List<String>.of(['openid', 'profile']);
    var port = 4200;
    var redirectUri = Uri.parse('http://localhost:4200/');

    http.IOClient httpClient = http.IOClient(HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true));

    var issuer = await Issuer.discover(uri, httpClient: httpClient);

    print(issuer.metadata);

    var client = new Client(issuer, clientId, httpClient: httpClient);

    urlLauncher(String url) async {
      print(url);
      if (await canLaunch(url)) {
        await launch(url, forceWebView: true);
      } else {
        throw 'Could not launch $url';
      }
    }

    var authenticator = new Authenticator(
      client,
      scopes: scopes,
      port: port,
      urlLancher: urlLauncher,
      // redirectUri: redirectUri
    );
    // authenticator.authorize();
    //
    // var c = await authenticator.credential;
    //
    // authenticator.credential.then((value) => print(value.idToken));
    //
    // print((await c.getUserInfo()).name);

    var c = await authenticator.authorize();
    closeWebView();

    var token = await c.getTokenResponse();
    //
    UserInfo userInfo = await c.getUserInfo();
    print("AccessToken: " + token.accessToken);
    print("id: " + userInfo.subject);

    ParseUser.loginWith(
            "keycloak",
            {
              "access_token": (await c.getTokenResponse()).accessToken,
              "id": userInfo.subject,
              // "roles": [],
              // "groups": userInfo.getTypedList("groups")
            },
            username: userInfo.preferredUsername,
            email: userInfo.email)
        .then((response) async {
      if (response.success) {
        print((response.result as ParseUser).username);
        print((response.result as ParseUser).emailAddress);

        ((response.result as ParseUser).copy()
              ..username = userInfo.preferredUsername
              ..emailAddress = userInfo.email)
            .save();
        // Future.delayed(
        //     Duration(seconds: 4), () => (response.result as ParseUser).save());
      } else {
        print(response.error);
      }
    });
  }
}
