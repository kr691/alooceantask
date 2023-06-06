import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Images History'),
      ),
      body: Center(
        child: FutureBuilder<List<String?>?>(
          future: _getImageUrlsFromSharedPreferences(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data != null) {
              List<String?> imageUrls = snapshot.data!;
              imageUrls = imageUrls.reversed.toList();
              return ListView.builder(
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return Image.network(imageUrls[index]!);
                },
              );
            } else {
              return Text('No stored images found');
            }
          },
        ),
      ),
    );
  }

  Future<List<String?>?> _getImageUrlsFromSharedPreferences() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> storedImages = prefs.getStringList('imageUrls') ?? [];
      return storedImages;
    } catch (e) {
      print('Error fetching stored image URLs: $e');
      return null;
    }
  }
}

