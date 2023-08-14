import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:go_router/go_router.dart';
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
  final FlutterAppAuth appAuth = FlutterAppAuth();
  final Auth0_Domain = 'dev-36g1gfwhwyynsncw.us.auth0.com';
  final Auth0_Client_ID = 'Xe0Jzli4IBCAq45ptFfzCnhmYho4vtT5';
  final Auth0_Issuer = 'https://dev-36g1gfwhwyynsncw.us.auth0.com';
  final Bundle_ID = 'com.example.auth0_authenication_project';
  final Auth0_Redirect_URI =
      'https://dev-36g1gfwhwyynsncw.us.auth0.com/flutter/com.example.auth0_authenication_project/callback';
  final Referesh_Token_Key='refresh_token';

  // / final Auth0_Issuer='https://$Auth0_Domain';
  @override
  void initState() {
    super.initState();
    auth0 = Auth0(Auth0_Domain, Auth0_Client_ID);
  }
  bool isLogin=false;

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (context, state) =>  MyHomePage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) =>  ProfileView(),
      ),
    ],
  );

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
            if (isLogin==false)
              ElevatedButton(
                  onPressed: () async {
                    print("inLogin Button");
                    final authorizationTokenResponse =
                        await AuthorizationTokenRequest(
                            Auth0_Client_ID, Auth0_Redirect_URI,
                            issuer: Auth0_Issuer,
                            scopes: [
                          'openid',
                          'profile',
                          'email',
                          'offline_access'
                        ]);
                    print(authorizationTokenResponse);
                    // AuthorizationRequest(
                    // try{
                      final result = await appAuth.authorizeAndExchangeCode(authorizationTokenResponse);
                      print("result");
                      print(result);
                      // print(result?.accessToken);
                      // print(result?.idToken);
                      // if(authorizationTokenResponse!=null)
                      //   setState(() {
                      //     isLogin=true;
                      //   });
                    // }
                    // on PlatformException{
                    //   print("authorize_and_exchange_code_failed");
                    // }
                    // catch(Exception e){
                    //   print(e);
                    // }

                    // final AuthorizationTokenResponse =await appAuth.authorizeAndExchangeCode();
                    // final credentials = await auth0.webAuthentication().login();
                    // setState(() {
                    //   _credentials = credentials;
                    //
                    // });
                    // print(credentials.user);
                  },
                  child: const Text("Log in"))
            else
              Column(
                children: [
                  ProfileView(),
                  ElevatedButton(
                      onPressed: () async {
                        await auth0.webAuthentication().logout();
                        setState(() {
                          isLogin=false;
                          // _credentials = null;
                        });
                      },
                      child: const Text("Log out"))
                ],
              )
          ]),
    );
  }
}
