// ignore_for_file: file_names

import 'package:doorstep_banking_flutter/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:doorstep_banking_flutter/color.dart';

class AppInfoPage extends StatefulWidget {
  const AppInfoPage({Key? key}) : super(key: key);

  @override
  _AppInfoPageState createState() => _AppInfoPageState();
}

class _AppInfoPageState extends State<AppInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.off_white,
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          constraints: BoxConstraints(
              // maxHeight: MediaQuery.of(context).size.height,
              // maxWidth: MediaQuery.of(context).size.width,
              ),
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 6,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Container(
                                height: 130.0,
                                width: 130.0,
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: colors.off_white,
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(4, 4),
                                        // blurRadius: 15,
                                        spreadRadius: 1.0,
                                      ),
                                      BoxShadow(
                                        color: Colors.white,
                                        offset: Offset(-4, -4),
                                        // blurRadius: 15,
                                        // spreadRadius: 1.0,
                                      ),
                                    ]),
                              ),
                              ClipRRect(
                                child: Image.asset(
                                    'assets/icons/atm_bharath_logo.png',
                                    height: 106,
                                    width: 90),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).doorStepBanking,
                                style: const TextStyle(
                                  color: colors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).verificationCode,
                                style: const TextStyle(
                                  color: colors.primaryColor,
                                  fontSize: 16.0,
                                ),
                              )
                            ],
                          )
                        ],
                      ))),
              Expanded(
                  flex: 0,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).from,
                                style: const TextStyle(
                                  color: colors.primaryColor,
                                  fontSize: 18.0,
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).atmBharath,
                                style: const TextStyle(
                                  color: colors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              )
                            ],
                          )
                        ],
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
