import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:date_count_down/date_count_down.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/task_data.dart';

class Purchases extends StatefulWidget {
  @override
  _PurchasesState createState() => _PurchasesState();
}

class _PurchasesState extends State<Purchases> {
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  String monthlyPrice;
  String annualPrice;
  String lifeTimePrice;
  double lifeTimeRawPrice;
  double lifeTimeMidRawPrice;
  String lifeTimeCurrency;
  ProductDetails annualProd;
  ProductDetails monthProd;
  ProductDetails lifeProd;

  getMonthlyPurchases() {
    final provider = Provider.of<TaskData>(context, listen: false);
    for (ProductDetails prod in provider.products) {
      if (provider.hasPurchased(prod.id) != null) {
        if (prod.id == 'sub_monthly_30') {
          setState(() {
            monthlyPrice = '';
            annualPrice = '';
            lifeTimePrice = '';
          });
        }
      } else {
        if (prod.id == 'sub_monthly_30') {
          setState(() {
            monthlyPrice = prod.price;
            monthProd = prod;
          });
        } else if (prod.id == 'sub_annual_365') {
          setState(() {
            annualProd = prod;
            annualPrice = prod.price;
          });
        } else {
          setState(() {
            lifeTimePrice = prod.price;
            lifeProd = prod;
            lifeTimeRawPrice = prod.rawPrice * 2;
            lifeTimeMidRawPrice = prod.rawPrice * 5;
            lifeTimeCurrency = prod.currencyCode;
          });
        }
      }
    }
  }

  @override
  void initState() {
    getMonthlyPurchases();
    super.initState();
    _today = DateTime.now();
    getLastDay();
  }

  List<int> couponNumber = [
    98,
    89,
    82,
    66,
    55,
    49,
    46,
    43,
    37,
    32,
    26,
    20,
    17,
    15,
    14,
    13,
    12,
    11,
    8,
    5,
    3,
    0
  ];
  List<int> voucherNumber = [
    686,
    623,
    574,
    462,
    385,
    343,
    322,
    301,
    257,
    224,
    182,
    140,
    119,
    105,
    98,
    91,
    84,
    77,
    56,
    35,
    21,
    3
  ];
  DateTime _today;
  int _lastDay;
  DateTime _endOfMonth;
  DateTime _threeDaysBeforeEnd;
  DateTime _midMonth;
  DateTime _midMonthOne;
  DateTime _midMonthTwo;
  DateTime _midMonthThree;
  DateTime _midMonthFour;
  DateTime _midMonthFive;
  DateTime _midMonthSix;
  DateTime _midMonthSeven;
  DateTime _midMonthEight;
  DateTime _midMonthNine;
  DateTime _midMonthTen;
  DateTime _midMonthEleven;
  DateTime _midMonthTwelve;
  DateTime _midMonthThirteen;
  DateTime _midMonthFourteen;
  DateTime _midMonthFifteen;
  DateTime _midMonthSixteen;
  DateTime _midMonthSeventeen;
  DateTime _midMonthEighteen;
  DateTime _midMonthNineteen;
  DateTime _midMonthTwenty;
  DateTime _midMonthTwentyOne;
  DateTime _midMonthTwentyTwo;
  DateTime _midMonthPlusOne;
  DateTime endMonthOne;
  DateTime endMonthTwo;
  DateTime endMonthThree;
  DateTime endMonthFour;
  DateTime endMonthFive;
  DateTime endMonthSix;
  DateTime endMonthSeven;
  DateTime endMonthEight;
  DateTime endMonthNine;
  DateTime endMonthTen;
  DateTime endMonthEleven;
  DateTime endMonthTwelve;
  DateTime endMonthThirteen;
  DateTime endMonthFourteen;
  DateTime endMonthFifteen;
  DateTime endMonthSixteen;
  DateTime endMonthSevenTeen;
  DateTime endMonthEighteen;
  DateTime endMonthNineTeen;
  DateTime endMonthTwenty;
  DateTime endMonthTwentyOne;

