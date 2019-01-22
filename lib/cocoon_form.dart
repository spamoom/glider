import 'package:flutter/material.dart';
import 'package:icons_helper/icons_helper.dart';
import 'dart:convert';

class CocoonForm extends StatefulWidget {
  final Map<String, dynamic> _json;

  CocoonForm(this._json, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CocoonFormState(_json);
  }
}

class _CocoonFormState extends State<CocoonForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _json;
  final Map<String, dynamic> _values = {};
  final Map<String, TextEditingController> _textControllers = {};

  _CocoonFormState(this._json) {
    final fields = _json['fields'];
    fields.forEach((field) {
      final String name = field['name'];
      _values[name] = field['initial_value'];
    });

    print(_values);
  }

  void _setValue(String name, dynamic value) {
    setState(() {
      _values[name] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final fields = _json['fields'];
    final List<Widget> children = [];
    fields.forEach((field) {
      children.add(_buildField(context, field));
    });
    return Form(
      key: _formKey,
      child: ListView(
        children: children,
      ),
    );
  }

  Widget _buildField(BuildContext context, Map<String, dynamic> json) {
    switch (json['type']) {
      case 'text_field':
        return _buildTextField(context, json);
      case 'checkbox':
        return _buildCheckbox(context, json);
      default:
        return ListTile();
    }
  }

  Widget _buildTextField(BuildContext context, Map<String, dynamic> json) {
    _textControllers[json['name']] =
        TextEditingController(text: json['initial_value']);

    TextInputType keyboardType;
    TextCapitalization capitalization;

    switch (json['keyboard_type']) {
      case 'text':
        keyboardType = TextInputType.text;
        break;
      case 'email':
        keyboardType = TextInputType.emailAddress;
        break;
      case 'phone':
        keyboardType = TextInputType.phone;
        break;
      case 'number':
        keyboardType = TextInputType.number;
        break;
      default:
        keyboardType = TextInputType.text;
    }

    switch (json['capitalization']) {
      case 'words':
        capitalization = TextCapitalization.words;
        break;
      case 'sentences':
        capitalization = TextCapitalization.sentences;
        break;
      case 'characters':
        capitalization = TextCapitalization.characters;
        break;
      default:
        capitalization = TextCapitalization.none;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: TextFormField(
        controller: _textControllers[json['name']],
        decoration: InputDecoration(
          labelText: json['label'],
          helperText: json['help'],
          hintText: json['hint'],
        ),
        keyboardType: keyboardType,
        textCapitalization: capitalization,
        obscureText: json['obscure_text'] == true,
      ),
    );
  }

  Widget _buildCheckbox(BuildContext context, Map<String, dynamic> json) {
    return CheckboxListTile(
      value: _values[json['name']],
      onChanged: (value) {
        _setValue(json['name'], value);
      },
      title: json['title'] != null ? Text(json['title']) : null,
      subtitle: json['subtitle'] != null ? Text(json['subtitle']) : null,
      secondary: json['icon'] != null
          ? Icon(getIconGuessFavorMaterial(name: json['icon']))
          : null,
    );
  }
}
