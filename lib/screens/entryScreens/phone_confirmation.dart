import 'dart:io';
import 'package:basket/screens/home_page/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:basket/screens/entryScreens/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_toolbox/flutter_toolbox.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import './phone_number_utils.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;

class PhoneAuthSimple extends StatefulWidget {
  final Country countryCode;
  final String phoneNumber;
  final String name;
  final String email;
  final String password;
  final String confirm;
  //final VoidCallback onVerificationFailure;
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  PhoneAuthSimple({
    @required this.countryCode,
    @required this.phoneNumber,
    @required this.name,
    @required this.email,
    @required this.password,
    @required this.confirm,
    @required this.auth,
    @required this.onSignedIn,
    //this.onVerificationFailure,

  });

  @override
  _PhoneAuthSimpleState createState() => _PhoneAuthSimpleState();
}

class _PhoneAuthSimpleState extends State<PhoneAuthSimple> {
  int showStatus = 1;
  String errorMessage = '';

  bool isSmsCodeSent = false;
  bool isError = false;

  List<String> _optText = [];
  String _verificationId;
  String _smsCode;

  bool _loading = false;
  FirebaseDatabase _database = FirebaseDatabase.instance;

  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller6 = TextEditingController();

  TextEditingController currController = TextEditingController();

  Future onVerificationSuccess() async {
    if (mounted) setState(() => showStatus = 6);

    print("\n\n +44444444444444");

    try {

      FirebaseUser user = (await FirebaseAuth.instance.createUserWithEmailAndPassword (
          email: widget.email, password: widget.password )).user;

      if (user.uid != null) {

        ////- from move to another screen
        //// update new customer informations mu adding Phone number

        _database.reference ( ).child ( "customers" ).child(user.uid)
            .set ( {
          "email":widget.email,
          "gender":"male",
          "isBlocked":false ,
          "name":widget.name,
          "latitude":1.1,
          "longitude":1.1,
          "phone":widget.countryCode.dialingCode.toString()+widget.phoneNumber.toString()

        });


        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: widget.email, password: widget.password);


        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Store()));


      }
      //widget.onSignedIn;
    }
    on SocketException catch (e) {
      print('SocketException-> $e');
      errorToast('please_check_your_connection');
    } catch (e) {
      print('RegisterScreenState#_submit UnknownError-> $e');
      errorToast('server_error');
    }
  }

  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verId) {
      d("autoRetrieve => verId = ${verId}");
      _verificationId = verId;
//      setState(() => showStatus = 3);
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeSent]) {
      d("smsCodeSent => verId = ${verId}");
      _verificationId = verId;
      setState(() => showStatus = 2);
    };

    final PhoneVerificationCompleted autoVerifiedSuccess =
        (AuthCredential phoneAuthCredential) async {
      d("autoVerifiedSuccess => phoneAuthCredential $phoneAuthCredential");
      setState(() {
        controller1.text = "*";
        controller2.text = "*";
        controller3.text = "*";
        controller4.text = "*";
        controller5.text = "*";
        controller6.text = "*";
      });
      await createUser(phoneAuthCredential);
      Future.delayed(Duration(seconds: 2), onVerificationSuccess);
    };

    final PhoneVerificationFailed verifyFailed = (AuthException exception) {
      d("Failed ${exception.message}");

      setState(() {
        showStatus = 5;
        errorMessage = localizeErrorMessage(context, exception);
      });
    };

    d("getValidNumber(widget.countryCode.dialingCode, widget.phoneNumber) = ${getValidNumber(widget.countryCode.dialingCode, widget.phoneNumber)}");
    await _auth.verifyPhoneNumber(
      phoneNumber:
          getValidNumber(widget.countryCode.dialingCode, widget.phoneNumber),
      timeout: const Duration(seconds: 5),
      verificationCompleted: autoVerifiedSuccess,
      verificationFailed: verifyFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future manualVerification() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: _verificationId,
      smsCode: _smsCode,
    );

    await createUser(credential);
  }

  Future createUser(AuthCredential credential) async {
    final onError = (exception, stacktrace) {
      d('Error from _signIn: $exception');
      setState(() => showStatus = 4);
    };


    final FirebaseUser user =
        (await _auth.signInWithCredential(credential).catchError(onError))
            ?.user;

    if (user != null) {

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      onVerificationSuccess();
    } else {
      setState(() => showStatus = 4);
    }
  }

  @override
  void initState() {
    super.initState();

    currController = controller1;
    verifyPhone();
  }

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    controller4.dispose();
    controller5.dispose();
    controller6.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      Padding(
        padding: EdgeInsets.only(left: 0, right: 2),
        child: Container(
          color: Colors.transparent,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2, left: 2),
        child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                border:
                    Border.all(width: 1, color: Color.fromRGBO(0, 0, 0, 0.1)),
                borderRadius: BorderRadius.circular(50)),
            child: TextField(
              decoration: InputDecoration.collapsed(hintText: ''),
              inputFormatters: [LengthLimitingTextInputFormatter(1)],
              enabled: false,
              controller: controller1,
              autofocus: false,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, color: Colors.black),
            )),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2, left: 2),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              border: Border.all(width: 1, color: Color.fromRGBO(0, 0, 0, 0.1)),
              borderRadius: BorderRadius.circular(50)),
          child: TextField(
            decoration: InputDecoration.collapsed(hintText: ''),
            inputFormatters: [LengthLimitingTextInputFormatter(1)],
            controller: controller2,
            autofocus: false,
            enabled: false,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2, left: 2),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              border: Border.all(width: 1, color: Color.fromRGBO(0, 0, 0, 0.1)),
              borderRadius: BorderRadius.circular(50)),
          child: TextField(
            decoration: InputDecoration.collapsed(hintText: ''),
            inputFormatters: [LengthLimitingTextInputFormatter(1)],
            keyboardType: TextInputType.number,
            controller: controller3,
            textAlign: TextAlign.center,
            autofocus: false,
            enabled: false,
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2, left: 2),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              border: Border.all(width: 1, color: Color.fromRGBO(0, 0, 0, 0.1)),
              borderRadius: BorderRadius.circular(50)),
          child: TextField(
            decoration: InputDecoration.collapsed(hintText: ''),
            inputFormatters: [LengthLimitingTextInputFormatter(1)],
            textAlign: TextAlign.center,
            controller: controller4,
            autofocus: false,
            enabled: false,
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2, left: 2),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              border: Border.all(width: 1, color: Color.fromRGBO(0, 0, 0, 0.1)),
              borderRadius: BorderRadius.circular(50)),
          child: TextField(
            decoration: InputDecoration.collapsed(hintText: ''),
            inputFormatters: [LengthLimitingTextInputFormatter(1)],
            textAlign: TextAlign.center,
            controller: controller5,
            autofocus: false,
            enabled: false,
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 2, left: 2),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              border: Border.all(width: 1, color: Color.fromRGBO(0, 0, 0, 0.1)),
              borderRadius: BorderRadius.circular(50)),
          child: TextField(
            decoration: InputDecoration.collapsed(hintText: ''),
            inputFormatters: [LengthLimitingTextInputFormatter(1)],
            textAlign: TextAlign.center,
            controller: controller6,
            autofocus: false,
            enabled: false,
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 2, right: 0),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("SignUPPage.PhoneConfirmation.ActivateAccount"),
        backgroundColor: Color(0xff21d493),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("SignUPPage.PhoneConfirmation.EditNumber"),
            textColor: Colors.white,
          )
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: ListView(
                shrinkWrap: true, // use it
                children: <Widget>[
                  buildHeader(),
                  buildCodeInput(widgetList),
                ],
              ),
            ),
            buildKeyboard(),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("SignUPPage.PhoneConfirmation.MessagesShortly"),
          codeStatus(),
          Column(
            children: <Widget>[
              SizedBox(height: 16),
              Text(
               "SignUPPage.PhoneConfirmation.CodeSent",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${widget.countryCode.dialingCode}${widget.phoneNumber}',
                    style: textTheme.title,
                  ),
                  Text(
                    '+',
                    style: textTheme.title,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCodeInput(List<Widget> widgetList) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: GridView.count(
        crossAxisCount: 8,
        mainAxisSpacing: 10,
        shrinkWrap: true,
        primary: false,
        scrollDirection: Axis.vertical,
        children: List<Container>.generate(
          8,
          (int index) => Container(child: widgetList[index]),
        ),
      ),
    );
  }

  Widget buildKeyboard() {
    return Flexible(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8, top: 16, right: 8, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    MaterialButton(
                      onPressed: () => inputTextToField("1"),
                      child: Text("1",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center),
                    ),
                    MaterialButton(
                      onPressed: () => inputTextToField("2"),
                      child: Text("2",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center),
                    ),
                    MaterialButton(
                      onPressed: () => inputTextToField("3"),
                      child: Text("3",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8, top: 4, right: 8, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    MaterialButton(
                      onPressed: () => inputTextToField("4"),
                      child: Text("4",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center),
                    ),
                    MaterialButton(
                      onPressed: () => inputTextToField("5"),
                      child: Text("5",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center),
                    ),
                    MaterialButton(
                      onPressed: () => inputTextToField("6"),
                      child: Text("6",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8, top: 4, right: 8, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    MaterialButton(
                      onPressed: () => inputTextToField("7"),
                      child: Text("7",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center),
                    ),
                    MaterialButton(
                      onPressed: () => inputTextToField("8"),
                      child: Text("8",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center),
                    ),
                    MaterialButton(
                      onPressed: () => inputTextToField("9"),
                      child: Text("9",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8, top: 4, right: 8, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    MaterialButton(
                      onPressed: matchOtp,
                      child: Icon(Icons.check),
                    ),
                    MaterialButton(
                      onPressed: () => inputTextToField("0"),
                      child: Text("0",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center),
                    ),
                    MaterialButton(
                      onPressed: deleteText,
                      child: Icon(Icons.backspace),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void inputTextToField(String str) {
    //Edit first textField
    if (currController == controller1) {
      _optText.insert(0, str);
      controller1.text = str;
      currController = controller2;
    }

    //Edit second textField
    else if (currController == controller2) {
      _optText.insert(1, str);
      controller2.text = str;
      currController = controller3;
    }

    //Edit third textField
    else if (currController == controller3) {
      _optText.insert(2, str);
      controller3.text = str;
      currController = controller4;
    }

    //Edit fourth textField
    else if (currController == controller4) {
      _optText.insert(3, str);
      controller4.text = str;
      currController = controller5;
    }

    //Edit fifth textField
    else if (currController == controller5) {
      _optText.insert(4, str);
      controller5.text = str;
      currController = controller6;
    }

    //Edit sixth textField
    else if (currController == controller6) {
      if (_optText.length == 6) {
        _optText.removeLast();
        _optText.insert(5, str);
      } else {
        _optText.insert(5, str);
      }
      controller6.text = str;
      currController = controller6;
    }
  }

  void deleteText() {
    if (_optText.isEmpty) return;
    _optText.removeLast();
    if (currController.text.length == 0) {
    } else {
      currController.text = "";
      currController = controller6;
      return;
    }

    if (currController == controller1) {
      controller1.text = "";
    } else if (currController == controller2) {
      controller1.text = "";
      currController = controller1;
    } else if (currController == controller3) {
      controller2.text = "";
      currController = controller2;
    } else if (currController == controller4) {
      controller3.text = "";
      currController = controller3;
    } else if (currController == controller5) {
      controller4.text = "";
      currController = controller4;
    } else if (currController == controller6) {
      controller5.text = "";
      currController = controller5;
    }
  }

  Future matchOtp() async {
    _smsCode = _optText.join();
    d("Entered OTP is ${_optText.join()}");

    if (_smsCode.length < 6) return;

    setState(() => _loading = true);
    await manualVerification();
    setState(() => _loading = false);
  }

  Widget codeStatus() {
    if (showStatus == 1) {
      return Text(
        'sending_message',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      );
    }
    if (showStatus == 2) {
      return Text(
        'message_has_been_sent',
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green),
      );
    }
    if (showStatus == 3) {
      return CircularProgressIndicator();
    }
    if (showStatus == 4) {
      return Text(
        'the_entered_code_is_wrong',
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red),
      );
    }
    if (showStatus == 5) {
      return Text(
        errorMessage,
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red),
      );
    }
    if (showStatus == 6) {
      return Text(
        'verification_successful',
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green),
      );
    }
    return Container();
  }
}

String localizeErrorMessage(BuildContext context, AuthException exception) {
  final localizedErrorMessages = {
    "invalidCredential": 'the_number_you_entered_is_wrong',
    "tooManyRequests": 'your_number_has_been_temporarily_blocked_because_of_the_repeated'
  };

  d("localizedErrorMessages.containsKey(exception.code) = ${localizedErrorMessages.containsKey(exception.code)}");
  d("exception.code = ${exception.code}");

  return localizedErrorMessages.containsKey(exception.code)
      ? localizedErrorMessages[exception.code]
      : exception.message;
}
