import 'package:flutter/material.dart';
import 'package:basket/screens/entryScreens/auth.dart';
import 'package:basket/screens/home_page/store.dart';
import 'package:basket/utils/size_config.dart';
import 'sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SignIn extends StatefulWidget{
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  SignIn({this.auth,this.onSignedIn});
  @override
  State<StatefulWidget> createState() => _SignIn();
}


class _SignIn extends State<SignIn>{

  BaseAuth auth;
  final formKey = new GlobalKey<FormState>();
  String _email,_password;
  var _isLoading = false;



  // to show message in error statu
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("SignInPage.DialogText"),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text("SignInPage.DialogButton"),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  bool validateAndSave(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }else {
      _showErrorDialog("SignInPage.DialogTextValidate");
      return false;
    }
  }

  void validateAndSubmit()async{
    setState(() {
      _isLoading = true;
    });

    if(validateAndSave()){
      try{
        FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password)).user;
        if(user.uid!=null){
          Navigator.of(context).pushReplacement(new MaterialPageRoute(
              builder: (context) =>Store()));
        }
        widget.onSignedIn;
      }
      catch (error) {
        String errorMessage;
        if(error.toString().contains('EMAIL_NOT_FOUND'))
        {
          errorMessage = 'Could not find a user with that email.';
        }
        errorMessage =
        "SignInPage.DialogEmailAndPasswordValidate";
        _showErrorDialog(errorMessage);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void validateOfempty(String str) {
    _showErrorDialog("DialogEmailError.SignInPage");
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

      return LayoutBuilder(builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          SizeConfig().init(constraints, orientation);
          return Scaffold(
            backgroundColor: Colors.white,
            body: Form(
              key: formKey,
              //color: Colors.white,
              child: ListView(
                children: <Widget>[
                  Card(
                      margin: EdgeInsets.all(0.0),
                      color: Color(0xff21d493),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0))),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(
                                    top: SizeConfig.getResponsiveHeight(20.0)),
                                child: Text(
                                  "SignInPage.title",
                                  style: TextStyle(
                                      fontSize:
                                      SizeConfig.getResponsiveHeight(25.0),
                                      color: Colors.white),
                                )),
                            Container(
                              width: SizeConfig.getResponsiveWidth(300.0),
                              height: SizeConfig.getResponsiveHeight(120.0),
                              child: Image.asset('assets/images/about_company.png'),
                            )
                          ],
                        ),
                      ),
                    ),

                   Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.getResponsiveHeight(15.0),
                          right: SizeConfig.getResponsiveWidth(25.0),
                          left: SizeConfig.getResponsiveWidth(25.0)),
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(30.0),
                        child: TextFormField (
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (value) => _email= value,
                          //controller: EmailController,
                          decoration: new InputDecoration(
                            //labelText: translations.text("loginPage.textFieldUserName"),
                            prefixIcon:Icon(Icons.person,color: Colors.green,),
                            labelText: "SignInPage.EmailHint",
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(30.0)),
                              borderSide: const BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(30.0)),
                              borderSide: BorderSide(color: Colors.green),
                            ),
                          ),
                        ),
                      ),
                    ),

                  Container(
                    margin: EdgeInsets.only(
                        top: SizeConfig.getResponsiveHeight(15.0),
                        right: SizeConfig.getResponsiveWidth(25.0),
                        left: SizeConfig.getResponsiveWidth(25.0)),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(30.0),
                      child: TextFormField (
                        keyboardType: TextInputType.emailAddress,
//                      validator: (value) {
//                        if (value.isEmpty || value.length < 5) {
//                          return 'Password is too short!';
//                        }
//                      },
                        onSaved: (value) => _password= value,
                        //controller: _textFieldController,
                        decoration: new InputDecoration(
                          //labelText: translations.text("loginPage.textFieldUserName"),
                          prefixIcon:Icon(Icons.lock,color: Colors.green,),
                          labelText: "SignInPage.passwordHint",
                          enabledBorder: const OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(30.0)),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                      ),
                    ),
                  ),

                  _isLoading?
                    Center(
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          strokeWidth: 3.0,
                          valueColor: AlwaysStoppedAnimation(Colors.green),
                        ),
                      ),
                    )
                  :
                     Container(
                        margin: EdgeInsets.only(
                            top: SizeConfig.getResponsiveHeight(20.0),
                            right: SizeConfig.getResponsiveWidth(50.0),
                            left: SizeConfig.getResponsiveWidth(50.0)),
                        child: RaisedButton(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0)),
                          onPressed: validateAndSubmit,
                          textColor: Colors.white,
                          color: Colors.white,
                          padding: EdgeInsets.all(0.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xff21d493),
                                borderRadius:
                                new BorderRadius.all(Radius.circular(40.0))),

                            alignment: Alignment.center,
