import 'dart:io';
import 'package:flutter/material.dart';
import 'package:basket/Animation/FadeAnimation.dart';
import 'package:basket/screens/entryScreens/auth.dart';
import 'package:basket/screens/entryScreens/sign_in.dart';
import 'package:basket/screens/entryScreens/widgets/UtilityImage.dart';
import 'package:basket/screens/entryScreens/widgets/custom_shape.dart';
import 'package:basket/utils/size_config.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_country_picker/country.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import './phone_confirmation.dart';
import 'package:flutter_toolbox/flutter_toolbox.dart';


class SignUp extends StatefulWidget{
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  SignUp({this.auth,this.onSignedIn});
  @override
  State<StatefulWidget> createState() => _SignUp();
}

class _SignUp extends State<SignUp> {

  /// - For Profile image
  Future<File> imageFile;
  Image imageFromSharedPreferences = Image.asset("assets/images/profile_side_menu.png");
  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }
  Widget imageFromGallery(){
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          //print(snapshot.data.path);
          Utility.saveImageToPreferences(
              Utility.base64String(snapshot.data.readAsBytesSync()));
          return Image.file(
            snapshot.data,
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return  Container(
            padding: EdgeInsets.all(5),
                 decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                      border: Border.all(width: 2, color: Colors.white)),
                    child: Icon(
                      Icons.add_a_photo,
                      //size: SizeConfig.getResponsiveHeight(20),
                      color: Color(0xff21d493),
                    ),


          );
        }
      },
    );}


  final formKey = new GlobalKey<FormState>();
  String username,email,password,confirmPassword,phone;
  var _isLoading = false;
  String userId;
  Country _countryCode = Country.SA;

  FirebaseDatabase _database = FirebaseDatabase.instance;


  bool validateAndSave(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }else {
      return false;
    }
  }

  void validateAndSubmit()async{
    setState(() {
      _isLoading = true;
    });

    if(validateAndSave()) {

      push(
          context,
          PhoneAuthSimple(
            countryCode: _countryCode,
            phoneNumber: phone,
            name: username,
            email: email,
            password: password,
            confirm: confirmPassword,
          ));



    }
    setState(() {
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {


    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _passtextFieldController = TextEditingController();

    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return Scaffold(
          body: Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.5,
                      child: ClipPath(
                        clipper: CustomShapeClipper2(),
                        child: Container(
                          height: SizeConfig.getResponsiveHeight(100),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xff21d493), Colors.green],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: SizeConfig.getResponsiveHeight(30.0)),
                      height: SizeConfig.getResponsiveHeight(90),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 0.0,
                              color: Colors.black26,
                              offset: Offset(1.0, 10.0),
                              blurRadius: 20.0),
                        ],
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: GestureDetector(
                          onTap: () {
                            pickImageFromGallery(ImageSource.gallery);
                            setState(() {
                              imageFromSharedPreferences = null;
                            });
                          },
                          child:Container(
                            height: SizeConfig.getResponsiveHeight(120.0),
                            width: SizeConfig.getResponsiveWidth(112.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1000.0),
                              child: FittedBox(
                                  fit: BoxFit.cover,
                                  child:imageFromGallery(),
                              ),
                            ))
                    ),
                    ),
                  ]),
                Form(
                  key: formKey,
                  child: new ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      FadeAnimation(1.7,Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, right: 25, left: 25),
                        child:TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value.isEmpty || value.length<4) {
                              return "SignUPPage.InvalidusernameText";
                            }
                          },
                          onSaved: (value) => username= value,
                          //controller: _textFieldController,

                          decoration: new InputDecoration(
                            labelText: "SignUPPage.usernamelabelText",

                            prefixIcon: Icon(Icons.person,color: Colors.green,),
                            //labelText: AppLocalizations.of(context).categoryNameFruite,
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(15.0)),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),

                      ),),
                      FadeAnimation(1.8,Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, right: 25, left: 25),
                        child:TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isEmpty || !value.contains('@')) {
                              return "SignUPPage.InvalidemailText";
                            }
                          },
                          onSaved: (value) => email= value,
                          decoration: new InputDecoration(
                            labelText: "SignUPPage.emaillabelText",

                            prefixIcon: Icon(Icons.email,color: Colors.green,),
                            //labelText: AppLocalizations.of(context).categoryNameFruite,
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(15.0)),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),


                      )),

                      FadeAnimation(1.9,Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, right: 25, left: 25),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (value) => !(value.length >= 7)
                                    ? "invalid_phone_number"
                                    : null,
                               onSaved: (value) => phone= value,
                                decoration: new InputDecoration(
                                  labelText:"SignUPPage.PhoneNumber",

                                  prefixIcon:
                                  Padding(
                                    padding: const EdgeInsets.only(left:5),
                                    child: CountryPicker(
                                      showDialingCode: true,
                                      showName: false,
                                      onChanged: (Country country) {
                                        setState(() => _countryCode = country);
                                      },
                                      selectedCountry: _countryCode,
                                    ),
                                  ),

                                  //labelText: AppLocalizations.of(context).categoryNameFruite,
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                              ),
                            ),),




                      FadeAnimation(2.0,Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, right: 25, left: 25),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          validator: (value) {
                            if (value.isEmpty || value.length<6) {
                              return "SignUPPage.InvalidPasswordText";
                            }
                          },
                          onSaved: (value) => password= value,
                          controller: _passtextFieldController,

                          decoration: new InputDecoration(
                            labelText: "SignUPPage.PasswordlabelText",

                            prefixIcon: Icon(Icons.lock,color: Colors.green,),
                            //labelText: AppLocalizations.of(context).categoryNameFruite,
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(15.0)),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                      )),
                      FadeAnimation(2.1,Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, right: 25, left: 25),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          validator: (value) {
                            if(value.isEmpty)
                              return 'Empty';
                            if(value != _passtextFieldController.text)
                              return "SignUPPage.ConfirmPasswordValidate";
                          },
                          onSaved: (value) => confirmPassword= value,
                          //controller: _textFieldController,

                          decoration: new InputDecoration(
                            labelText: "SignUPPage.Confirmpassword",

                            prefixIcon: Icon(Icons.lock,color: Colors.green,),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(15.0)),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                      )),
                    ],
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
                  FadeAnimation(2.2,Container(
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
                        width: SizeConfig.getResponsiveWidth(90.0),
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "SignUPPage.LogInButton",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.getResponsiveWidth(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),),
                SizedBox(height: 15,),
                FadeAnimation(2.3,Container(
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

                      child:Text(
                        "SignUPPage.haveAccount",
                        style: TextStyle(
                            fontSize: SizeConfig.getResponsiveHeight(10),
                            color: Color(0xff21d493)),
                      ),
                    ),
                    onPressed: () async{

                      Navigator.of(context).push(
                          new MaterialPageRoute(
                              builder: (Context) =>
                              new SignIn(auth: widget.auth,
                                onSignedIn: widget.onSignedIn,)));

                    },
                  ),
                ),),
              ],
            ),
          ),
        );
      });
    });
  }
}


