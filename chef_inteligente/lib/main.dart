import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart'; // Importe o Provider

import 'services/api_keys.dart'; // Suas chaves de API
import 'config/app_theme.dart'; // O SEU NOVO ARQUIVO DE TEMA
import 'providers/favorite_recipes_provider.dart'; // O provider do SQLite
import 'screens/homeScreen.dart'; // Sua tela Home
import 'screens/favoritesScreen.dart'; // Sua tela de Favoritos

const String CONTENTFUL_SPACE_ID = ApiKeys.contentfulSpaceId;
const String CONTENTFUL_ACCESS_TOKEN = ApiKeys.contentfulAccessToken;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHiveForFlutter(); // Para o cache do GraphQL

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
    // 1. Iniciamos o MultiProvider para gerenciar todos os providers de estado
    MultiProvider(
      providers: [
        // 2. Adicionamos o Provider para Favoritos (SQLite)
        ChangeNotifierProvider(
          create: (context) => FavoriteRecipesProvider(),
        ),
        // ... (você pode adicionar outros providers aqui)
      ],
      // 3. O GraphQLProvider continua envolvendo o App
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
      debugShowCheckedModeBanner: false, // Opcional: remove o banner "Debug"
      // 4. Usamos o tema centralizado do seu novo arquivo AppTheme
      theme: AppTheme.lightTheme, 
      // 5. A 'home' agora é o widget de navegação
      home: const MyNavigationBar(),
    );
  }
}

// =========================================================================
// WIDGET DE NAVEGAÇÃO
// Gerencia as abas "Home" e "Favoritos"
// =========================================================================
class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({super.key});

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _selectedIndex = 0; // 0 = Home, 1 = Favoritos

  // Lista das telas que a barra de navegação vai controlar
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),       // Sua tela Home
    const FavoritesScreen(),  // A tela de Favoritos que criamos
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // Os estilos (cores, fontes) já vêm do AppTheme!
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home), // Ícone diferente quando ativo
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite), // Ícone diferente quando ativo
            label: 'Favoritos',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}