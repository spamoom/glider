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
      print('$name: $value');
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
      case 'switch':
        return _buildSwitch(context, json);
      case 'dropdown_menu':
        return _buildDropdownButton(context, json);
      case 'radio_group':
        return _buildRadioGroup(context, json);
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

  Widget _buildSwitch(BuildContext context, Map<String, dynamic> json) {
    return SwitchListTile(
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

  Widget _buildDropdownButton(BuildContext context, Map<String, dynamic> json) {
    final List<Map<String, dynamic>> options = [];
    json['options'].forEach((option) {
      options.add(option);
    });

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: DropdownButtonFormField(
        value: _values[json['name']],
        onChanged: (value) {
          _setValue(json['name'], value);
        },
        items: options.map((option) {
          return DropdownMenuItem(
            value: option['value'],
            child: Text(option['text']),
          );
        }).toList(),
        decoration: InputDecoration(
          labelText: json['label'],
        ),
      ),
    );
  }

  Widget _buildRadioGroup(BuildContext context, Map<String, dynamic> json) {
    final List<Map<String, dynamic>> options = [];
    json['options'].forEach((option) {
      options.add(option);
    });

    final List<Widget> children = [
      Divider(),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(
          json['label'],
          style: Theme.of(context).textTheme.subtitle,
        ),
      )
    ];

    children.addAll(options.map((option) {
      return RadioListTile(
        value: option['value'],
        groupValue: _values[json['name']],
        onChanged: (value) {
          _setValue(json['name'], value);
        },
        title: option['title'] != null ? Text(option['title']) : null,
        subtitle: option['subtitle'] != null ? Text(option['subtitle']) : null,
        secondary: option['icon'] != null
            ? Icon(getIconGuessFavorMaterial(name: option['icon']))
            : null,
      );
    }).toList());

    children.add(Divider());

    return Column(
      children: children,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
