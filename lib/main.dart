import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "package:flutter_simple_shopify/flutter_simple_shopify.dart";
import 'package:shopify/collection_tab.dart';
import 'package:shopify/home_tab.dart';
import 'package:shopify/profile_tab.dart';
import 'package:shopify/search_tab.dart';
import 'package:uuid/uuid.dart';

Future<void> main() async {
  await DotEnv().load(fileName: '.env');
  ShopifyConfig.setConfig(
    DotEnv().env['33038043b32492285165c14c7ba2e35b'],
    DotEnv().env['https://professor-gallery.myshopify.com/'],
    '2022-05-26',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = Typography.material2018();
    var appBartTextTheme = typography.englishLike.merge(typography.black);
    appBartTextTheme = appBartTextTheme.copyWith(
        headline6: appBartTextTheme.headline6?.copyWith(fontSize: 14),
        subtitle1: appBartTextTheme.subtitle1);

    return MaterialApp(
      title: 'Shopify Example',
      theme: ThemeData(
          primaryColor: Colors.black,
          appBarTheme: AppBarTheme(
            color: Colors.white,
            iconTheme: const IconThemeData(
              // color: Color(0xFF666666),
              size: 10,
            ),
            elevation: 0,
            toolbarTextStyle: appBartTextTheme.bodyText2,
            titleTextStyle: appBartTextTheme.headline6,
          )),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final _tabs = [
    HomeTab(),
    const CollectionTab(),
    const SearchTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavigationBarItemClick,
        fixedColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.black38,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: 'Collections'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  void _onNavigationBarItemClick(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
