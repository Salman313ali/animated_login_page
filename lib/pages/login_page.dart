import 'package:animated_login_page/pages/widgets/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

const mockupHeight = 1600;
const mockupWidth = 757;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller for playback
  Artboard? _yetiArtboard;
  SMITrigger? sucessTriger, failTrigger;
  SMIBool? isHandsUp, isChecking;
  SMINumber? numLook;

  StateMachineController? stateMachineController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _SigninFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    rootBundle.load("assets/characters/character2.riv").then(
      (data) {
        final file = RiveFile.import(data);
        final arthboard = file.mainArtboard;
        stateMachineController =
            StateMachineController.fromArtboard(arthboard, "State Machine 1");
        if (stateMachineController != null) {
          arthboard.addController(stateMachineController!);
        }

        //to check all animated trigger name and it type RIVE
        stateMachineController!.inputs.forEach((e) {
          debugPrint(e.runtimeType.toString());
          debugPrint("name${e.name}End");
        });
        stateMachineController!.inputs.forEach((element) {
          if (element.name == "Check") {
            isChecking = element as SMIBool;
          } else if (element.name == "Look") {
            numLook = element as SMINumber;
          } else if (element.name == "success") {
            sucessTriger = element as SMITrigger;
          } else if (element.name == "fail") {
            failTrigger = element as SMITrigger;
          } else if (element.name == "hands_up") {
            isHandsUp = element as SMIBool;
          }
        });
        setState(() {
          _yetiArtboard = arthboard;
        });
      },
    );
  }

  void handsOnTheEyes() {
    isHandsUp?.change(true);
  }

  void idelLook(val) {
    failTrigger?.change(false);
    isChecking?.change(false);
    isHandsUp?.change(false);
  }

  void lookOnTheTextField() {
    isHandsUp?.change(false);
    isChecking?.change(true);
    numLook?.change(0);
  }

  void moveEyeBalls(val) {
    numLook?.change(val.length.toDouble());
  }

  void login() {
    isChecking?.change(false);
    isHandsUp?.change(false);
    sucessTriger?.fire();
  }

  //sign user in method
  void signUserIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      isChecking?.change(false);
      isHandsUp?.change(false);
      failTrigger?.change(true);

      //wrong email
      if (e.code == 'user-not-found') {
        //show error to user
        wrongEmailMessage();
      }
      //wrong password
      else if (e.code == 'wrong-password') {
        //show error
        wrongPasswordMessage();
      }
    }
  }

  //wrong email message popup
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("Incorrect Email"),
        );
      },
    );
  }

  //wrong password message popup
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("Incorrect Password"),
        );
      },
    );
  }

  bool _obscurePassword = true;

  void togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final scale = mockupWidth / width;
    final textScale = width / mockupWidth;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 225, 225, 225).withOpacity(0.5),

      //to make every thing scrollable
      body: SingleChildScrollView(
        //push all the element in visible area
        child: SafeArea(
          child: Center(
            child: Column(
              //making every thing to be in center vertically
              mainAxisAlignment: MainAxisAlignment.center,

              //children of column
              children: [
                //User Email TextFeild
                SizedBox(
                  height: 75 / 1600 * height,
                ),
                if (_yetiArtboard != null)
                  SizedBox(
                    width: 550 / mockupWidth * width,
                    height: 375 / 1600 * height,
                    child: Rive(
                      artboard: _yetiArtboard!,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                Container(
                  width: 710 / mockupWidth * width,
                  height: 600 / mockupHeight * height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Form(
                    key: _SigninFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30 / mockupHeight * height,
                        ),
                        SizedBox(
                          width: 710 / mockupWidth * width,
                          child: Text(
                            "Welcome back You've been missed ",
                            textAlign: TextAlign.center,
                            textScaleFactor: textScale,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[800]!.withOpacity(0.8),
                              fontSize: 24.0,
                            ),
                          ),
                        ),
                        Spacer(),
                        SizedBox(
                          width: 600 / mockupWidth * width,
                          child: TextFormField(
                            controller: _emailController,
                            onChanged: moveEyeBalls,
                            onTap: lookOnTheTextField,
                            decoration: InputDecoration(
                              hintText: "email",
                              hintStyle: GoogleFonts.poppins(
                                letterSpacing: 0.7,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(200, 134, 134, 134),
                                fontSize: 14.0,
                              ),
                              fillColor:
                                  const Color.fromARGB(53, 212, 212, 212),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(53, 212, 212, 212),
                                ),
                              ),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(53, 212, 212, 212),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        SizedBox(
                          width: 600 / mockupWidth * width,
                          child: TextFormField(
                            controller: _passwordController,
                            onTap: handsOnTheEyes,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              hintText: "password",
                              hintStyle: GoogleFonts.poppins(
                                letterSpacing: 0.7,
                                fontWeight: FontWeight.w400,
                                color: const Color.fromARGB(200, 134, 134, 134),
                                fontSize: 14.0,
                              ),
                              fillColor:
                                  const Color.fromARGB(53, 212, 212, 212),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(53, 212, 212, 212),
                                ),
                              ),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(53, 212, 212, 212),
                                ),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: togglePasswordVisibility,
                                child: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0 / mockupHeight * height,
                        ),
                        SizedBox(
                          width: 600 / mockupWidth * width,
                          child: Row(
                            children: [
                              Spacer(),
                              Text(
                                "recover password",
                                textScaleFactor: textScale,
                                textAlign: TextAlign.end,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(177, 66, 66, 66),
                                  fontSize: 19.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 600 / mockupWidth * width,
                          height: 95 / mockupHeight * height,
                          child: ElevatedButton(
                            onPressed: signUserIn,
                            style: ElevatedButton.styleFrom(
                                shape: ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                shadowColor:
                                    const Color(0xffb04863).withOpacity(0.3),
                                backgroundColor: const Color(0xffb04863),
                                elevation: 20.0,
                                foregroundColor: Colors.white),
                            child: Text(
                              "Sign up",
                              textScaleFactor: textScale,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontSize: 24.0,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50 / mockupHeight * height,
                ),
                Text(
                  "or continue with",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 68, 68, 68),
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(
                  height: 50 / mockupHeight * height,
                ),
                SizedBox(
                  width: width * 0.45,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyIconButton(
                        todo: () {},
                        url: "assets/images/Apple-Logo.png",
                      ),
                      const Spacer(),
                      MyIconButton(
                        todo: () {},
                        url: "assets/images/google-logo.png",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
