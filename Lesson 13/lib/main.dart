import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Product.dart';
import 'dart:async';
import 'package:flutter/services.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(seconds: 1), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    controller.forward();
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    controller.forward();
    return MaterialApp(
        title: 'Flutter Demo', theme: ThemeData(primarySwatch: Colors.blue,),
        home: MyHomePage(title: 'Product layout demo home page', animation: animation,)
    );
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key, required this.title, required this.animation}) : super(key: key);
  final String title;
  final items = Product.getProducts();
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title:Text("Product Listing")),
        body: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(2.0, 10.0, 2.0, 10.0),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  child: MyAnimatedWidget(
                    child: ProductBox(item: items[index]),
                    animation: animation,
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ProductPage(item: items[index])
                      )
                    );
                  },
              );

            },
        )
    );
  }
}

class RatingBox extends StatelessWidget{
  RatingBox({Key? key, required this.item}) : super (key:key);
  final Product item;

  Widget build(BuildContext context) {
    double _size = 20;
    print(item.rating);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(0),
          child: IconButton(
            icon: (
                item.rating >= 1? Icon( Icons.star, size: _size, )
                    : Icon( Icons.star_border, size: _size, )
            ),
            color: Colors.red[500],
            onPressed: () => this.item.updateRating(1),
            iconSize: _size,
          ),
        ),
        Container(
          padding: EdgeInsets.all(0),
          child: IconButton(
            icon: (item.rating >= 2
                ? Icon(
              Icons.star,
              size: _size,
            )
                : Icon(
              Icons.star_border,
              size: _size,
            )
            ),
            color: Colors.red[500],
            onPressed: () => this.item.updateRating(2),
            iconSize: _size,
          ),
        ),
        Container(
          padding: EdgeInsets.all(0),
          child: IconButton(
            icon: (
                item.rating >= 3 ?
                Icon( Icons.star, size: _size, )
                    : Icon( Icons.star_border, size: _size, )
            ),
            color: Colors.red[500],
            onPressed: () => this.item.updateRating(3),
            iconSize: _size,
          ),
        ),
      ],
    );
  }
}

class ProductBox extends StatelessWidget {
  ProductBox({Key ? key, required this.item}) : super(key: key);
  final Product item;

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
        padding: EdgeInsets.all(2),
        height: 140,
        child: Card(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image.asset("assets/" + this.item.image,
                  height: 100,
                  width: width*0.3
                ),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.all(5),
                        child: ScopedModel<Product>(
                            model: this.item, child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                                this.item.name, style: TextStyle(
                                fontWeight: FontWeight.bold
                            )
                            ),
                            Text(this.item.description),
                            Text("Price: " + this.item.price.toString()),
                            ScopedModelDescendant<Product>(
                                builder: (context, child, item) {
                                  return RatingBox(item: item);
                                }
                            )
                          ],
                        )
                        )
                    )
                )
              ]
          ),
        )
    );
  }
}

class ProductPage extends StatelessWidget {
  ProductPage({Key? key, required this.item}) : super(key: key);
  final Product item;
  static const platform = const MethodChannel('flutterapp.tutorialspoint.com/browser');

  Future<void> _openBrowser() async {
    Future<void> _openBrowser() async {
      try {
        final int result = await platform.invokeMethod('openBrowser', <String, String>{
          'url': "https://flutter.dev"
        });
      }
      on PlatformException catch (e) {
        // Unable to open the browser print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.item.name),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(100),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  "assets/" + this.item.image,

                ),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                                this.item.name, style: TextStyle(
                                fontWeight: FontWeight.bold
                            )
                            ),
                            Text(this.item.description),
                            Text("Price: " + this.item.price.toString()),
                            RatingBox(item: item,),
                            RaisedButton(
                              child: Text('Open Browser'),
                              onPressed: _openBrowser,
                            ),
                          ],
                        )
                    )
                )
              ]
          ),
        ),
      ),
    );
  }
}

class MyAnimatedWidget extends StatelessWidget {
  MyAnimatedWidget({required this.child, required this.animation});
  final Widget child;
  final Animation<double> animation;

  Widget build(BuildContext context) => Center(
    child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) => Container(
          child: Opacity(opacity: animation.value, child: child),
        ),
        child: child
    ),
  );
}

