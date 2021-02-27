import 'package:barcode_scan/barcode_scan.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fitnessfriend/Events/add_food.dart';
import 'package:fitnessfriend/foodForm.dart';
import 'package:fitnessfriend/foodList.dart';
import 'package:fitnessfriend/model/Food.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openfoodfacts/model/OcrIngredientsResult.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fitnessfriend/WorkoutPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'bloc/food_bloc.dart';
import 'database_helper.dart';
import 'editFoodForm.dart';

class FoodLog extends StatefulWidget {
  final int uid;

  FoodLog(this.uid);

  @override
  _FoodLogState createState() => _FoodLogState();
}

class _FoodLogState extends State<FoodLog> {


  String barcodeResult;
  String foodName;
  double foodCals;
  double foodProtien;
  double foodFat;
  double foodCarbs;
  double servingSize;
  var userCarbs;
  var userCals;
  var userCalsLeft;
  var userProtein;
  var userFat;
  double progress;


  getProgress(){
    progress = userCals ~/ userCalsLeft;
    print("progress");
    return progress;
  }


  getCarbs() async {
    userCarbs = await DatabaseHelper.instance.getUserCarbs(widget.uid);
  }

  getCals() async {
    userCals = await DatabaseHelper.instance.getUserCals(widget.uid);
  }

  getCalsLeft() async {
    userCalsLeft = await DatabaseHelper.instance.getUserCals(widget.uid);
  }


  getProtein() async {
    userProtein = await DatabaseHelper.instance.getUserProtein(widget.uid);
  }

  getFat() async {
    userFat = await DatabaseHelper.instance.getUserFat(widget.uid);
  }


