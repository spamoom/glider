library cocoon;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:icons_helper/icons_helper.dart';
import 'bottom_nav_scaffold.dart';

class Cocoon extends StatelessWidget {
  final Map<String, dynamic> _json;

  Cocoon(this._json, {Key key}) : super(key: key);

  static Widget appFromUrl(String url, {String fallback}) {
    return FutureBuilder(
      future: get(url),
      builder: (context, AsyncSnapshot<Response> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.statusCode == 200) {
            return Cocoon(jsonDecode(snapshot.data.body));
          } else if (fallback != null) {
            return Cocoon(jsonDecode(fallback));
          } else {
            return MaterialApp(
              home: Center(
                child: Text(
                  snapshot.hasError
                      ? snapshot.error.toString()
                      : 'An error occurred',
                ),
              ),
              title: "Cocoon App",
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

  static Widget _fromUrl(String url) {
    return FutureBuilder(
      future: get(url),
      builder: (context, AsyncSnapshot<Response> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.statusCode == 200) {
            final json = jsonDecode(snapshot.data.body);
            if (json['type'] != 'scaffold') {
              throw Exception(
                  "Only Scaffold widgets can be retrieved from URLs");
            }
            return Cocoon(json);
          } else {
            return Scaffold(
              body: Center(
                child: Text(
                  snapshot.hasError
                      ? snapshot.error.toString()
                      : 'An error occurred',
                ),
              ),
            );
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(_json);
    final String type = _json['type'];
    switch (type) {
      case 'url':
        return Cocoon._fromUrl(_json['url']);
      case 'app':
        return _buildApp(context, _json);
      case 'scaffold':
        return _buildScaffold(context, _json);
      case 'bottom_nav_scaffold':
        return _buildBottomNavScaffold(context, _json);
      case 'app_bar':
        return _buildAppBar(context, _json);
      case 'aspect_ratio':
        return _buildAspectRatio(context, _json);
      case 'button_bar':
        return _buildButtonBar(context, _json);
      case 'card':
        return _buildCard(context, _json);
      case 'center':
        return _buildCenter(context, _json);
      case 'circular_progress':
        return _buildCircularProgressIndicator(context, _json);
      case 'column':
        return _buildColumn(context, _json);
      case 'divider':
        return _buildDivider(context, _json);
      case 'drawer':
        return _buildDrawer(context, _json);
      case 'fab':
        return _buildFab(context, _json);
      case 'hero':
        return _buildHero(context, _json);
      case 'icon':
        return _buildIcon(context, _json['icon']);
      case 'image':
        return _buildImage(context, _json);
      case 'linear_progress':
        return _buildLinearProgressIndiator(context, _json);
      case 'list_tile':
        return _buildListTile(context, _json);
      case 'list_view':
        return _buildListView(context, _json);
      case 'padding':
        return _buildPadding(context, _json);
      case 'sized_box':
        return _buildSizedBox(context, _json);
      case 'row':
        return _buildRow(context, _json);
      case 'text':
        return _buildText(context, _json);
      case 'tooltip':
        return _buildTooltip(context, _json);
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
      debugShowCheckedModeBanner: json["debug"] != null ? json["debug"] : false,
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

  static BottomNavScaffold _buildBottomNavScaffold(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    return BottomNavScaffold(json);
  }

  static AppBar _buildAppBar(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    return AppBar(
      title: Text(json['title']),
    );
  }

  static AspectRatio _buildAspectRatio(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    return AspectRatio(
      aspectRatio: json['aspect_ratio'],
      child: Cocoon(json['child']),
    );
  }

  // TODO Bottom navigation bar

  static ButtonBar _buildButtonBar(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    final List<dynamic> buttonsJson = json['buttons'];
    final List<Widget> buttons =
        buttonsJson.map((button) => Cocoon(button)).toList();
    return ButtonBar(
      children: buttons,
    );
  }

  static Card _buildCard(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    return Card(
      child: Cocoon(json['child']),
      color: _colorFromHex(json['color']),
      elevation: json['elevation'] ?? 1.0,
    );
  }

  static Center _buildCenter(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    return Center(
      child: json['child'] != null ? Cocoon(json['child']) : null,
    );
  }

  // TODO Checkbox

  // TODO Chip

  static CircularProgressIndicator _buildCircularProgressIndicator(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    return CircularProgressIndicator();
  }

  static Column _buildColumn(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    final List<dynamic> childrenJson = json['children'];
    final List<Widget> children =
        childrenJson.map((child) => Cocoon(child)).toList();
    return Column(
      children: children,
    );
  }

  static Divider _buildDivider(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    return Divider(
      indent: json['indent'],
    );
  }

  static Drawer _buildDrawer(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    return Drawer(child: Cocoon(json['child']));
  }

  // TODO Dropdown button

  // TODO Flat button

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

  // TODO Form

  // TODO FormField

  // TODO GridView

  static Hero _buildHero(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    return Hero(
      tag: json['tag'],
      child: Cocoon(json['child']),
    );
  }

  static Icon _buildIcon(BuildContext context, String icon) {
    return Icon(getMaterialIcon(name: icon));
  }

  // TODO IconButton

  static Image _buildImage(BuildContext context, Map<String, dynamic> json) {
    return Image.network(json['src']);
  }

  static LinearProgressIndicator _buildLinearProgressIndiator(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    return LinearProgressIndicator();
  }

  static ListTile _buildListTile(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    final Function onTap = () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Cocoon(json['destination']),
      ));
    };
    return ListTile(
      title: json['title'] != null ? Text(json['title']) : null,
      subtitle: json['subtitle'] != null ? Text(json['subtitle']) : null,
      leading: json['leading'] != null ? Cocoon(json['leading']) : null,
      trailing: json['trailing'] != null ? Cocoon(json['trailing']) : null,
      onTap: json['destination'] != null ? onTap : null,
    );
  }

  static ListView _buildListView(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    final List<dynamic> childrenJson = json['children'];
    final List<Widget> children =
        childrenJson.map((child) => Cocoon(child)).toList();
    return ListView(children: children);
  }

  static Padding _buildPadding(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    return Padding(
        child: Cocoon(json['child']),
        padding: json['padding'] != null
            ? EdgeInsets.all(json['padding'])
            : json['padding_vertical'] != null &&
                    json['padding_horizontal'] != null
                ? EdgeInsets.symmetric(
                    vertical: json['padding_vertical'],
                    horizontal: json['padding_horizontal'],
                  )
                : EdgeInsets.fromLTRB(
                    json['padding_left'],
                    json['padding_top'],
                    json['padding_right'],
                    json['padding_bottom'],
                  ));
  }

  // TODO PopupMenuButton

  // TODO Radio

  // TODO RaisedButton

  // TODO RefreshIndicator

  static Row _buildRow(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    final List<dynamic> childrenJson = json['children'];
    final List<Widget> children =
        childrenJson.map((child) => Cocoon(child)).toList();
    return Row(
      children: children,
    );
  }

  static SizedBox _buildSizedBox(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    return SizedBox(
      width: json['width'],
      height: json['height'],
      child: json['child'] != null ? Cocoon(json['child']) : null,
    );
  }

  // TODO Slider

  // TODO SnackBar

  // TODO Switch

  // TODO TabBar

  // TODO TabBarView

  // TODO TextField

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

  static Text _buildText(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    return Text(json['text']);
  }

  static Tooltip _buildTooltip(
    BuildContext context,
    Map<String, dynamic> json,
  ) {
    return Tooltip(
      child: Cocoon(json['child']),
      message: json['message'],
    );
  }

  static Color _colorFromHex(String hex) {
    if (hex != null && hex.isNotEmpty) {
      return Color(int.parse(hex.replaceAll('#', ''), radix: 16))
          .withOpacity(1.0);
    } else
      return null;
  }
}
