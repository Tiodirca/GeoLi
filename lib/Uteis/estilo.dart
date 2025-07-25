import 'package:flutter/material.dart';
import 'paleta_cores.dart';

class Estilo {
  double raioBordaCampoEditText = 20.0;

  ThemeData get estiloGeral => ThemeData(
        primaryColor: PaletaCores.corAzulEscuro,
        appBarTheme: const AppBarTheme(
          color: PaletaCores.corAzulEscuro,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          errorStyle: const TextStyle(fontSize: 13, color: Colors.red),
          hintStyle: const TextStyle(
            color: PaletaCores.corVerde,
            fontSize: 16,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
              color: PaletaCores.corVerde,
            ),
            borderRadius: BorderRadius.circular(raioBordaCampoEditText),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
              color: PaletaCores.corVerde,
            ),
            borderRadius: BorderRadius.circular(raioBordaCampoEditText),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
              color: PaletaCores.corVerde,
            ),
            borderRadius: BorderRadius.circular(raioBordaCampoEditText),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.red),
            borderRadius: BorderRadius.circular(raioBordaCampoEditText),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 1,
              color: PaletaCores.corVerde,
            ),
            borderRadius: BorderRadius.circular(raioBordaCampoEditText),
          ),
          labelStyle: const TextStyle(
            color: PaletaCores.corLaranja,
            fontSize: 16,
          ),
        ),
      );
}
