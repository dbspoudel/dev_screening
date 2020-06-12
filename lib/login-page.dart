import 'package:avatar_glow/avatar_glow.dart';
import 'package:devscreening/helpers/delayed-animation.dart';
import 'package:devscreening/helpers/styles.dart';
import 'package:devscreening/helpers/transitions.dart';
import 'package:devscreening/home-page.dart';
import 'package:devscreening/widgets/simple-alert-dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final int _delayedAmount = 500;
  final Color _primaryColour = Color(0xFFFF9900);
  final Color _backgroundColour = Color(0xFFFFFFFF);
  final _formKey = GlobalKey<FormState>();
  double _scale;
  AnimationController _controller;
  String username, password;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  bool isLoading = false;
  bool showPassword = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    var screenSize = MediaQuery.of(context).size;
    void _onTapDown(TapDownDetails details) {
      _controller.forward();
    }

    bool checkEmailPassword() {
      if (_emailController.text == "tekkon@gmail.com" &&
          _passwordController.text == "tekkon") return true;
      return false;
    }

    void _onTapUp(TapUpDetails details) {
      _controller.reverse();
      if (_formKey.currentState.validate()) {
        bool isvalidEmailPassword = checkEmailPassword();
        if (!isvalidEmailPassword)
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text("Your email or password is incorrect. \n Try again !"),
            ));
        if (isvalidEmailPassword)
          Future.delayed(Duration(milliseconds: 200), () {
            Navigator.of(context).push(
                slideFromRightTransition(MyHomePage(title: "Flutter Test")));
          });
      }
    }

    Future<bool> showExitDialog() {
      return showDialog(
          context: context,
          builder: (_) => SimpleAlertDialog(
                message: 'Are you sure you wish to exit?',
                rightButton: TitleAndAction(
                    title: 'Exit',
                    action: () => SystemChannels.platform
                        .invokeMethod('SystemNavigator.pop')),
                middleButton: TitleAndAction(
                    title: 'Cancel', action: () => Navigator.pop(context)),
              ));
    }

    Widget _animatedButton() {
      return Container(
        height: 60,
        width: 270,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: _primaryColour,
            boxShadow: [
              BoxShadow(
                  color: Colors.black87,
                  offset: Offset(0, 4),
                  blurRadius: 5.0,
                  spreadRadius: -4.0)
            ]),
        child: Center(
          child: Text(
            'Proceed',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: _backgroundColour,
            ),
          ),
        ),
      );
    }

    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: WillPopScope(
          onWillPop: () {
            return showExitDialog();
          },
          child: SingleChildScrollView(
                      child: Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(screenSize.width / 3)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Container(
                    height: screenSize.height / 3,
                    width: screenSize.width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                          Theme.of(context).primaryColor,
                          Color(0xFFFF3A09)
                        ])),
                    alignment: Alignment.center,
                    child: AvatarGlow(
                      endRadius: 90,
                      duration: Duration(seconds: 2),
                      glowColor: Colors.white24,
                      repeat: true,
                      repeatPauseDuration: Duration(seconds: 2),
                      startDelay: Duration(seconds: 1),
                      child: Material(
                          elevation: 8.0,
                          shape: CircleBorder(),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: FlutterLogo(
                              size: 50.0,
                            ),
                            radius: 50.0,
                          )),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        DelayedAnimation(
                          delay: _delayedAmount + 500,
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              labelText: "Email",
                              hintText: "Your email here",
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(25.0),
                                  gapPadding: 10.0),
                            ),
                            validator: (value) {
                              if (value.isEmpty) return "Email is required";
                              if (RegExp("^([0-9a-zA-Z]([-.+\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})\$")
                                      .hasMatch(value) ==
                                  false) return "Invalid Email address";
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        DelayedAnimation(
                          delay: _delayedAmount + 1000,
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: !showPassword,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.security),
                              labelText: "Password",
                              hintText: "Your Password here",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  showPassword = !showPassword;
                                  setState(() {});
                                },
                                icon: Icon(Icons.remove_red_eye,
                                    color: showPassword
                                        ? Theme.of(context).primaryColor
                                        : Colors.black54),
                              ),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(25.0),
                                  gapPadding: 10.0),
                            ),
                            validator: (value) {
                              if (value.isEmpty)
                                return "Please enter your password";
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 50.0,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                DelayedAnimation(
                  child: GestureDetector(
                    onTapDown: _onTapDown,
                    onTapUp: _onTapUp,
                    child: Transform.scale(
                      scale: _scale,
                      child: _animatedButton(),
                    ),
                  ),
                  delay: _delayedAmount + 1500,
                ),
                const SizedBox(
                  height: 50.0,
                ),
                DelayedAnimation(
                  child: GestureDetector(
                    onTap: () {
                      showExitDialog();
                    },
                    child: Text(
                      "I DON'T WANT TO PROCEED",
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: _primaryColour),
                    ),
                  ),
                  delay: _delayedAmount + 2000,
                ),
              ],
            ),
          ),
        ));
  }
}
