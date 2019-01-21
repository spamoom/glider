library cocoon;

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:icons_helper/icons_helper.dart';
import 'dart:convert';

class Cocoon extends StatelessWidget {
  final Map<String, dynamic> _json;

  Cocoon(this._json, {Key key}) : super(key: key);

  static Widget fromUrl(String url) {
    return FutureBuilder(
      future: get(url),
      builder: (context, AsyncSnapshot<Response> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.statusCode == 200) {
            return Cocoon(jsonDecode(snapshot.data.body));
          } else {
            return Center(
              child: Text(
                snapshot.hasError
                    ? snapshot.error.toString()
                    : 'An error occurred',
              ),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String type = _json['type'];
    switch (type) {
      case 'url':
        return Cocoon(_json['url']);
      case 'app':
        return _buildApp(context, _json);
      case 'scaffold':
        return _buildScaffold(context, _json);
      case 'app_bar':
        return _buildAppBar(context, _json);
      case 'fab':
        return _buildFab(context, _json);
      default:
        return Center();
    }
  }

  static MaterialApp _buildApp(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    return MaterialApp(
      home: Cocoon(json['home']),
      title: json['title'],
      theme: _buildTheme(context, json['theme']),
    );
  }

  static Scaffold _buildScaffold(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    return Scaffold(
      appBar: json['app_bar'] != null
          ? _buildAppBar(context, json['app_bar'])
          : null,
      body: json['body'] != null ? Cocoon(json['body']) : null,
      floatingActionButton: json['fab'] != null ? Cocoon(json['fab']) : null,
      drawer: json['drawer'] != null ? Cocoon(json['drawer']) : null,
      bottomNavigationBar:
          json['bottom_bar'] != null ? Cocoon(json['bottom_bar']) : null,
      bottomSheet:
          json['bottom_sheet'] != null ? Cocoon(json['bottom_sheet']) : null,
    );
  }

  static AppBar _buildAppBar(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    return AppBar(
      title: Text(json['title']),
    );
  }

  static FloatingActionButton _buildFab(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    final Function onPressed = () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Cocoon(json['destination']),
      ));
    };
    return json['label'] != null
        ? FloatingActionButton.extended(
            icon: _buildIcon(context, json['icon']),
            label: Text(json['label']),
            onPressed: onPressed,
          )
        : FloatingActionButton(
            child: _buildIcon(context, json['icon']),
            onPressed: onPressed,
          );
  }

  static Icon _buildIcon(BuildContext context, String icon) {
    return Icon(getMaterialIcon(name: icon));
  }

  static ThemeData _buildTheme(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    return ThemeData(
      primaryColor: _colorFromHex(json['primary_color']),
      accentColor: _colorFromHex(json['accent_color']),
      brightness: json['dark'] == true ? Brightness.dark : Brightness.light,
    );
  }

  static Color _colorFromHex(String hex) {
    return Color(int.parse(hex.replaceAll('#', ''), radix: 16))
        .withOpacity(1.0);
  }
}
