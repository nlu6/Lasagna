import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lasagna_app/globalvariables.dart';
import 'package:lasagna_app/screens/failedpage.dart';
import 'package:lasagna_app/screens/loginpage.dart';
import 'package:lasagna_app/screens/successspage.dart';
import 'package:lasagna_app/widgets/main_button.dart';
import 'package:lasagna_app/widgets/progress_dialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:textfield_tags/textfield_tags.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _distanceToField = 0;
  TextfieldTagsController _controller = TextfieldTagsController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = TextfieldTagsController();
  }

  final _phoneNumberFormatter = MaskTextInputFormatter(
      mask: '(###) ###-####,',
      // filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.eager);

  final TextEditingController _messageBodyController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final _user = FirebaseAuth.instance.currentUser;

  bool textBackFlag = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(0, 0, 0, 0),
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Padding(
                padding: const EdgeInsets.only(
                    left: 38, top: 16, bottom: 16, right: 16),
                child: AnimatedTextKit(
                  repeatForever: false,
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TyperAnimatedText(
                      'Send',
                      textStyle: const TextStyle(
                        fontSize: 40,
                        fontFamily: 'Uber',
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4A148C),
                      ),
                    ),
                    TyperAnimatedText(
                      'Anonymous',
                      textStyle: const TextStyle(
                        fontSize: 40,
                        fontFamily: 'Uber',
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4A148C),
                      ),
                    ),
                    TyperAnimatedText(
                      'Texts.',
                      textStyle: const TextStyle(
                        fontSize: 40,
                        fontFamily: 'Uber',
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4A148C),
                      ),
                    ),
                    TyperAnimatedText(
                      'Lasagna',
                      textStyle: const TextStyle(
                        fontSize: 50,
                        fontFamily: 'Uber',
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4A148C),
                      ),
                    ),
                  ],
                )),
            actions: [
              _user != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TextButton(
                        style: const ButtonStyle(
                            splashFactory: NoSplash.splashFactory),
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.push(
                            context,
                            PageTransition(
                                child: const HomePage(),
                                type: PageTransitionType.fade),
                          );
                        },
                        child: const Text('Log Out'),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TextButton(
                        style: const ButtonStyle(
                            splashFactory: NoSplash.splashFactory),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                                child: const LoginPage(),
                                type: PageTransitionType.fade),
                          );
                        },
                        child: const Text('Log In'),
                      ),
                    )
            ],
          ),
          resizeToAvoidBottomInset: false,
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldTags(
                        textfieldTagsController: _controller,
                        textSeparators: const [
                          ',',
                        ],
                        letterCase: LetterCase.normal,
                        validator: (String tag) {
                          if (_controller.getTags!.contains(tag)) {
                            return 'Number Already Entered';
                          }
                          return null;
                        },
                        inputfieldBuilder:
                            (context, tec, fn, error, onChanged, onSubmitted) {
                          return ((context, sc, tags, onTagDelete) {
                            return TextField(
                              inputFormatters: [_phoneNumberFormatter],
                              focusNode: fn,
                              controller: tec,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                icon:
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? const Icon(CupertinoIcons.phone)
                                        : const Icon(Icons.call_outlined),
                                hintText: _controller.hasTags
                                    ? ''
                                    : "Enter Phone Numbers",
                                errorText: error,
                                prefixIconConstraints: BoxConstraints(
                                    maxWidth: !fn.hasFocus
                                        ? _distanceToField * 1
                                        : _distanceToField * 0.55),
                                prefixIcon: tags.isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: SingleChildScrollView(
                                          controller: sc,
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                              children: tags.map((String tag) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade100,
                                                border: Border.all(
                                                  color: Colors.grey,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(4.0),
                                                ),
                                                // color: Colors.white,
                                              ),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5.0),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 2,
                                                vertical: 5.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    child: Text(
                                                      tag,
                                                      style: const TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4.0),
                                                  InkWell(
                                                    child: const Icon(
                                                      Icons.cancel,
                                                      size: 14.0,
                                                      color: Colors.grey,
                                                    ),
                                                    onTap: () {
                                                      onTagDelete(tag);
                                                    },
                                                  )
                                                ],
                                              ),
                                            );
                                          }).toList()),
                                        ),
                                      )
                                    : null,
                              ),
                              onChanged: onChanged,
                            );
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        textAlignVertical: TextAlignVertical.top,
                        controller: _messageBodyController,
                        keyboardType: TextInputType.multiline,
                        textAlign: TextAlign.start,
                        minLines: 6,
                        maxLines: 6,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          border: const OutlineInputBorder(),
                          icon: Padding(
                            padding: const EdgeInsets.only(bottom: 90),
                            child: defaultTargetPlatform == TargetPlatform.iOS
                                ? const Icon(CupertinoIcons.mail)
                                : const Icon(Icons.email_outlined),
                          ),
                          hintText: 'Message',
                          // labelText: 'Message',
                        ),
                      ),
                      _user != null
                          ? _user!.emailVerified
                              ? Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: Checkbox(
                                            value: textBackFlag,
                                            onChanged: ((value) {
                                              setState(() {
                                                textBackFlag = value!;
                                              });
                                            })),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 11),
                                      child: TextButton(
                                        style: const ButtonStyle(
                                            splashFactory:
                                                NoSplash.splashFactory),
                                        onPressed: () {
                                          setState(() {
                                            textBackFlag = !textBackFlag;
                                          });
                                        },
                                        child: const Text(
                                            'Use Your Email as Text Back Email'),
                                      ),
                                    ),
                                  ],
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: TextButton(
                                    style: const ButtonStyle(
                                        splashFactory: NoSplash.splashFactory),
                                    onPressed: () {
                                      verifyEmail();
                                    },
                                    child: const Text(
                                        'Verify to Use Your Email as The Text Back Email'),
                                  ),
                                )
                          : Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: TextButton(
                                style: const ButtonStyle(
                                    splashFactory: NoSplash.splashFactory),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        child: const LoginPage(),
                                        type: PageTransitionType.fade),
                                  );
                                },
                                child: const Text(
                                    'Log In to Use Your Email as The Text Back Email'),
                              ),
                            ),
                      MainButton(
                        onTap: () => onSubmitButtonPress(),
                        // onTap: () => gotoPage(),
                        buttonTitleString: 'SEND',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSubmitButtonPress() async {
    final uri = Uri.parse(serverUrl);

    List<String>? unformattedPhoneNumberList = _controller.getTags;
    List<String>? formattedList = [];

    // Conditions to check UI failures
    for (String phoneNumber in unformattedPhoneNumberList!) {
      String formattedString = phoneNumber.replaceAll(RegExp('[^0-9]'), '');
      formattedList.add(formattedString);
    }

    if (formattedList.isEmpty) {
      unsuccessfulRequest('Please at least one Phone Number to Send to');
      return;
    }

    if (_messageBodyController.text.isEmpty) {
      unsuccessfulRequest('Please Enter a Message Body');
      return;
    }

    // get comma delimited phone numbers
    String commaDelimitedString = formattedList.join(", ");

    Map<String, String> reqBody = {
      "firstNumber": commaDelimitedString,
      "messageString": _messageBodyController.text,
      "textBackEmail": 'none'
    };

    if (textBackFlag) {
      reqBody["textBackEmail"] = (_user?.email)!;
    }

    http.Response response = await http.post(
      uri,
      body: reqBody,
    );

    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const ProgressDialog(),
      );
    }

    // Await for the response, then return error or success
    if (response.statusCode == 200) {
      successfulRequest();
      return;
    } else {
      unsuccessfulRequest("Error: ${response.statusCode}, contact Support");
    }
  }

  void successfulRequest() {
    Navigator.push(
      context,
      PageTransition(child: const SuccessPage(), type: PageTransitionType.fade),
    );
    _phoneNumberController.clear();
    _phoneNumberFormatter.clear();
    _messageBodyController.clear();
    _controller.clearTags();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void unsuccessfulRequest(String errorMsg) {
    Navigator.push(
      context,
      PageTransition(
          child: FailedPage(
            errorMessage: errorMsg,
          ),
          type: PageTransitionType.fade),
    );
  }

  void verifyEmail() {
    _user!.sendEmailVerification();
    showErrMessage('Check your Email for Verification Link, and Sign Back In');
  }

  void gotoPage() {
    Navigator.push(
      context,
      PageTransition(child: const LoginPage(), type: PageTransitionType.fade),
    );
  }

  void showErrMessage(String? errMsg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(errMsg!)));
  }
}
