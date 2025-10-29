// lib/config/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Cores da sua paleta do Figma
  // Nota: O Figma mostra um fundo FFF5E0. Para o texto principal "Smart Chef"
  // e títulos, usaremos um marrom escuro 271500 (ou o 424242 que vc mencionou)
  static const Color primaryTextColor = Color(0xFF271500); // Marrom escuro para textos principais (Smart Chef, títulos)
  static const Color secondaryTextColor = Color(0xFF898989); // Marrom mais claro para textos secundários (timer, msg vazio)
  static const Color scaffoldBackgroundColor = Color(0xFFFFF5E0); // Seu creme claro de fundo para todo o app
  static const Color cardBackgroundColor = Colors.white; // Fundo dos cards brancos
  static const Color cardChipColor = Color(0xFFFFCC80); // Cor dos chips (ex: "30 min")
  static const Color cardChipTextColor = primaryTextColor; // Texto dentro do chip
  static const Color bottomNavBgColor = Color(0xFFFFF5E0); // Fundo da Bottom Nav Bar (MESMO do Scaffold)
  static const Color bottomNavSelectedItemColor = Color(0xFFF39C12); // Laranja para item selecionado
  static const Color bottomNavUnselectedItemColor = secondaryTextColor; // Cor para item não selecionado
  static const Color favoriteIconColor = Colors.red; // Cor do ícone de favorito

  // Estilo do Tema
  static ThemeData get lightTheme {
    return ThemeData(
      // === CORES GERAIS ===
      primarySwatch: Colors.brown, // Apenas uma base, as cores acima são mais precisas
      primaryColor: primaryTextColor, // Definindo a cor primária para o texto principal
      colorScheme: ColorScheme.light(
        primary: primaryTextColor,
        secondary: secondaryTextColor,
        surface: scaffoldBackgroundColor,
        background: scaffoldBackgroundColor,
        onPrimary: Colors.white, // Usado por alguns widgets (ex: FloatingActionButton)
        onBackground: primaryTextColor,
        onSurface: primaryTextColor,
      ),
      scaffoldBackgroundColor: scaffoldBackgroundColor, // Fundo geral do app

      // === APPBAR (VAI SER USADA NA FavoritesScreen, mas como uma Barra Simples) ===
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent, // Transparente para não ter barra visível
        foregroundColor: primaryTextColor,   // Cor dos ícones e texto (se houver)
        elevation: 0,                    // SEM Sombra
        centerTitle: false,              // Título alinhado à esquerda
        titleTextStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 22, // Tamanho para 'Smart Chef' e 'Suas Receitas Favoritas!'
          fontWeight: FontWeight.bold,
          color: primaryTextColor,
        ),
      ),

      // === BOTTOM NAVIGATION BAR ===
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: bottomNavBgColor, // Fundo transparente para mesclar com Scaffold
        selectedItemColor: bottomNavSelectedItemColor,
        unselectedItemColor: bottomNavUnselectedItemColor,
        elevation: 0, // Sem sombra para um look flat
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: TextStyle(fontFamily: 'Montserrat', fontSize: 12),
      ),

      // === TIPOGRAFIA GERAL ===
      fontFamily: 'Montserrat',
      textTheme: TextTheme(
        displayLarge: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, fontSize: 48, color: primaryTextColor), // Título grande 'Smart Chef'
        headlineMedium: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, fontSize: 30, color: primaryTextColor), // Título de Seção 'Suas Receitas Favoritas!'
        headlineSmall: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, fontSize: 24, color: primaryTextColor),
        titleLarge: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, fontSize: 20, color: primaryTextColor), // Nomes de receita
        bodyLarge: TextStyle(fontFamily: 'Montserrat', fontSize: 16, color: secondaryTextColor),
        bodyMedium: TextStyle(fontFamily: 'Montserrat', fontSize: 14, color: secondaryTextColor),
        labelLarge: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold, fontSize: 14, color: cardChipTextColor), // Botões/chips
      ),
      
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}