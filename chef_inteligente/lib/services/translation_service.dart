import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class TranslationService {
  Future<String> translateText(String text) async {
    if(text.isEmpty) {
      return "";
    }

    final url = Uri.parse(
      'https://api.mymemory.translated.net/get?q=${Uri.encodeComponent(text)}&langpair=en|pt'
    );
    try{
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        final translatedText = data['responseData']['translatedText'];

        if (translatedText == "NO QUERY SPECIFIED!") {
           return text;
        }

        return translatedText;
      } else {
        debugPrint('Erro na API MyMemory: ${response.body}');
        return text; 
      }
    } catch (e) {
      debugPrint('Erro de conexão MyMemory: $e');
      return text;
      }
  }
}