// ignore_for_file: deprecated_member_use, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  var txHash;

  final myAddress = '0x387B8BC6d218aF571b2b5Be393ba57b41c5152aE';

  var myData;
  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(
      "https://rinkeby.infura.io/v3/584ac9558a7d46ec920fc65ce0d57a36",
      httpClient,
    );
    getBalance(myAddress);
  }

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets/api.json");
    //TODO: contract
    String contractAddress = "0xB21033c2A8F9685f18fd1BBF480fb4B6db42471B";

    final contract = DeployedContract(ContractAbi.fromJson(abi, "LKCoin"),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);

    return result;
  }

  Future<void> getBalance(String targetAddress) async {
    // EthereumAddress address  = EthereumAddress.fromHex(targetAddress);
    List<dynamic> result = await query("getBalance", []);

    myData = result[0];
    data = true;
    setState(() {});
  }

  Future<String> submit(String functionName, List<dynamic> args) async {
    EthPrivateKey credentials = EthPrivateKey.fromHex(
        "314629477196203757d41fa5305835fcebb789fc1cfa2c296441c42b0544f131");

    DeployedContract contract = await loadContract();

    final ethFunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
          contract: contract, function: ethFunction, parameters: args),
      fetchChainIdFromNetworkId: true,
    );

    return result;
  }

  Future<String> depositCoin() async {
    var bigAmount = BigInt.from(myAmount);
    var response = submit("depositBalance", [bigAmount]);
    txHash = response as String;
    setState(() {});
    debugPrint("Deposited");
    return response;
  }

  Future<String> withdrawCoin() async {
    var bigAmount = BigInt.from(myAmount);
    var response = submit("depositBalance", [bigAmount]);
    txHash = response as String;
    setState(() {});
    debugPrint("Withdrawn ");

    return response;
  }

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
                        ? Center(
                            child: Text(
                              "\$$myData",
                              style: const TextStyle(
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
                padding: const EdgeInsets.all(16.0),
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
                        onPressed: () {
                          getBalance(myAddress);
                        },
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
                        onPressed: () {
                          depositCoin();
                        },
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
                        onPressed: () {
                          withdrawCoin();
                        },
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
              ),
            ],
          ),
          txHash != null ? Text(txHash) : Container(),
        ],
      ),
    );
  }
}
