import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lasagna_app/globalvariables.dart';
import 'package:lasagna_app/screens/failedpage.dart';
import 'package:lasagna_app/screens/successspage.dart';
import 'package:lasagna_app/widgets/main_button.dart';
import 'package:lasagna_app/widgets/progress_dialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:textfield_tags/textfield_tags.dart';

class HomePage extends StatefulWidget {
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

  final _textBackNumberFormatter = MaskTextInputFormatter(
      mask: '(###) ###-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  final TextEditingController _messageBodyController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _textBackNumberController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                    Padding(
                        padding: const EdgeInsets.only(left: 38),
                        child: AnimatedTextKit(
                          repeatForever: false,
                          isRepeatingAnimation: false,
                          animatedTexts: [
                            TyperAnimatedText(
                              'Send',
                              textStyle: const TextStyle(
                                fontSize: 50,
                                fontFamily: 'Uber',
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF4A148C),
                              ),
                            ),
                            TyperAnimatedText(
                              'Anonymous',
                              textStyle: const TextStyle(
                                fontSize: 50,
                                fontFamily: 'Uber',
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF4A148C),
                              ),
                            ),
                            TyperAnimatedText(
                              'Texts.',
                              textStyle: const TextStyle(
                                fontSize: 50,
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
                    const SizedBox(
                      height: 16,
                    ),
                    // Chips Trials

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
                              icon: defaultTargetPlatform == TargetPlatform.iOS
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
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            padding: const EdgeInsets.symmetric(
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
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _textBackNumberController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [_textBackNumberFormatter],
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        icon: defaultTargetPlatform == TargetPlatform.iOS
                            ? const Icon(CupertinoIcons.phone_arrow_down_left)
                            : const Icon(Icons.phone_callback_outlined),
                        // hintText: 'Phone number for reply texts',
                        hintText: 'Text Back Number (Optional)',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    MainButton(
                      onTap: () => onButtonPress(),
                      buttonTitleString: 'SEND',
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onButtonPress() async {
    final uri = Uri.parse(serverUrl);

    List<String>? unformattedPhoneNumberList = _controller.getTags;
    List<String>? formattedList = [];

    // Conditions to check UI failures
    for (String phoneNumber in unformattedPhoneNumberList!) {
      String formattedString = phoneNumber.replaceAll(RegExp('[^0-9]'), '');
      formattedList.add(formattedString);
    }

    if (formattedList.isEmpty) {
      unsuccessful('Please at least one Phone Number to Send to');
      return;
    }

    if (_textBackNumberFormatter.getUnmaskedText().isNotEmpty) {
      if (_textBackNumberFormatter.getUnmaskedText().length != 10) {
        unsuccessful('Please Enter a Valid Text Back Number');
        return;
      }
    }

    if (_messageBodyController.text.isEmpty) {
      unsuccessful('Please Enter a Message Body');
      return;
    }

    // get comma delimited phone numbers
    String commaDelimitedString = formattedList.join(", ");

    Map<String, String> reqBody = {
      "firstNumber": commaDelimitedString,
      "messageString": _messageBodyController.text,
      "returnNumber": _textBackNumberFormatter.getUnmaskedText(),
    };

    print(reqBody);

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

    if (context.mounted) {
      Navigator.pop(context);
    }

    // Await for the response, then return error or success
    if (response.statusCode == 200) {
      successful();
      return;
    } else {
      unsuccessful("Error: ${response.statusCode}, contact Support");
    }

    // if (context.mounted) {

    // }
  }

  void successful() {
    Navigator.push(
      context,
      PageTransition(child: const SuccessPage(), type: PageTransitionType.fade),
    );
    _textBackNumberController.clear();
    _textBackNumberFormatter.clear();
    _phoneNumberController.clear();
    _phoneNumberFormatter.clear();
    _messageBodyController.clear();
    _controller.clearTags();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void unsuccessful(String errorMsg) {
    Navigator.push(
      context,
      PageTransition(
          child: FailedPage(
            errorMessage: errorMsg,
          ),
          type: PageTransitionType.fade),
    );
  }
}
