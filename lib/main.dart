import 'dart:math';
import 'package:algooceantask/ApiHandler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cart_view.dart';
import 'history_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dog Image Fetcher',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/storedImage': (context) => ImageHistoryPage(),
        '/cartview': (context) => CartViewPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

Map<String, int> dogPrices = {};
List<String> cartImages = [];
List<int> cartPrices = [];

class _HomePageState extends State<HomePage> {
  List<String> imageUrls = [];

  Future<void> fetchDogImage() async {
    try{
      String url = "https://dog.ceo/api/breeds/image/random";
      final response = await ApiHandler.shared.getDogData(url);
      String imageUrl= response.message;
      // Generate a random price for the dog
      int randomPrice = _generateRandomPrice();

      // Save the image URL to shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> storedImages = prefs.getStringList('imageUrls') ?? [];
      storedImages.add(imageUrl);
      await prefs.setStringList('imageUrls', storedImages);

      // Add the image URL and price to the dogPrices map
      dogPrices[imageUrl] = randomPrice;

      setState(() {
        imageUrls = storedImages;
      });
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
  }

  int _generateRandomPrice() {
    // Generate a random price between 10 and 100
    return 10 + Random().nextInt(91);
  }

  void addToCart(String imageUrl) {
    cartImages.add(imageUrl);
    cartPrices.add(dogPrices[imageUrl] ?? 67);
  }

  @override
  void initState() {
    super.initState();
    loadStoredImages();
  }

  Future<void> loadStoredImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedImages = prefs.getStringList('imageUrls') ?? [];
    setState(() {
      imageUrls = storedImages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Algoocean Task'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageUrls.isNotEmpty)
              AspectRatio(
                aspectRatio: 1.0,
                child: Image.network(
                  imageUrls.last,
                  fit: BoxFit.contain,
                ),
              ),
            ElevatedButton(
              onPressed: fetchDogImage,
              child: Text('Fetch Dog Image'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/storedImage');
              },
              child: Text('View Images History'),
            ),
            ElevatedButton(
              onPressed: () {
                if (imageUrls.isNotEmpty) {

                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Add to Cart'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.network(imageUrls.last),
                            SizedBox(height: 8),
                            Text('Price: \$${dogPrices[imageUrls.last] ?? 67}'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              addToCart(imageUrls.last);
                              Navigator.of(context).pop();
                            },
                            child: Text('Add to Cart'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Add to Cart'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cartview');
              },
              child: Text('View Cart'),
            ),
          ],
        ),
      ),
    );
  }
}