//        height: _height / 20,
                            width: SizeConfig.getResponsiveWidth(90.0),
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "SignInPage.LogInButton",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.getResponsiveHeight(15.0),
                              ),
                            ),
                          ),
                        ),
                      ),

                  Container(
                      width: 200.0,
                      color: Colors.white70,
                      margin: EdgeInsets.only(
                          left: SizeConfig.getResponsiveWidth(35.0),
                          right: SizeConfig.getResponsiveWidth(35.0)),
                      child: new FlatButton(
                        padding: EdgeInsets.all(7.0),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0)),
                        color: Colors.white,
                        child: new FlatButton(
                          child:Text("SignInPage.ForgetPassword",
                            style: TextStyle(
                                fontSize: SizeConfig.getResponsiveHeight(10),
                                color: Color(0xff21d493)),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of ( context ).push (
                              new MaterialPageRoute(
                                  builder: (context) => Store() ) );
                        }
                      ),
                    ),

                 Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.getResponsiveHeight(10.0),
                          bottom: SizeConfig.getResponsiveHeight(10.0)),
                      alignment: Alignment.center,
                      child: Text("SignInPage.ORText",
                        style: TextStyle(
                            fontSize: SizeConfig.getResponsiveHeight(12.0),
                            color: Color(0xff21d493)),
                      ),
                    ),

                 Container(
                      width: 200.0,
                      margin: EdgeInsets.only(
                          top: SizeConfig.getResponsiveHeight(10.0),
                          left: 35.0,
                          right: 35.0),
                      child: new FlatButton(
                        padding: EdgeInsets.all(7.0),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0)),
                        color: Colors.white,
                        child: new Text("SignInPage.DonotHavaAccount",
                          style: TextStyle(
                              fontSize: SizeConfig.getResponsiveHeight(12),
                              color: Color(0xff21d493)),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => new SignUp(auth: widget.auth,
                                onSignedIn: widget.onSignedIn,)));
                        },
                      ),
                    ),

                ],
              ),
            ),
          );
        });
      });

  }
}

///- in version 2 login with google email and Facebook
//
//Widget socialIconsRow() {
//  return Container(
//    margin: EdgeInsets.only(top: SizeConfig.getResponsiveHeight(0)),
//    child: Row(
//      mainAxisAlignment: MainAxisAlignment.center,
//      mainAxisSize: MainAxisSize.min,
//      children: <Widget>[
//        CircleAvatar(
//          radius: 15,
//          backgroundImage: AssetImage("assets/images/googlelogo.png"),
//        ),
//        SizedBox(
//          width: 20,
//        ),
//        CircleAvatar(
//          radius: 15,
//          backgroundImage: AssetImage("assets/images/fblogo.jpg"),
//        ),
//        SizedBox(
//          width: 20,
//        ),
//        CircleAvatar(
//          radius: 15,
//          backgroundImage: AssetImage("assets/images/twitterlogo.jpg"),
//        ),
//      ],
//    ),
//  );
//}
