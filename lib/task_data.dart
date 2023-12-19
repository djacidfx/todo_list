import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'db.dart';
import 'calendar_model.dart';
import 'package:intl/intl.dart';

class TaskData extends ChangeNotifier {
  List<dynamic> selectedEvents = [];
  Map<DateTime, List<dynamic>> events;
  List<CalendarItem> _data = [];

  Future<void> addEvent(
      String name,
      String description,
      DateTime selectedDate,
      TimeOfDay selectedTime,
      DateTime dateCreated,
      TimeOfDay timeCreated,
      int reminder) async {
    final dt = DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
        selectedTime.hour, selectedTime.minute);
    final dtNow = DateTime(dateCreated.year, dateCreated.month, dateCreated.day,
        timeCreated.hour, timeCreated.minute);

    final format = DateFormat.jm();
    CalendarItem item = CalendarItem(
      date: selectedDate.toString(),
      name: name,
      description: description,
      reminder: reminder,
      time: format.format(dt),
      status: 0,
      dateCreated: dateCreated.toString(),
      timeCreated: format.format(dtNow),
    );
    await DB.insert(CalendarItem.table, item);
    selectedEvents.add(item);
    fetchEvents();
    notifyListeners();
  }

  void updateEvent(
      String name,
      String description,
      DateTime selectedDate,
      TimeOfDay selectedTime,
      String status,
      CalendarItem cItem,
      int reminder) async {
    final dt = DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
        selectedTime.hour, selectedTime.minute);
    final format = DateFormat.jm();

    CalendarItem item = CalendarItem(
        date: selectedDate.toString(),
        name: name,
        description: description,
        reminder: reminder,
        dateCreated: cItem.dateCreated,
        timeCreated: cItem.timeCreated,
        time: format.format(dt),
        status: status == 'In Progress' ? 0 : 1);
    item.id = cItem.id;
    await DB.update(CalendarItem.table, item);
    selectedEvents.replaceRange(
        selectedEvents.indexWhere((element) => element.id == item.id),
        selectedEvents.indexWhere((element) => element.id == item.id) + 1,
        [item]);
    fetchEvents();
    notifyListeners();
  }

  void markComplete(CalendarItem cItem) async {
    DateTime formattedDate = DateTime.parse(
        DateFormat('yyyy-MM-dd').format(DateTime.parse(cItem.date)));
    DateTime completionDate =
        DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    final dt = DateTime(
        formattedDate.year,
        formattedDate.month,
        formattedDate.day,
        TimeOfDay.fromDateTime(DateFormat.jm().parse(cItem.time)).hour,
        TimeOfDay.fromDateTime(DateFormat.jm().parse(cItem.time)).minute);
    final nowDt = DateTime(completionDate.year, completionDate.month,
        completionDate.day, TimeOfDay.now().hour, TimeOfDay.now().minute);
    final format = DateFormat.jm();

    CalendarItem item = CalendarItem(
        date: cItem.date,
        name: cItem.name,
        description: cItem.description,
        time: format.format(dt),
        reminder: cItem.reminder,
        status: 1,
        dateCreated: cItem.dateCreated,
        timeCreated: cItem.timeCreated,
        timeCompleted: format.format(nowDt),
        dateCompleted: completionDate.toString());
    item.id = cItem.id;
    await DB.update(CalendarItem.table, item);
    if (selectedEvents.isNotEmpty) {
      selectedEvents.replaceRange(
          selectedEvents.indexWhere((element) => element.id == item.id),
          selectedEvents.indexWhere((element) => element.id == item.id) + 1,
          [item]);
    }
    fetchEvents();
    notifyListeners();
  }

  void markPending(CalendarItem cItem) async {
    DateTime formattedDate = DateTime.parse(
        DateFormat('yyyy-MM-dd').format(DateTime.parse(cItem.date)));
    final dt = DateTime(
        formattedDate.year,
        formattedDate.month,
        formattedDate.day,
        TimeOfDay.fromDateTime(DateFormat.jm().parse(cItem.time)).hour,
        TimeOfDay.fromDateTime(DateFormat.jm().parse(cItem.time)).minute);
    final format = DateFormat.jm();

    CalendarItem item = CalendarItem(
      date: cItem.date,
      name: cItem.name,
      description: cItem.description,
      time: format.format(dt),
      reminder: cItem.reminder,
      status: 0,
      dateCreated: cItem.dateCreated,
      timeCreated: cItem.timeCreated,
    );
    item.id = cItem.id;
    await DB.update(CalendarItem.table, item);
    if (selectedEvents.isNotEmpty) {
      selectedEvents.replaceRange(
          selectedEvents.indexWhere((element) => element.id == item.id),
          selectedEvents.indexWhere((element) => element.id == item.id) + 1,
          [item]);
    }

    fetchEvents();
    notifyListeners();
  }

  void fetchEvents() async {
    events = {};
    List<Map<String, dynamic>> _results = await DB.query(CalendarItem.table);
    _data = _results.map((e) => CalendarItem.fromMap(e)).toList();
    _data.forEach((element) {
      DateTime formattedDate = DateTime.parse(DateFormat('yyyy-MM-dd')
          .format(DateTime.parse(element.date.toString())));
      var task = CalendarItem(
        id: element.id,
        name: element.name,
        description: element.description,
        reminder: element.reminder,
        date: element.date,
        time: element.time,
        status: element.status,
        dateCreated: element.dateCreated,
        timeCreated: element.timeCreated,
      );
      if (events.containsKey(formattedDate)) {
        events[formattedDate].add(task);
      } else {
        events[formattedDate] = [task];
      }
    });

    notifyListeners();
  }

  void deleteEvent(
    CalendarItem e,
  ) {
    List<CalendarItem> _event =
        _data.where((element) => element.id == e.id).toList();
    if (e.name.length != 0) {
      DB.delete(CalendarItem.table, _event[0]);
      selectedEvents.removeWhere((element) => e == e);
      fetchEvents();
    }
    notifyListeners();
  }

  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  bool available = true;
  StreamSubscription subscription;
  final String myProductID = 'life_time_purchase';
  final String myThirtyProductID = 'sub_monthly_30';
  final String myAnnualProductID = 'sub_annual_365';
  final String myIceCreamProductID = 'ice_cream';
  final String myCakeProductID = 'cake';
  final String myCoffeeProductID = 'coffee';
  final String myBurgerProductID = 'burger_meal';
  final String myDinnerProductID = 'dinner';

  bool _isPurchased = false;
  bool get isPurchased => _isPurchased;
  set isPurchased(bool value) {
    _isPurchased = value;
    notifyListeners();
  }

  List _purchases = [];
  List get purchases => _purchases;
  set purchases(List value) {
    _purchases = value;
    notifyListeners();
  }

  List<ProductDetails> _products = [];
  List get products => _products;
  set products(List value) {
    _products = value;
    notifyListeners();
  }

  // List _productsMonthly = [];
  // List get productsMonthly => _productsMonthly;
  // set productsMonthly(List value) {
  //   _productsMonthly = value;
  //   notifyListeners();
  // }
  //
  // List _productsAnnual = [];
  // List get productsAnnual => _productsAnnual;
  // set productsAnnual(List value) {
  //   _productsAnnual = value;
  //   notifyListeners();
  // }

  void initialize() async {
    available = await _iap.isAvailable();
    if (available) {
      await _getProducts();
      // await _getMonthlyProducts();
      // await _getAnnualProducts();
      await _getPastPurchases();
      verifyPurchase();
      subscription = _iap.purchaseUpdatedStream.listen((data) {
        purchases.addAll(data);
        verifyPurchase();
      });
    }
    SharedPreferences prefsTheme = await SharedPreferences.getInstance();
    themeStyle = prefsTheme.getString('themeStyleSaved') == null
        ? 'dark'
        : prefsTheme.getString('themeStyleSaved');
    SharedPreferences presProfileBadger = await SharedPreferences.getInstance();
    //TODO new theme 1
    profileBadger = presProfileBadger.getBool('profileBadgeSaved3');
    SharedPreferences presSettingsBadger =
        await SharedPreferences.getInstance();
    //TODO new theme 2
    settingsBadger = presSettingsBadger.getBool('settingsBadgeSaved3');
    SharedPreferences presStyleBadger = await SharedPreferences.getInstance();
    //TODO new theme 3
    styleBadger = presStyleBadger.getBool('styleBadgeSaved3');

    SharedPreferences presTaskBadger = await SharedPreferences.getInstance();
    taskBadger = presTaskBadger.getBool('taskBadgeSaved');
  }

  void verifyPurchase() {
    PurchaseDetails purchase = hasPurchased(myProductID);
    PurchaseDetails purchaseTwo = hasPurchased(myThirtyProductID);
    PurchaseDetails purchaseThree = hasPurchased(myAnnualProductID);
    PurchaseDetails purchaseFour = hasPurchased(myCakeProductID);
    PurchaseDetails purchaseFive = hasPurchased(myIceCreamProductID);
    PurchaseDetails purchaseSix = hasPurchased(myCoffeeProductID);
    PurchaseDetails purchaseSeven = hasPurchased(myBurgerProductID);
    PurchaseDetails purchaseEight = hasPurchased(myDinnerProductID);
    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
        isPurchased = true;
      }
    } else if (purchaseTwo != null &&
        purchaseTwo.status == PurchaseStatus.purchased) {
      if (purchaseTwo.pendingCompletePurchase) {
        _iap.completePurchase(purchaseTwo);
        isPurchased = true;
      }
    } else if (purchaseThree != null &&
        purchaseThree.status == PurchaseStatus.purchased) {
      if (purchaseThree.pendingCompletePurchase) {
        _iap.completePurchase(purchaseThree);
        isPurchased = true;
      }
    } else if (purchaseFour != null &&
        purchaseFour.status == PurchaseStatus.purchased) {
      if (purchaseFour.pendingCompletePurchase) {
        _iap.completePurchase(purchaseFour);
      }
    } else if (purchaseFive != null &&
        purchaseFive.status == PurchaseStatus.purchased) {
      if (purchaseFive.pendingCompletePurchase) {
        _iap.completePurchase(purchaseFive);
      }
    } else if (purchaseSix != null &&
        purchaseSix.status == PurchaseStatus.purchased) {
      if (purchaseSix.pendingCompletePurchase) {
        _iap.completePurchase(purchaseSix);
      }
    } else if (purchaseSeven != null &&
        purchaseSeven.status == PurchaseStatus.purchased) {
      if (purchaseSeven.pendingCompletePurchase) {
        _iap.completePurchase(purchaseSeven);
      }
    } else if (purchaseEight != null &&
        purchaseEight.status == PurchaseStatus.purchased) {
      if (purchaseEight.pendingCompletePurchase) {
        _iap.completePurchase(purchaseEight);
        isPurchased = true;
      }
    }
  }

  PurchaseDetails hasPurchased(String productID) {
    return purchases.firstWhere((purchase) => purchase.productID == productID,
        orElse: () => null);
  }

  Future<void> _getProducts() async {
    Set<String> ids = Set.from([
      myThirtyProductID,
      myAnnualProductID,
      myProductID,
      myIceCreamProductID,
      myCakeProductID,
      myCoffeeProductID,
      myBurgerProductID,
      myDinnerProductID,
    ]);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    _products = response.productDetails;
  }

  // Future<void> _getMonthlyProducts() async {
  //   Set<String> ids = Set.from([myThirtyProductID]);
  //   ProductDetailsResponse response = await _iap.queryProductDetails(ids);
  //   productsMonthly = response.productDetails;
  // }
  //
  // Future<void> _getAnnualProducts() async {
  //   Set<String> ids = Set.from([myAnnualProductID]);
  //   ProductDetailsResponse response = await _iap.queryProductDetails(ids);
  //   productsAnnual = response.productDetails;
  // }

  Future<void> _getPastPurchases() async {
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();
    for (PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        _iap.consumePurchase(purchase);
      }
    }
    purchases = response.pastPurchases;
  }

  String themeStyle;
  void toggleTheme(String isSelected) async {
    SharedPreferences prefsThemeStyle = await SharedPreferences.getInstance();
    //TODO new theme 2 add condition for string
    themeStyle = isSelected == 'light'
        ? 'light'
        : isSelected == 'crypto'
            ? 'crypto'
            : isSelected == 'nft'
                ? 'nft'
                : isSelected == 'greenArea'
                    ? 'greenArea'
                    : isSelected == 'swallow'
                        ? 'swallow'
                        : 'dark';
    prefsThemeStyle.setString('themeStyleSaved', themeStyle);
    notifyListeners();
  }

  bool profileBadger;
  void toggleBadge(bool badgerTapped) async {
    SharedPreferences presProfileBadger = await SharedPreferences.getInstance();
    profileBadger = badgerTapped;
    //TODO new theme 4
    presProfileBadger.setBool('profileBadgeSaved3', profileBadger);
    notifyListeners();
  }

  bool settingsBadger;
  void toggleSettings(bool badgerTapped) async {
    SharedPreferences presSettingsBadger =
        await SharedPreferences.getInstance();
    settingsBadger = badgerTapped;
    //TODO new theme 5
    presSettingsBadger.setBool('settingsBadgeSaved3', settingsBadger);
    notifyListeners();
  }

  bool styleBadger;
  void toggleStyle(bool badgerTapped) async {
    SharedPreferences presStyleBadger = await SharedPreferences.getInstance();
    styleBadger = badgerTapped;
    //TODO new theme 6
    presStyleBadger.setBool('styleBadgeSaved3', styleBadger);
    notifyListeners();
  }

  bool taskBadger;
  void toggleTask(bool badgerTapped) async {
    SharedPreferences presTaskBadger = await SharedPreferences.getInstance();
    taskBadger = badgerTapped;
    presTaskBadger.setBool('taskBadgeSaved', taskBadger);
    notifyListeners();
  }
}
