import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'services/api_keys.dart';
import 'screens/homeScreen.dart';

const String CONTENTFUL_SPACE_ID = ApiKeys.contentfulSpaceId;
const String CONTENTFUL_ACCESS_TOKEN = ApiKeys.contentfulAccessToken;

void main() async {
  await initHiveForFlutter();

  final HttpLink httpLink = HttpLink(
    'https://graphql.contentful.com/content/v1/spaces/$CONTENTFUL_SPACE_ID'
  );

  final AuthLink authLink = AuthLink(
    getToken: () async => 'Bearer $CONTENTFUL_ACCESS_TOKEN' 
    );

  final Link link = authLink.concat(httpLink);

  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: link,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );

  runApp(
    GraphQLProvider(
      client: client,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMART CHEF',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Color.fromARGB(255, 245, 224, 185),
      ),

      home: HomeScreen(),
    );
  }
}
