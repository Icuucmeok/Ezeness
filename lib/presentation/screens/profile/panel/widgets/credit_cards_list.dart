import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/models/credit_card/credit_card_model.dart';
import '../../../../../logic/cubit/credit_card/card_bloc.dart';

class CreditCardsList extends StatefulWidget {
  const CreditCardsList(this.cardList);

  final List<CardModel> cardList;

  @override
  State<CreditCardsList> createState() => _CreditCardsListState();
}

class _CreditCardsListState extends State<CreditCardsList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CardBloc, CardState>(
      builder: (context, state) {
        return Container(
          child: buildCardListUI(widget.cardList),
        );
      },
    );
  }

  Widget buildCardListUI(List<CardModel> cardList) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: cardList.length,
      itemBuilder: (context, index) {
        final card = cardList[index];
        return Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Radio<int>(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: index,
                      groupValue: selectedCardIndex,
                      onChanged: (value) {
                        setState(() {
                          selectedCardIndex = value!;
                        });
                      },
                    ),
                    Text('${card.cardType} **** ${card.lastDigits}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(card.cardHolderName),
                    Text('Expires ${card.expiryDate}'),
                  ],
                ),
              ),
              Icon(CupertinoIcons.creditcard_fill, color: Colors.black),
              const Divider()
            ],
          ),
        );
      },
    );
  }
}
