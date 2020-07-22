import 'package:flutter/material.dart';
import 'package:basket/screens/entryScreens/auth.dart';
import 'package:basket/screens/entryScreens/sign_in.dart';
import 'package:basket/screens/entryScreens/sign_up.dart';
import '../../utils/size_config.dart';

class Welcome extends StatefulWidget{
  final BaseAuth auth;
  Welcome({this.auth,this.onSignedIn});
  final VoidCallback onSignedIn;
  @override
  State<StatefulWidget> createState() => _Welcome();
}


class _Welcome extends State<Welcome> with SingleTickerProviderStateMixin{

  Animation animation , delayedAnimation,delayedAnimationTwo, muchDelayedAnimation,muchDelayedAnimationTwo;
  AnimationController animationController;

  //////////////////////////////////////////////////////////////////
  //// for Animation
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: Duration(seconds: 3),vsync: this);
    animation = Tween(begin: -1.0,end: 0.0).animate(CurvedAnimation(
        curve: Curves.fastOutSlowIn,
        parent: animationController
    ));
    delayedAnimation = Tween(begin: -1.0,end: 0.0).animate(CurvedAnimation(
        curve: Interval(0.1,1.0,curve: Curves.fastOutSlowIn),
        parent: animationController
    ));
    delayedAnimationTwo = Tween(begin: -1.0,end: 0.0).animate(CurvedAnimation(
        curve: Interval(0.3,1.0,curve: Curves.fastOutSlowIn),
        parent: animationController
    ));
    muchDelayedAnimation = Tween(begin: -1.0,end: 0.0).animate(CurvedAnimation(
        curve: Interval(0.5,1.0,curve: Curves.fastOutSlowIn),
        parent: animationController
    ));
    muchDelayedAnimationTwo = Tween(begin: -1.0,end: 0.0).animate(CurvedAnimation(
        curve: Interval(0.6,1.0,curve: Curves.fastOutSlowIn),
        parent: animationController
    ));


  }
  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width;
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context,Widget child){
          return LayoutBuilder(builder: (context, constraints) {
            return OrientationBuilder(
              builder: (context, orientation) {
                SizeConfig().init(constraints, orientation);
                return new Scaffold(
                    backgroundColor: Color(0xff21d493),
                    body: SingleChildScrollView(
                      child: new SafeArea(
                          child: new Stack(
                            children: <Widget>[
                              Transform(
                                  transform: Matrix4.translationValues(delayedAnimation.value*width, 0.0, 0.0),
                                  child:Container(
                                    margin: EdgeInsets.only(
                                        left: SizeConfig.getResponsiveWidth(20),
                                        right: SizeConfig.getResponsiveWidth(20),
                                        top: SizeConfig.getResponsiveWidth(12),
                                        bottom: SizeConfig.getResponsiveWidth(12)),
                                    alignment: Alignment.center,

                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        elevation: 10.0,
                                        child: Container(
                                            height: SizeConfig.getResponsiveHeight(480),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  Transform(
                                                    transform: Matrix4.translationValues(delayedAnimation.value*width, 0.0, 0.0),
                                                    child:Align(
                                                      alignment: Alignment.topCenter,
                                                      child: new Container(
                                                        margin: EdgeInsets.only(
                                                          top: SizeConfig.getResponsiveHeight(
                                                              50.0),
                                                          bottom:
                                                          SizeConfig.getResponsiveHeight(
                                                              20),
                                                        ),
                                                        child: Text(
                                                          "WelcomePage.title",
                                                          style: TextStyle(
                                                              fontSize: SizeConfig
                                                                  .getResponsiveWidth(25),
                                                              color: Color.fromRGBO(
                                                                  87, 86, 86, 1),
                                                              fontStyle: FontStyle.normal),
                                                        ),
                                                      ),
                                                    ),),
                                                  Transform(
                                                    transform: Matrix4.translationValues(delayedAnimationTwo.value*width, 0.0, 0.0),
                                                    child:Container(
                                                        margin: EdgeInsets.only(
                                                            bottom:
                                                            SizeConfig.getResponsiveWidth(
                                                                30)),
                                                        height:
                                                        SizeConfig.getResponsiveHeight(
                                                            150),
                                                        width: SizeConfig.getResponsiveWidth(
                                                            200),
                                                        child: Image.asset(
                                                            "assets/images/background.png")),),
                                                  Column(
                                                    children: <Widget>[
                                                      Transform(
                                                        transform: Matrix4.translationValues(muchDelayedAnimation.value*width, 0.0, 0.0),
                                                        child:Container(
                                                          width:
                                                          SizeConfig.getResponsiveWidth(
                                                              250),
                                                          child: new FlatButton(
                                                            padding: EdgeInsets.all(7.0),
                                                            shape: new RoundedRectangleBorder(
                                                                borderRadius:
                                                                new BorderRadius.circular(
                                                                    5.0)),
                                                            color: Color(0XFF21d493),
                                                            child: new Text(
                                                              "WelcomePage.SignUpButton",
                                                              style: TextStyle(
                                                                  fontSize: 2.5 *
                                                                      SizeConfig
                                                                          .textMultiplier,
                                                                  color: Colors.white),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(context).push(
                                                                  new MaterialPageRoute(
                                                                      builder: (context) =>
                                                                      new SignUp(auth: widget.auth,onSignedIn: widget.onSignedIn,)));
                                                            },
                                                          ),
                                                        ),),
                                                      Transform(
                                                        transform: Matrix4.translationValues(muchDelayedAnimationTwo.value*width, 0.0, 0.0),
                                                        child: Container(
                                                          width:
                                                          SizeConfig.getResponsiveWidth(250),
                                                          margin: EdgeInsets.only(
                                                              top: SizeConfig
                                                                  .getResponsiveHeight(10)),
                                                          child: new FlatButton(
                                                            padding: EdgeInsets.all(7.0),
                                                            shape: new RoundedRectangleBorder(
                                                                borderRadius:
                                                                new BorderRadius.circular(
                                                                    5.0)),
                                                            color: Color(0XFF21d493),
                                                            child: new Text(
                                                                "WelcomePage.SignInButton",
                                                              style: TextStyle(
                                                                  fontSize: 2.5 *
                                                                      SizeConfig
                                                                          .textMultiplier,
                                                                  color: Colors.white),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(context).push(
                                                                  new MaterialPageRoute(
                                                                      builder: (Context) =>
                                                                      new SignIn(auth: widget.auth,onSignedIn: widget.onSignedIn,)));
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ]))),
                                  )),
                            ],
                          )),
                    ));
              },
            );
          });}
    );
  }
}
