import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import 'services/api_keys.dart';
import 'config/app_theme.dart';
import 'providers/favorite_recipes_provider.dart';
import 'screens/homeScreen.dart'; 
import 'screens/favoritesScreen.dart';
import 'package:provider/provider.dart';
import 'providers/all_recipes_provider.dart';

const String CONTENTFUL_SPACE_ID = ApiKeys.contentfulSpaceId;
const String CONTENTFUL_ACCESS_TOKEN = ApiKeys.contentfulAccessToken;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter();

  final HttpLink httpLink = HttpLink(
    'https://graphql.contentful.com/content/v1/spaces/$CONTENTFUL_SPACE_ID',
  );

  final AuthLink authLink = AuthLink(
    getToken: () async => 'Bearer $CONTENTFUL_ACCESS_TOKEN',
  );

  final Link link = authLink.concat(httpLink);

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: link,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FavoriteRecipesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AllRecipesProvider(),
        ),
      ],
      child: GraphQLProvider(
        client: client,
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMART CHEF',
      debugShowCheckedModeBanner: false,
      
      theme: AppTheme.lightTheme, 
      
      home: const MyNavigationBar(),
    );
  }
}

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key});

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const FavoritesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  AppBar? _buildAppBar() {
    if (_selectedIndex == 0) {
      return AppBar(
        title: Text('Smart Chef'),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      );
    }

    if (_selectedIndex == 1) {
      return AppBar(title: Text('Minhas Receitas Favoritas'));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(), 
      
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