  Future _scanBarcode() async {
    try {
      String barcodeScanning = await BarcodeScanner.scan();
      setState(() {
        barcodeResult = barcodeScanning;
        print("$barcodeResult");
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          barcodeResult = "Camera permission denied";
        });
      } else {
        setState(() {
          barcodeResult = "Unkown Error: $ex";
        });
      }
    } on FormatException {
      setState(() {
        barcodeResult = "Scanning was cancelled";
      });
    } catch (ex) {
      setState(() {
        barcodeResult = "Unkown Error: $ex";
      });
    }
  }

  /// request a product from the OpenFoodFacts database
  Future<Product> getProduct(String barcodeNum) async {
    var barcode = barcodeNum;
    ProductQueryConfiguration configuration = ProductQueryConfiguration(barcode,
        language: OpenFoodFactsLanguage.ENGLISH, fields: [ProductField.ALL]);
    ProductResult result = await OpenFoodAPIClient.getProduct(configuration);

    if (result.status == 1) {
      print(result.product.productName);

      foodName = result.product.productName;
      foodCals = result.product.nutriments.energyKcal;
      foodProtien = result.product.nutriments.proteinsServing;
      foodFat = result.product.nutriments.fatServing;
      foodCarbs = result.product.nutriments.carbohydratesServing;
      servingSize = result.product.servingQuantity;
      print(
          "$foodName , $foodCals , $foodProtien , $foodFat , $foodCarbs , $servingSize");


      return result.product;
    } else {
      throw new Exception(
          "product not found, please insert data for " + barcode);
    }
  }

  ConfirmFoodDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text("Is this the correct food?"),
            content:
            Text("ID $foodName"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  barcodeFood();
                  Navigator.pop(context);
                },
                child: Text("Confirm"),
              ),
              FlatButton(
                onPressed: () {
                  Food foodToEdit = Food(
                    name: foodName,
                    calories: foodCals,
                    protiens: foodProtien,
                    carbohydrates: foodCarbs,
                    fats: foodFat,
                    servingSize: servingSize,
                    userFK: widget.uid,
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          editFoodForm(foodToEdit: foodToEdit),
                    ),
                  );
                },
                child: Text("Edit"),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
            ],
          ),
    );
  }

  Future barcodeFood() async {
    Food food = Food(
      name: foodName,
      calories: foodCals,
      protiens: foodProtien,
      carbohydrates: foodCarbs,
      fats: foodFat,
      servingSize: servingSize,
      userFK: widget.uid,
    );

    DatabaseHelper.instance.foodInsert(food).then(
          (storedFood) =>
          BlocProvider.of<FoodBloc>(context).add(
            AddFood(storedFood),
          ),
    );
  }


  @override
  void initState() {
    super.initState();
    setState(() {
      getCarbs();
      getCals();
      getCalsLeft();
      getProtein();
      getFat();
    });
  }



  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    final width = MediaQuery
        .of(context)
        .size
        .width;
    final today = DateTime.now();

    if (userCarbs == null) {
      return Scaffold(
        backgroundColor: Color(0xFFE9E9E9),
        body: Center(
              child: Image.asset(
                'assets/logo.png',
                width: height * 0.3,
                height: height * 0.3,
              ),
        )
      );
    }


    return Scaffold(
      backgroundColor: Color(0xFFE9E9E9),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            height: height * 0.35,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(40),
              ),
              child: Container(
                color: Colors.white,
                padding:
                EdgeInsets.only(top: 30, left: 32, right: 16, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "${DateFormat("EEEE").format(today)}, ${DateFormat(
                            "d MMMM").format(today)}",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        "Hello, User",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        _RadialProgress(
                          width: width * 0.3,
                          height: width * 0.3,
                          progress: 0.5,
                          kcal: userCals,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _MacroProgress(
                                macro: "Protien",
                                progress: 0.3,
                                progressColor: Color(0xff68D065),
                                amountLeft: userProtein,
                                width: width * 0.3),
                            SizedBox(
                              height: 10,
                            ),
                            _MacroProgress(
                                macro: "Carbs",
                                progress: 0.6,
                                progressColor: Color(0xff68D065),
                                amountLeft: userCarbs,
                                width: width * 0.3),
                            SizedBox(
                              height: 10,
                            ),
                            _MacroProgress(
                                macro: "Fat",
                                progress: 0.1,
                                progressColor: Color(0xff68D065),
                                amountLeft: userFat,
                                width: width * 0.3),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: height * 0.38,
            left: 0,
            right: 0,
            child: Container(
              height: height,
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 9,
                    fit: FlexFit.loose,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 8,
                            left: 32,
                            right: 16,
                          ),
                          child: Text(
                            "Food Eaten",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        FoodList(widget.uid),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: SizedBox(),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: height * 0.04,
                        ),
                        IconButton(
                            color: Color(0xff68D065),
                            icon: Icon(Icons.search),
                            onPressed: () {}),
                        SizedBox(
                          height: height * 0.04,
                        ),
                        IconButton(
                            color: Color(0xff68D065),
                            icon: Icon(FontAwesomeIcons.camera),
                            onPressed: () {
                              _scanBarcode().then((value) =>
                                  getProduct(barcodeResult).then((value) =>
                                      ConfirmFoodDialog()));
                            }
                        ),

                        SizedBox(
                          height: height * 0.04,
                        ),
                        IconButton(
                            color: Color(0xff68D065),
                            icon: Icon(FontAwesomeIcons.plus),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          FoodForm()));
                            }),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _MacroProgress extends StatelessWidget {
  final String macro;
  final amountLeft;
  final double progress;
  final double width;
  final Color progressColor;


  const _MacroProgress({Key key,
    this.macro,
    this.amountLeft,
    this.progress,
    this.progressColor,
    this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          macro.toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 10,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.black12,
                  ),
                ),
                Container(
                  height: 10,
                  width: width * progress,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: progressColor,
                  ),
                ),
              ],
            ),
            SizedBox(width: 10),
            Text("${amountLeft}g left"),
          ],
        )
      ],
    );
  }
}

class _RadialProgress extends StatelessWidget {
  final height, width, progress;
  final kcal;

  const _RadialProgress({Key key, this.height, this.width, this.progress, this.kcal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RadialPainter(progress: progress),
      child: Container(
        height: height,
        width: width,
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$kcal",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff284FC2),
                  ),
                ),
                TextSpan(text: "\n"),
                TextSpan(
                  text: "kcal left",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff284FC2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadialPainter extends CustomPainter {
  final progress;

  _RadialPainter({this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 10
      ..color = Color(0xff68D065)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);
    double relativeProgress = 360 * progress;

    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width / 2),
        math.radians(-90), math.radians(-relativeProgress), false, paint);
    //canvas.drawCircle(center, size.width/2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
