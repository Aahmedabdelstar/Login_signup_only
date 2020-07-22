import 'package:basket/screens/home_page/store.dart';
import 'package:flutter/material.dart';
import '../../screens/entryScreens/auth.dart';
import '../../screens/entryScreens/welcome.dart';

class RootPage extends StatefulWidget{
  final BaseAuth auth;
  RootPage({this.auth});
  @override
  State<StatefulWidget> createState() => _RootPage();
}
enum AuthStatus {
  notSignedIn,
  signedIn
}


class _RootPage extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((userId){
      setState((){
        authStatus=userId==null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn(){
    setState(() {
      authStatus= AuthStatus.signedIn;
    });
  }

  void _signedOut(){
    setState(() {
      authStatus= AuthStatus.notSignedIn;
    });
  }


  @override
  Widget build(BuildContext context) {
    switch(authStatus){
      case AuthStatus.notSignedIn:
        return new Welcome(auth: widget.auth,onSignedIn: _signedIn,);
    //return HomePage(auth: widget.auth,onSignedOut: _signedOut,screen: Store(),);
      case AuthStatus.signedIn:
        return Store();
    }
  }

}