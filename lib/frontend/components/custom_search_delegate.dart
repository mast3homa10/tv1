import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../backend/network_constants.dart';
import '../../backend/api/currency_list_api.dart';
import '../../constants.dart';
import '../pages/exchange/exchange_page_controller.dart';
import '../../backend/models/currency_model.dart';

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate({
    this.currentBox = 0,
    this.hintText = 'جست و جو',
    this.inputStyle,
  }) : super(
          searchFieldDecorationTheme: inputStyle,
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );
  String hintText;
  int currentBox;
  InputDecorationTheme? inputStyle;
  List<CurrencyModel> searchResultsList = dataList;

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
        scaffoldBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        dividerTheme: Theme.of(context).dividerTheme,
        appBarTheme: AppBarTheme(
          color: Theme.of(context).appBarTheme.backgroundColor,
        ),
        textTheme: const TextTheme(
          headline1: TextStyle(fontFamily: 'Yekanbakh', fontSize: 45),
          headline2: TextStyle(fontFamily: 'Yekanbakh', fontSize: 30),
          headline3: TextStyle(fontFamily: 'Yekanbakh', fontSize: 20),
          headline4: TextStyle(fontFamily: 'Yekanbakh', fontSize: 18),
          headline5: TextStyle(fontFamily: 'Yekanbakh', fontSize: 16),
          button: TextStyle(fontFamily: 'Yekanbakh', fontSize: 20),
        ).apply(
          bodyColor: Theme.of(context).iconTheme.color,
          displayColor: Theme.of(context).iconTheme.color,
        ),
        iconTheme: Theme.of(context).iconTheme);
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          // ignore: deprecated_member_use
          icon: Icon(
            CupertinoIcons.multiply,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
        )
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: Icon(
          FontAwesomeIcons.arrowRight,
          color: Theme.of(context).iconTheme.color,
        ),
        onPressed: () => close(context, null), //colse searchbar
      );

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(
        query,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final exchangeController = Get.put(ExchangePageController());
    return FutureBuilder<List<CurrencyModel>?>(
        future: CurrencyListApi().getList(),
        builder: (context, snapShot) {
          List<CurrencyModel> suggestions = ((currentBox == 0
                      ? exchangeController.forSellList
                      : exchangeController.forBuyList) ??
                  searchResultsList)
              .where((searchResult) {
            final String userInput = query.toLowerCase();
            final String result = (searchResult.engName ?? '').toLowerCase() +
                (searchResult.faName ?? '').toLowerCase();

            return result.contains(userInput);
          }).toList();
          switch (snapShot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );

            default:
              return Column(
                children: [
                  SizedBox(
                    height: Get.height * 0.04,
                  ),
                  Expanded(
                    child: CupertinoScrollbar(
                      child: ListView.builder(
                          itemCount: suggestions.length,
                          itemBuilder: (context, index) {
                            final suggestion = suggestions[index];
                            return ListTile(
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      if (suggestion.inNetwork!.toLowerCase() !=
                                          suggestion.symbol!.toLowerCase())
                                        Container(
                                          width: (suggestion.inNetwork ?? '')
                                                  .length +
                                              50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: kNetworkColorList[
                                                      suggestion.inNetwork!
                                                          .toLowerCase()] ??
                                                  Colors.grey),
                                          child: Center(
                                            child: Text(
                                              suggestion.inNetwork ?? "test",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4,
                                            ),
                                          ),
                                        ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // currency network

                                            SizedBox(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    // currency name & symbol
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1.0),
                                                      child: Text(
                                                        " ${suggestion.faName} ( ${(suggestion.symbol ?? '').toUpperCase()} ) ",
                                                        maxLines: 1,
                                                        textWidthBasis:
                                                            TextWidthBasis
                                                                .longestLine,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline4,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            // image
                                            SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: SvgPicture.network(
                                                ('$imgUrl${suggestion.legacyTicker}.svg'),
                                                semanticsLabel: 'img',
                                                placeholderBuilder: (BuildContext
                                                        context) =>
                                                    Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child:
                                                            const CircularProgressIndicator()),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    thickness: 2,
                                  )
                                ],
                              ),
                              onTap: () {
                                if (currentBox == 1) {
                                  final controller =
                                      Get.put(ExchangePageController());
                                  query = suggestion.engName ?? "";
                                  controller.updateCurrencyChoice(
                                      currency: suggestion, item: currentBox);

                                  close(context, null);
                                } else {
                                  final controller =
                                      Get.put(ExchangePageController());
                                  query = suggestion.engName ?? "";
                                  controller.updateCurrencyChoice(
                                      currency: suggestion, item: currentBox);
                                  close(context, null);
                                }

                                // showResults(context);
                              },
                            );
                          }),
                    ),
                  ),
                ],
              );
          }
        });
  }
}
