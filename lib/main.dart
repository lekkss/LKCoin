// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lkcoin/slider_widget.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LKCOin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Client httpClient;
  late Web3Client ethClient;
  bool data = false;
  int myAmount = 0;

  final myAddress = '0x387B8BC6d218aF571b2b5Be393ba57b41c5152aE';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height * 0.3,
            color: Colors.blue[600],
          ),
          Column(
            children: [
              SizedBox(
                height: size.height * 0.1,
              ),
              const Center(
                  child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "\$LKCOIN",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              )),
              SizedBox(
                height: size.height * 0.05,
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                margin: const EdgeInsets.all(16),
                width: size.width,
                height: size.height * 0.18,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Balance",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      ),
                    ),
                    data
                        ? const Center(
                            child: Text(
                              "\$1",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 26),
                            ),
                          )
                        : const Center(child: CircularProgressIndicator()),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: SliderWidget(
                  min: 0,
                  max: 100,
                  fullWidth: true,
                  finalVal: (double value) {
                    myAmount = (value * 100).round();
                    print(myAmount);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 50,
                      child: RaisedButton.icon(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Refresh",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: RaisedButton.icon(
                        color: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.call_made,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Deposit",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: RaisedButton.icon(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.call_received_sharp,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Withdraw",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
