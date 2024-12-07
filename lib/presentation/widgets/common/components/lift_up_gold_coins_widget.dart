import 'package:ezeness/presentation/screens/panel/gold_coins_dashboard_screen/gold_buy_screen.dart';
import 'package:ezeness/presentation/screens/panel/gold_coins_dashboard_screen/gold_coins_details_screen.dart';
import 'package:ezeness/res/app_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/user/user.dart';
import '../../../../generated/l10n.dart';
import '../../../../logic/cubit/app_config/app_config_cubit.dart';
import '../../../router/app_router.dart';
import '../../../screens/panel/gold_coins_dashboard_screen/calculate_convert_coin_screen.dart';
import '../../../utils/app_snackbar.dart';

class LiftUpGoldCoinsWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final bool withConvert;

  const LiftUpGoldCoinsWidget({
    Key? key,
    this.onTap,
    this.withConvert = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = context.read<AppConfigCubit>().getUser();
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 10, left: 15, right: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.orange.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(S.current.goldCoins,
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        "${user.coins} ${S.current.coins}",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  SizedBox(width: 60)
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: onTap,
                      child: Text(S.current.dashboard,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: AppColors.secondary, fontSize: 13)),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: InkWell(
                        onTap: !withConvert
                            ? null
                            : () {
                                // print("object");
                                if (double.parse(user.coins.toString()) < 0) {
                                  //change for functional 100
                                  AppSnackBar(
                                          message: S.current.noEnoughBalance,
                                          context: context)
                                      .showErrorSnackBar();
                                  return;
                                }
                                Navigator.of(AppRouter.mainContext).pushNamed(
                                    CalculateConvertCoinScreen.routName);
                              },
                        child: Text(
                          S.current.convert,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: !withConvert
                                        ? AppColors.grey
                                        : AppColors.secondary,
                                    fontSize: 13,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 60)
                ],
              ),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.of(AppRouter.mainContext)
                          .pushNamed(GoldCoinsDetailsScreen.routName),
                      child: Text(
                        S.current.whatIsLiftUpGoldCoins,
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 13, color: AppColors.secondary),
                      ),
                    ),
                  ),
                  SizedBox(width: 80)
                ],
              ),
            ],
          ),
          PositionedDirectional(
            end: 10,
            top: 0,
            child: Image.asset(
              Assets.assetsImagesGoldicon,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
    );
  }
}

class UpdatedLiftUpGoldCoinsWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final bool withConvert;

  const UpdatedLiftUpGoldCoinsWidget({
    Key? key,
    this.onTap,
    this.withConvert = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = context.read<AppConfigCubit>().getUser();
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 10, left: 15, right: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.orange.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(S.current.goldCoins,
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  InkWell(
                    onTap: onTap,
                    child: Text(S.current.dashboard,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.secondary, fontSize: 13)),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Divider(),
              SizedBox(height: 5),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3)),
                child: Row(
                  children: [
                    Expanded(
                      child: Text("${user.coins} ${S.current.coins}",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: AppColors.secondary, fontSize: 13)),
                    ),
                    Row(
                      children: [
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: InkWell(
                            onTap: !withConvert
                                ? null
                                : () {
                                    // print("object");
                                    if (double.parse(user.coins.toString()) <
                                        0) {
                                      //change for functional 100
                                      AppSnackBar(
                                              message:
                                                  S.current.noEnoughBalance,
                                              context: context)
                                          .showErrorSnackBar();
                                      return;
                                    }
                                    Navigator.of(AppRouter.mainContext)
                                        .pushNamed(
                                            CoinsConversionScreen.routName);
                                  },
                            child: Text(
                              S.current.convert,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: !withConvert
                                        ? AppColors.grey
                                        : AppColors.secondary,
                                    fontSize: 13,
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(AppRouter.mainContext)
                                  .pushNamed(BuyCoinsScreen.routName);
                            },
                            child: Text(
                              S.current.buyGold,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: AppColors.secondary,
                                    fontSize: 13,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // PositionedDirectional(
          //   end: 10,
          //   top: 0,
          //   child: Image.asset(
          //     Assets.assetsImagesGoldicon,
          //     width: 50,
          //     height: 50,
          //     fit: BoxFit.cover,
          //   ),
          // )
        ],
      ),
    );
  }
}
