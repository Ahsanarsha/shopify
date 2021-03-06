// ignore_for_file: avoid_print, library_private_types_in_public_api, no_logic_in_create_state, import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_simple_shopify/flutter_simple_shopify.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product? product;

  // ignore: sort_constructors_first
  const ProductDetailScreen({Key? key, @required this.product})
      : super(key: key);
  @override
  _ProductDetailScreenState createState() =>
      _ProductDetailScreenState(product!);
}

class CounterModel extends ChangeNotifier {
  int count = 0;

  void increment() {
    count++;
    notifyListeners();
  }

  void decrement() {
    count--;
    notifyListeners();
  }
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final Product product;

  // ignore: sort_constructors_first
  _ProductDetailScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    final controller = PageController();
    final images = product.images
        .map((image) => Image.network(
              image.originalSource,
              fit: BoxFit.cover,
            ))
        .toList();
    final variant = product.productVariants.first;
    final price =
        // ignore: lines_longer_than_80_chars
        '${variant.price.currencySymbol}${variant.price.amount}';
    return ChangeNotifierProvider<CounterModel>(
      create: (_) => CounterModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.title),
          automaticallyImplyLeading: false,
          leading: Navigator.canPop(context)
              ? IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 16,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                size: 16,
              ),
              onPressed: () {},
            )
          ],
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              child: PageView(
                controller: controller,
                children: images,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8),
              alignment: Alignment.bottomCenter,
              child: SmoothPageIndicator(
                controller: controller,
                count: images.length,
                effect: const SlideEffect(
                    spacing: 6,
                    radius: 6,
                    dotWidth: 6,
                    dotHeight: 6,
                    dotColor: Colors.black12,
                    activeDotColor: Colors.blue),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.vendor),
                  const SizedBox(height: 8),
                  Text(product.title,
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text(
                    price,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Consumer<CounterModel>(
                    builder: (context, value, child) {
                      return Row(
                        children: [
                          ButtonTheme(
                            minWidth: 0,
                            height: 32,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            child: FlatButton(
                              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                              color: Colors.grey[300],
                              onPressed: () {
                                value.decrement();
                              },
                              child: const Icon(
                                Icons.remove,
                                size: 16,
                              ),
                            ),
                          ),
                          Container(
                            width: 48,
                            alignment: Alignment.center,
                            child: Text(value.count.toString()),
                          ),
                          ButtonTheme(
                            minWidth: 0,
                            height: 32,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            child: FlatButton(
                              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                              color: Colors.grey[300],
                              onPressed: () {
                                value.increment();
                              },
                              child: const Icon(
                                Icons.add,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FlatButton(
                      color: Colors.orange,
                      textColor: Colors.white,
                      onPressed: () {
                        _addProductToShoppingCart(variant);
                      },
                      child: const Text('?????????????????????'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Html(
                    data: product.descriptionHtml,
                    onLinkTap: (url) {
                      print(url);
                      // open url in a webview
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Adds a product variant to the checkout
  Future<void> _addProductToShoppingCart(ProductVariant variant) async {
    final shopifyCheckout = ShopifyCheckout.instance;
    final checkoutId = await shopifyCheckout.createCheckout();
    print(checkoutId);
    //Adds a product variant to a specific checkout id
    await shopifyCheckout.checkoutLineItemsReplace(checkoutId, [variant.id]);
    final checkout = await shopifyCheckout.getCheckoutInfoQuery(checkoutId);
    print(checkout.lineItems.lineItemList.first.title);
  }
}
