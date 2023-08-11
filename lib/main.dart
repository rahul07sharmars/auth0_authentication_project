import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';

import 'profile_view.dart';

//
void main() {
  runApp(const MainView());
}

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  Credentials? _credentials;

  late Auth0 auth0;



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Credentials? _credentials;

  late Auth0 auth0;
  final Auth0_Domain='dev-36g1gfwhwyynsncw.us.auth0.com';
  final Auth0_Client_ID='LIgkZBqQJKXO3uFNqbgss8NOtHnK8m5C';
  // final Auth0_Issuer='https://$Auth0_Domain';
  @override
  void initState() {
    super.initState();
    auth0 = Auth0(Auth0_Domain, Auth0_Client_ID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Auth0"),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_credentials == null)
              ElevatedButton(
                  onPressed: () async {
                    final credentials = await auth0.webAuthentication().login();
                    setState(() {
                      _credentials = credentials;
                    });
                  },
                  child: const Text("Log in"))
            else
              Column(
                children: [
                  ProfileView(user: _credentials!.user),
                  ElevatedButton(
                      onPressed: () async {
                        await auth0.webAuthentication().logout();
                        setState(() {
                          _credentials = null;
                        });
                      },
                      child: const Text("Log out"))
                ],
              )
          ]),
    );
  }
}