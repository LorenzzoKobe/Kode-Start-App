import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'api_keys.dart';

class ContentfulService {
  final GraphQLClient _client;

  ContentfulService() : _client = _initClient();

  static GraphQLClient _initClient() {
    final HttpLink httpLink = HttpLink(
      'https://graphql.contentful.com/content/v1/spaces/${ApiKeys.contentfulSpaceId}',
    );

    final AuthLink authLink = AuthLink(
      getToken: () => 'Bearer ${ApiKeys.contentfulAccessToken}',
    );
    final Link link = authLink.concat(httpLink);

    return GraphQLClient(
      link: link,
      cache: GraphQLCache(store: InMemoryStore()),
    );
  }

  static const String _fetchGenericItemsQuery = r'''
  query {
    chefInteligenteCollection {
      items {
        sys {
          id
        }
        title
        text1
        text2
        text3
        }
      }
    }
  }
  ''';

  Future<List<dynamic>> getGenericItems() async {
    try {
      final QueryOptions options = QueryOptions(
        document: gql(_fetchGenericItemsQuery),
      );

      final QueryResult result = await _client.query(options);

      if (result.hasException) {
        debugPrint('Erro na API GraphQL: ${result.exception.toString()}');
        throw Exception(result.exception);
      }

      if (result.data != null) {
        final List items = result.data!['chefInteligenteCollection']['items'];

        debugPrint('Itens genéricos encontrados: ${items.length}');
        return items;
      }
      return [];
    } catch (e) {
      debugPrint('Erro ao buscar itens: $e');

      return [];
    }
  }
}
