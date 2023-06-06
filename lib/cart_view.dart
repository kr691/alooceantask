import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class CartViewPage extends StatelessWidget {
  const CartViewPage({Key? key}) : super(key: key);

  int calculateTotal() {
    int total = 0;
    for (int price in cartPrices) {
      total += price;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (cartImages.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                itemCount: cartImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Image.network(cartImages[index]),
                      trailing: Text('\$${cartPrices[index]}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                      ),
                    ),
                  );
                },
              ),
            SizedBox(height: 16),
            Text(
              'Total: \$${calculateTotal()}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}