  getLastDay() {
    _lastDay = DateTime(_today.year, _today.month + 1, 0, 0, 0, 0).day;
    _endOfMonth = DateTime(_today.year, _today.month, _lastDay).toUtc();
    _midMonth = DateTime(_today.year, _today.month, 15).toUtc();
    _midMonthPlusOne = _midMonth.add(Duration(days: 1));
    _midMonthOne = _midMonth.add(Duration(hours: 1));
    _midMonthTwo = _midMonth.add(Duration(hours: 2));
    _midMonthThree = _midMonth.add(Duration(hours: 3));
    _midMonthFour = _midMonth.add(Duration(hours: 4));
    _midMonthFive = _midMonth.add(Duration(hours: 5));
    _midMonthSix = _midMonth.add(Duration(hours: 6));
    _midMonthSeven = _midMonth.add(Duration(hours: 7));
    _midMonthEight = _midMonth.add(Duration(hours: 8));
    _midMonthNine = _midMonth.add(Duration(hours: 9));
    _midMonthTen = _midMonth.add(Duration(hours: 10));
    _midMonthEleven = _midMonth.add(Duration(hours: 11));
    _midMonthTwelve = _midMonth.add(Duration(hours: 12));
    _midMonthThirteen = _midMonth.add(Duration(hours: 13));
    _midMonthFourteen = _midMonth.add(Duration(hours: 14));
    _midMonthFifteen = _midMonth.add(Duration(hours: 15));
    _midMonthSixteen = _midMonth.add(Duration(hours: 16));
    _midMonthSeventeen = _midMonth.add(Duration(hours: 17));
    _midMonthEighteen = _midMonth.add(Duration(hours: 18));
    _midMonthNineteen = _midMonth.add(Duration(hours: 19));
    _midMonthTwenty = _midMonth.add(Duration(hours: 20));
    _midMonthTwentyOne = _midMonth.add(Duration(hours: 21));
    _midMonthTwentyTwo = _midMonth.add(Duration(hours: 22));
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskData>(context);
    _threeDaysBeforeEnd = _endOfMonth.subtract(Duration(days: 3));
    endMonthOne = _endOfMonth.subtract(Duration(hours: 23));
    endMonthTwo = _endOfMonth.subtract(Duration(hours: 22));
    endMonthThree = _endOfMonth.subtract(Duration(hours: 21));
    endMonthFour = _endOfMonth.subtract(Duration(hours: 20));
    endMonthFive = _endOfMonth.subtract(Duration(hours: 19));
    endMonthSix = _endOfMonth.subtract(Duration(hours: 18));
    endMonthSeven = _endOfMonth.subtract(Duration(hours: 17));
    endMonthEight = _endOfMonth.subtract(Duration(hours: 16));
    endMonthNine = _endOfMonth.subtract(Duration(hours: 15));
    endMonthTen = _endOfMonth.subtract(Duration(hours: 14));
    endMonthEleven = _endOfMonth.subtract(Duration(hours: 13));
    endMonthTwelve = _endOfMonth.subtract(Duration(hours: 12));
    endMonthThirteen = _endOfMonth.subtract(Duration(hours: 11));
    endMonthFourteen = _endOfMonth.subtract(Duration(hours: 10));
    endMonthFifteen = _endOfMonth.subtract(Duration(hours: 9));
    endMonthSixteen = _endOfMonth.subtract(Duration(hours: 8));
    endMonthSevenTeen = _endOfMonth.subtract(Duration(hours: 7));
    endMonthEighteen = _endOfMonth.subtract(Duration(hours: 6));
    endMonthNineTeen = _endOfMonth.subtract(Duration(hours: 5));
    endMonthTwenty = _endOfMonth.subtract(Duration(hours: 4));
    endMonthTwentyOne = _endOfMonth.subtract(Duration(hours: 3));
    bool _todayGreaterThan = _threeDaysBeforeEnd.compareTo(_today) <= 0;
    bool _todayLessThan = _endOfMonth.compareTo(_today) >= 0;
    String _offerDoublePrice = '$lifeTimeCurrency $lifeTimeRawPrice';
    String _offerCouponPrice = '$lifeTimeCurrency $lifeTimeMidRawPrice';
    bool _todayGreaterThanMid = _midMonth.compareTo(_today) <= 0;
    bool _todayLessThanMid = _midMonthPlusOne.compareTo(_today) >= 0;
    bool nowGreaterThanEndOne = endMonthOne.compareTo(_today) >= 0;
    bool nowGreaterThanEndTwo = endMonthTwo.compareTo(_today) >= 0;
    bool nowGreaterThanEndThree = endMonthThree.compareTo(_today) >= 0;
    bool nowGreaterThanEndFour = endMonthFour.compareTo(_today) >= 0;
    bool nowGreaterThanEndFive = endMonthFive.compareTo(_today) >= 0;
    bool nowGreaterThanEndSix = endMonthSix.compareTo(_today) >= 0;
    bool nowGreaterThanEndSeven = endMonthSeven.compareTo(_today) >= 0;
    bool nowGreaterThanEndEight = endMonthEight.compareTo(_today) >= 0;
    bool nowGreaterThanEndNine = endMonthNine.compareTo(_today) >= 0;
    bool nowGreaterThanEndTen = endMonthTen.compareTo(_today) >= 0;
    bool nowGreaterThanEndEleven = endMonthEleven.compareTo(_today) >= 0;
    bool nowGreaterThanEndTwelve = endMonthTwelve.compareTo(_today) >= 0;
    bool nowGreaterThanEndThirteen = endMonthThirteen.compareTo(_today) >= 0;
    bool nowGreaterThanEndFourteen = endMonthFourteen.compareTo(_today) >= 0;
    bool nowGreaterThanEndFifteen = endMonthFifteen.compareTo(_today) >= 0;
    bool nowGreaterThanEndSixteen = endMonthSixteen.compareTo(_today) >= 0;
    bool nowGreaterThanEndSeventeen = endMonthSevenTeen.compareTo(_today) >= 0;
    bool nowGreaterThanEndEighteen = endMonthEighteen.compareTo(_today) >= 0;
    bool nowGreaterThanEndNineteen = endMonthNineTeen.compareTo(_today) >= 0;
    bool nowGreaterThanEndTwenty = endMonthTwenty.compareTo(_today) >= 0;
    bool nowGreaterThanEndTwentyOne = endMonthTwentyOne.compareTo(_today) >= 0;

    bool _nowGreaterThanMidOne = _midMonthOne.compareTo(_today) >= 0;
    bool _nowGreaterThanMidTwo = _midMonthTwo.compareTo(_today) >= 0;
    bool _nowGreaterThanMidThree = _midMonthThree.compareTo(_today) >= 0;
    bool _nowGreaterThanMidFour = _midMonthFour.compareTo(_today) >= 0;
    bool _nowGreaterThanMidFive = _midMonthFive.compareTo(_today) >= 0;
    bool _nowGreaterThanMidSix = _midMonthSix.compareTo(_today) >= 0;
    bool _nowGreaterThanMidSeven = _midMonthSeven.compareTo(_today) >= 0;
    bool _nowGreaterThanMidEight = _midMonthEight.compareTo(_today) >= 0;
    bool _nowGreaterThanMidNine = _midMonthNine.compareTo(_today) >= 0;
    bool _nowGreaterThanMidTen = _midMonthTen.compareTo(_today) >= 0;
    bool _nowGreaterThanMidEleven = _midMonthEleven.compareTo(_today) >= 0;
    bool _nowGreaterThanMidTwelve = _midMonthTwelve.compareTo(_today) >= 0;
    bool _nowGreaterThanMidThirteen = _midMonthThirteen.compareTo(_today) >= 0;
    bool _nowGreaterThanMidFourteen = _midMonthFourteen.compareTo(_today) >= 0;
    bool _nowGreaterThanMidFifteen = _midMonthFifteen.compareTo(_today) >= 0;
    bool _nowGreaterThanMidSixteen = _midMonthSixteen.compareTo(_today) >= 0;
    bool _nowGreaterThanMidSeventeen =
        _midMonthSeventeen.compareTo(_today) >= 0;
    bool _nowGreaterThanMidEighteen = _midMonthEighteen.compareTo(_today) >= 0;
    bool _nowGreaterThanMidNineteen = _midMonthNineteen.compareTo(_today) >= 0;
    bool _nowGreaterThanMidTwenty = _midMonthTwenty.compareTo(_today) >= 0;
    bool _nowGreaterThanMidTwentyOne =
        _midMonthTwentyOne.compareTo(_today) >= 0;
    int _voucherNum = nowGreaterThanEndOne
        ? voucherNumber[0]
        : nowGreaterThanEndTwo
            ? voucherNumber[1]
            : nowGreaterThanEndThree
                ? voucherNumber[2]
                : nowGreaterThanEndFour
                    ? voucherNumber[3]
                    : nowGreaterThanEndFive
                        ? voucherNumber[4]
                        : nowGreaterThanEndSix
                            ? voucherNumber[5]
                            : nowGreaterThanEndSeven
                                ? voucherNumber[6]
                                : nowGreaterThanEndEight
                                    ? voucherNumber[7]
                                    : nowGreaterThanEndNine
                                        ? voucherNumber[8]
                                        : nowGreaterThanEndTen
                                            ? voucherNumber[9]
                                            : nowGreaterThanEndEleven
                                                ? voucherNumber[10]
                                                : nowGreaterThanEndTwelve
                                                    ? voucherNumber[11]
                                                    : nowGreaterThanEndThirteen
                                                        ? voucherNumber[12]
                                                        : nowGreaterThanEndFourteen
                                                            ? voucherNumber[13]
                                                            : nowGreaterThanEndFifteen
                                                                ? voucherNumber[
                                                                    14]
                                                                : nowGreaterThanEndSixteen
                                                                    ? voucherNumber[
                                                                        15]
                                                                    : nowGreaterThanEndSeventeen
                                                                        ? voucherNumber[
                                                                            16]
                                                                        : nowGreaterThanEndEighteen
                                                                            ? voucherNumber[17]
                                                                            : nowGreaterThanEndNineteen
                                                                                ? voucherNumber[18]
                                                                                : nowGreaterThanEndTwenty
                                                                                    ? voucherNumber[19]
                                                                                    : nowGreaterThanEndTwentyOne
                                                                                        ? voucherNumber[20]
                                                                                        : voucherNumber[21];
    int _couponNum = _nowGreaterThanMidOne
        ? couponNumber[0]
        : _nowGreaterThanMidTwo
            ? couponNumber[1]
            : _nowGreaterThanMidThree
                ? couponNumber[2]
                : _nowGreaterThanMidFour
                    ? couponNumber[3]
                    : _nowGreaterThanMidFive
                        ? couponNumber[4]
                        : _nowGreaterThanMidSix
                            ? couponNumber[5]
                            : _nowGreaterThanMidSeven
                                ? couponNumber[6]
                                : _nowGreaterThanMidEight
                                    ? couponNumber[7]
                                    : _nowGreaterThanMidNine
                                        ? couponNumber[8]
                                        : _nowGreaterThanMidTen
                                            ? couponNumber[9]
                                            : _nowGreaterThanMidEleven
                                                ? couponNumber[10]
                                                : _nowGreaterThanMidTwelve
                                                    ? couponNumber[11]
                                                    : _nowGreaterThanMidThirteen
                                                        ? couponNumber[12]
                                                        : _nowGreaterThanMidFourteen
                                                            ? couponNumber[13]
                                                            : _nowGreaterThanMidFifteen
                                                                ? couponNumber[
                                                                    14]
                                                                : _nowGreaterThanMidSixteen
                                                                    ? couponNumber[
                                                                        15]
                                                                    : _nowGreaterThanMidSeventeen
                                                                        ? couponNumber[
                                                                            16]
                                                                        : _nowGreaterThanMidEighteen
                                                                            ? couponNumber[17]
                                                                            : _nowGreaterThanMidNineteen
                                                                                ? couponNumber[18]
                                                                                : _nowGreaterThanMidTwenty
                                                                                    ? couponNumber[19]
                                                                                    : _nowGreaterThanMidTwentyOne
                                                                                        ? couponNumber[20]
                                                                                        : couponNumber[21];

    return Scaffold(
      backgroundColor:
          provider.themeStyle == 'dark' ? Color(0xff050736) : Color(0xff4C4D4F),
      //TODO put back !
      body: !provider.isPurchased
          ? SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: provider.themeStyle == 'dark'
                      ? LinearGradient(colors: [
                          Color(0xff050736),
                          Color(0xff080C3D),
                          Color(0xff010028),
                        ])
                      : LinearGradient(colors: [
                          Color(0xff211F2A),
                          Color(0xff313137),
                          Color(0xff4C4D4F),
                        ]),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _todayLessThanMid && _todayGreaterThanMid ||
                                    _todayLessThan && _todayGreaterThan
                                ? Icons.emoji_emotions_outlined
                                : Icons.beach_access_outlined,
                            size: 35,
                            color: Colors.yellowAccent,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Flexible(
                            child: Text(
                              _todayLessThan && _todayGreaterThan
                                  ? 'Loyal User Appreciation'
                                  : _todayLessThanMid && _todayGreaterThanMid
                                      ? '80% OFF Lifetime Coupons for 100 lucky users'
                                      : 'live a better day',
                              style: TextStyle(
                                color: Colors.yellowAccent,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.all_inclusive,
                        color: Color(0xffBCFE3A),
                      ),
                      title: Text(
                        'Unlimited Tasks',
                        style: TextStyle(color: Color(0xff41CAAC)),
                      ),
                      subtitle: Text(
                        'Remove restrictions on the maximum number of tasks '
                        'you can create.',
                        style: TextStyle(color: Color(0xff3887BB)),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.insights,
                        color: Color(0xffBCFE3A),
                      ),
                      title: Text(
                        'Task Insights',
                        style: TextStyle(color: Color(0xff41CAAC)),
                      ),
                      subtitle: Text(
                        'View all your results and performance statistics',
                        style: TextStyle(color: Color(0xff3887BB)),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.star_rate,
                        color: Color(0xffBCFE3A),
                      ),
                      title: Text(
                        'Achievements',
                        style: TextStyle(color: Color(0xff41CAAC)),
                      ),
                      subtitle: Text(
                        'Stay ahead by knowing what you have accomplished and be motivated for the next tasks',
                        style: TextStyle(color: Color(0xff3887BB)),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.block,
                        color: Color(0xffBCFE3A),
                      ),
                      title: Text(
                        'No Ads',
                        style: TextStyle(color: Color(0xff41CAAC)),
                      ),
                      subtitle: Text(
                        'Get Rid of All those banners and Videos when you '
                        'open the app',
                        style: TextStyle(color: Color(0xff3887BB)),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.palette_outlined,
                        color: Color(0xffBCFE3A),
                      ),
                      title: Text(
                        'Enjoy all themes',
                        style: TextStyle(color: Color(0xff41CAAC)),
                      ),
                      subtitle: Text(
                        'Enhance the quality of your experience',
                        style: TextStyle(color: Color(0xff3887BB)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          _todayLessThanMid && _todayGreaterThanMid
                              ? _midMonthTwentyTwo.compareTo(_today) <= 0
                                  ? 'Sold Out'
                                  : 'Only ${_couponNum.toString()} coupons remaining'
                              : _todayLessThan && _todayGreaterThan
                                  ? 'Limited Time to become part of 12,345 high achievers like you. 89% of them became 3 times productive after using all our tools.'
                                  : 'Join 12,345+ high achievers like you using this tools to track performance.'
                                      '89% of premium subscribers had better control of their day after using our tools',
                          style: TextStyle(
                            color: _todayLessThanMid && _todayGreaterThanMid
                                ? Color(0xffC62AFB)
                                : Colors.yellowAccent,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    monthlyPrice == null
                        ? Container(
                            margin: const EdgeInsets.all(16.0),
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                            decoration: BoxDecoration(
                                color: Color(0xffE6ECEB),
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(Icons.wifi_off),
                                  Text(
                                    'You are Offline',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      'Make Sure that Wi-Fi or Mobile data is turned on, then try again'),
                                  TextButton(
                                    onPressed: () {
                                      getMonthlyPurchases();
                                      provider.initialize();
                                    },
                                    child: Text(
                                      'RETRY',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                padding: const EdgeInsets.all(16.0),
                                width: 100,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      Color(0xffAEF846),
                                      Color(0xff51C88C),
                                      Color(0xff059AB8)
                                    ]),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: Text(
                                        'Monthly',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text('$monthlyPrice',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text('Billed Monthly',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 10.0,
                                          )),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _buyProduct(monthProd);
                                      },
                                      child: Text(
                                        'Continue',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.all(0),
                                        backgroundColor: Color(0xff786DFD),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    alignment: Alignment.topCenter,
                                    height: 20,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        color: Color(0xffBDFF37),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10))),
                                    child: Center(
                                      child: Text(
                                        'Save 50%',
                                        style: TextStyle(
                                            fontSize: 10, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    padding: const EdgeInsets.all(16.0),
                                    width: 100,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          Color(0xff9EA8FE),
                                          Color(0xff7793FF)
                                        ]),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 2.0),
                                          child: Text(
                                            'Not Sure?',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2.0),
                                          child: Text('Free',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2.0),
                                          child: Text('3-day trial',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.0,
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Text(
                                              'After trial pay $annualPrice per year',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.0,
                                              )),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _buyProduct(annualProd);
                                          },
                                          style: TextButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.all(8),
                                            backgroundColor: Color(0xffFFAD27),
                                          ),
                                          child: Text(
                                            'Start Now',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  _todayLessThan && _todayGreaterThan
                                      ? Container(
                                          alignment: Alignment.topCenter,
                                          height: 20,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: Color(0xffFFD700),
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10))),
                                          child: Center(
                                            child: DefaultTextStyle(
                                              style: TextStyle(
                                                fontSize: 10.0,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.black,
                                              ),
                                              child: AnimatedTextKit(
                                                isRepeatingAnimation: true,
                                                animatedTexts: [
                                                  RotateAnimatedText(
                                                    'BIG SAVE',
                                                  ),
                                                  TyperAnimatedText('50% OFF',
                                                      speed: Duration(
                                                          milliseconds: 100)),
                                                  FadeAnimatedText(
                                                    'Claim Now',
                                                    duration:
                                                        Duration(seconds: 3),
                                                    fadeOutBegin: 0.9,
                                                    fadeInEnd: 0.7,
                                                  ),
                                                  ScaleAnimatedText(
                                                      'Last Chance',
                                                      scalingFactor: 0.2),
                                                  TyperAnimatedText('50% OFF',
                                                      speed: Duration(
                                                          milliseconds: 100)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : _todayGreaterThanMid &&
                                              _todayLessThanMid
                                          ? Container(
                                              alignment: Alignment.topCenter,
                                              height: 20,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                  color: Color(0xffFED902),
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10))),
                                              child: Center(
                                                child: Text(
                                                  '80% off Coupon',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    padding: const EdgeInsets.all(16.0),
                                    width: 110,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xffF3158D),
                                            Color(0xffBE288B),
                                            Color(0xff91369A)
                                          ],
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 16.0),
                                          child: Text(
                                            'Life Time',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Column(
                                            children: [
                                              _todayGreaterThan &&
                                                      _todayLessThan
                                                  ? Text('$_offerDoublePrice',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough))
                                                  : _todayGreaterThanMid &&
                                                          _todayLessThanMid
                                                      ? Text(
                                                          '$_offerCouponPrice',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough))
                                                      : Container(),
                                              Text('$lifeTimePrice',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              _todayGreaterThan &&
                                                      _todayLessThan
                                                  ? Column(
                                                      children: [
                                                        Text(
                                                          'Ends in ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10),
                                                        ),
                                                        CountDownText(
                                                          due: _endOfMonth,
                                                          finishedText:
                                                              'Expired',
                                                          showLabel: true,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10),
                                                        ),
                                                      ],
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Text('Billed Once',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.0,
                                              )),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _buyProduct(lifeProd);
                                          },
                                          child: Text(
                                            _todayLessThan &&
                                                        _todayGreaterThan ||
                                                    _todayGreaterThanMid &&
                                                        _todayLessThanMid
                                                ? 'Buy Now'
                                                : 'Continue',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10),
                                          ),
                                          style: TextButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.all(0),
                                            backgroundColor: Color(0xffFEEE00),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _todayGreaterThanMid && _todayLessThanMid
                                      ? Container(
                                          alignment: Alignment.topCenter,
                                          height: 20,
                                          width: 80,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10))),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  _midMonthTwentyTwo.compareTo(
                                                              _today) <=
                                                          0
                                                      ? 'Sold Out'
                                                      : '${_couponNum.toString()} coupons Left',
                                                  style: TextStyle(
                                                      fontSize: 8,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            )
          : Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                gradient: provider.themeStyle == 'dark'
                    ? LinearGradient(colors: [
                        Color(0xff050736),
                        Color(0xff080C3D),
                        Color(0xff010028),
                      ])
                    : LinearGradient(colors: [
                        Color(0xff211F2A),
                        Color(0xff313137),
                        Color(0xff4C4D4F),
                      ]),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.emoji_emotions_outlined,
                          size: 35,
                          color: Colors.yellowAccent,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Success',
                          style: TextStyle(
                            color: Colors.yellowAccent,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.next_plan_outlined,
                          size: 35,
                          color: Colors.yellowAccent,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          children: [
                            Text(
                              'How to get Maximum Value from your',
                              style: TextStyle(
                                color: Colors.yellowAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Premium Subscription',
                              style: TextStyle(
                                color: Colors.yellowAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.all_inclusive,
                      color: Color(0xffBCFE3A),
                    ),
                    title: Text(
                      'Schedule Everything',
                      style: TextStyle(color: Color(0xff41CAAC)),
                    ),
                    subtitle: Text(
                      'Relieve yourself from the anxiety of having to remember everything '
                      'and free your mind for other creative tasks',
                      style: TextStyle(color: Color(0xff3887BB)),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.insights,
                      color: Color(0xffBCFE3A),
                    ),
                    title: Text(
                      'Track All Achievements and Task Details',
                      style: TextStyle(color: Color(0xff41CAAC)),
                    ),
                    subtitle: Text(
                      'This will help you uncover what you don\'t see at first '
                      'glance and force your brain think in depth about '
                      'completing tasks. You may see things you missed at first, '
                      'growing your capacity to achieve good results',
                      style: TextStyle(color: Color(0xff3887BB)),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.star_rate,
                      color: Color(0xffBCFE3A),
                    ),
                    title: Text(
                      'Always check how many badges you have and your skill level',
                      style: TextStyle(color: Color(0xff41CAAC)),
                    ),
                    subtitle: Text(
                      'Succesful completion of tasks indicates progress. Earning badges and '
                      'moving up a skill level represents milestones and communicates you are succeeding.',
                      style: TextStyle(color: Color(0xff3887BB)),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.question_answer_outlined,
                      color: Color(0xffBCFE3A),
                    ),
                    title: Text(
                      'Ask for Feedback',
                      style: TextStyle(color: Color(0xff41CAAC)),
                    ),
                    subtitle: Text(
                      'In case of any challenges, you can contact us at the feedback  '
                      'section under settings and one of our experts will be in touch to assist you.',
                      style: TextStyle(color: Color(0xff3887BB)),
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 35,
                          color: Colors.yellowAccent,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          children: [
                            Text(
                              'Thank You',
                              style: TextStyle(
                                color: Colors.yellowAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Your contribution helps support us to continue',
                              style: TextStyle(
                                color: Colors.yellowAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'developing more exciting features',
                              style: TextStyle(
                                color: Colors.yellowAccent,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
