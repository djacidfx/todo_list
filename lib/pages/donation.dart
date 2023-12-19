import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

import '../task_data.dart';

class Donation extends StatefulWidget {
  const Donation({Key key}) : super(key: key);

  @override
  State<Donation> createState() => _DonationState();
}

class _DonationState extends State<Donation> {
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  String iceCreamPrice;
  String cakePrice;
  String coffeePrice;
  String burgerPrice;
  String dinnerPrice;
  ProductDetails iceCreamProd;
  ProductDetails cakeProd;
  ProductDetails coffeeProd;
  ProductDetails burgerProd;
  ProductDetails dinnerProd;

  getPurchases() {
    final provider = Provider.of<TaskData>(context, listen: false);
    for (ProductDetails prod in provider.products) {
      if (provider.hasPurchased(prod.id) != null) {
        if (prod.id == 'ice_cream') {
          setState(() {
            iceCreamPrice = '';
            cakePrice = '';
            coffeePrice = '';
            burgerPrice = '';
            dinnerPrice = '';
          });
        }
      } else {
        if (prod.id == 'ice_cream') {
          setState(() {
            iceCreamPrice = prod.price;
            iceCreamProd = prod;
          });
        } else if (prod.id == 'cake') {
          setState(() {
            cakeProd = prod;
            cakePrice = prod.price;
          });
        } else if (prod.id == 'coffee') {
          setState(() {
            coffeeProd = prod;
            coffeePrice = prod.price;
          });
        } else if (prod.id == 'burger_meal') {
          setState(() {
            burgerProd = prod;
            burgerPrice = prod.price;
          });
        } else if (prod.id == 'dinner') {
          setState(() {
            dinnerProd = prod;
            dinnerPrice = prod.price;
          });
        }
      }
    }
  }

  @override
  void initState() {
    getPurchases();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff030455),
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Color(0xff030455).withOpacity(0.9),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Support ToDo List Team ❤️',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'This is a donation page you. You could treat us with a '
                'meal or a cup of coffee here. We will be really '
                'grateful🤗 for your kind encouragement. Anyway, '
                'we feel grateful🙏 to you whether you donate or not.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Divider(),
              ListTile(
                title: Text(
                  'Ice Cream',
                  //TODO new theme 3
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  '$iceCreamPrice',
                  style: TextStyle(color: Colors.white70),
                ),
                leading: Icon(
                  Icons.icecream,
                  color: Colors.blue,
                ),
                onTap: () {
                  _buyProduct(iceCreamProd);
                },
              ),
              ListTile(
                title: Text(
                  'Cake',
                  //TODO new theme 3
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  '$cakePrice',
                  style: TextStyle(color: Colors.white70),
                ),
                leading: Icon(
                  Icons.cake_outlined,
                  color: Colors.yellowAccent,
                ),
                onTap: () {
                  _buyProduct(cakeProd);
                },
              ),
              ListTile(
                title: Text(
                  'Coffee',
                  //TODO new theme 3
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  '$coffeePrice',
                  style: TextStyle(color: Colors.white70),
                ),
                leading: Icon(
                  Icons.coffee,
                  color: Colors.greenAccent,
                ),
                onTap: () {
                  _buyProduct(coffeeProd);
                },
              ),
              ListTile(
                title: Text(
                  'Burger Meal',
                  //TODO new theme 3
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  '$burgerPrice',
                  style: TextStyle(color: Colors.white70),
                ),
                leading: Icon(
                  Icons.lunch_dining,
                  color: Colors.orangeAccent,
                ),
                onTap: () {
                  _buyProduct(burgerProd);
                },
              ),
              ListTile(
                title: Text(
                  'Dinner',
                  //TODO new theme 3
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  '$dinnerPrice',
                  style: TextStyle(color: Colors.white70),
                ),
                leading: Icon(
                  Icons.dinner_dining,
                  color: Colors.pinkAccent,
                ),
                onTap: () {
                  _buyProduct(dinnerProd);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
