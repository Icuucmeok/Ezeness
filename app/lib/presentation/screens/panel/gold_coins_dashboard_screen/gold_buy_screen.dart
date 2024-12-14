import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../generated/l10n.dart';

class BuyCoinsScreen extends StatefulWidget {
  const BuyCoinsScreen({Key? key}) : super(key: key);
  static const String routName = 'gold_buy_screen';

  @override
  State<BuyCoinsScreen> createState() => _BuyCoinsScreenState();
}

class _BuyCoinsScreenState extends State<BuyCoinsScreen> {
  TextEditingController coinsController = TextEditingController();
  double exchangeRate = 0.00;
  double vat = 0.00;
  double transferCharges = 0.00;
  double totalAmount = 0.00;

  void calculateAmount() {
    double coins = double.tryParse(coinsController.text) ?? 0.00;
    setState(() {
      exchangeRate = coins * 0.1; // Example exchange rate calculation
      vat = exchangeRate * 0.05; // Example VAT
      transferCharges = 2.00; // Example transfer charges
      totalAmount = exchangeRate + vat + transferCharges;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("${S.current.buyGold}"),
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            Row(
              children: [
                Text(
                  S.current.totalCoins,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(width: 10),
                // Coins Input Field
                Expanded(
                  child: TextFormField(
                    controller: coinsController,
                    decoration: InputDecoration(
                      labelText: "Enter coins",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(),
                      ),
                      hintText: "0.00",
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => calculateAmount(),
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),

            // Coins Conversation Section
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.current.coinsConversion.toUpperCase(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 15),
                  _buildRowItem(
                    context,
                    title: S.current.exchangeRate,
                    amount: exchangeRate.toStringAsFixed(2),
                  ),
                  _buildRowItem(
                    context,
                    title: "VAT",
                    amount: vat.toStringAsFixed(2),
                  ),
                  _buildRowItem(
                    context,
                    title: S.current.transferCharges,
                    amount: transferCharges.toStringAsFixed(2),
                  ),
                  Divider(
                    color: Colors.grey[400],
                    thickness: 1,
                  ),
                  _buildRowItem(
                    context,
                    title: S.current.amount,
                    amount: totalAmount.toStringAsFixed(2),
                    isHighlighted: true,
                  ),
                ],
              ),
            ),

            Spacer(),

            // Buy Button
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Container(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle buying coins
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Buy",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowItem(BuildContext context,
      {required String title,
      required String amount,
      bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                color: isHighlighted ? Colors.black : Colors.grey[700],
              ),
            ),
          ),
          Text(
            "AED $amount",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              color: isHighlighted ? Colors.blue : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

class CoinsConversionScreen extends StatefulWidget {
  const CoinsConversionScreen({Key? key}) : super(key: key);
  static const String routName = 'coins_conversion_screen';

  @override
  State<CoinsConversionScreen> createState() => _CoinsConversionScreenState();
}

class _CoinsConversionScreenState extends State<CoinsConversionScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("${S.current.convert} ${S.current.coins}"),
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Coins Display
            Center(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          S.current.totalCoins,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "100.1234",
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // Coins Conversation Section
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.current.coinsConversion.toUpperCase(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 15),
                  _buildRowItem(
                    context,
                    title: S.current.exchangeRate,
                    amount: "0.00",
                  ),
                  _buildRowItem(
                    context,
                    title: S.current.vat,
                    amount: "0.00",
                  ),
                  _buildRowItem(
                    context,
                    title: S.current.transferCharges,
                    amount: "0.00",
                  ),
                  Divider(
                    color: Colors.grey[400],
                    thickness: 1,
                  ),
                  _buildRowItem(
                    context,
                    title: S.current.amount,
                    amount: "0.00",
                    isHighlighted: true,
                  ),
                ],
              ),
            ),

            Spacer(),

            // Convert Button
            Align(
              alignment: AlignmentDirectional.centerEnd,
              // width: double.infinity,
              child: Container(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {
                    // Conversion Logic
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    S.current.convert,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowItem(BuildContext context,
      {required String title,
      required String amount,
      bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                color: isHighlighted ? Colors.black : Colors.grey[700],
              ),
            ),
          ),
          Text(
            "AED $amount",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              color: isHighlighted ? Colors.blue : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
