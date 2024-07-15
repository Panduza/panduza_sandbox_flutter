import 'package:flutter/material.dart';

abstract class BasicWidget<T extends StatefulWidget> extends State<T> {
  void callSetState() {
    setState(() {});
  }
}