import 'package:flutter/material.dart';

// O tema da sua aplicação
final ThemeData appTheme = ThemeData(
  // Define a cor primária da aplicação como vermelho.
  // Essa cor será usada para widgets como botões flutuantes, AppBars, etc.
  primaryColor: Colors.red[700],
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.red,
    // Define a cor de fundo principal para o Scaffold, que será branca.
    backgroundColor: Colors.white,
    // Define a cor secundária, usada para elementos como o Card.
    // Usamos o preto aqui para seguir a sua solicitação.
    accentColor: Colors.black,
  ).copyWith(
    // Adiciona uma cor para o texto em segundo plano, garantindo visibilidade.
    onSurface: Colors.black,
  ),

  // Estiliza o fundo do Scaffold (a tela principal) com a cor branca.
  scaffoldBackgroundColor: Colors.white,

  // Estiliza a barra superior (AppBar).
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.red, // A cor de fundo da AppBar
    foregroundColor: Colors.white, // A cor do texto e ícones na AppBar
    elevation: 4.0, // Adiciona uma pequena sombra
  ),

  // Define o estilo padrão do texto para a aplicação.
  textTheme: const TextTheme(
    // Estilo para títulos maiores
    titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    // Estilo para texto principal
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
  ),

  // Estiliza os cartões (Card)
  // cardTheme: CardTheme(
  //   color: Colors.black, // O fundo do Card será preto
  //   shape: RoundedRectangleBorder(
  //     borderRadius: BorderRadius.circular(12.0), // Cantos arredondados
  //   ),
  //   elevation: 5,
  // ),
);