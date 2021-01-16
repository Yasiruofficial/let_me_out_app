import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final Function(String) setValueToString;
  final String title;
  final bool isPassword;
  final Icon icon;

  CustomTextField(this.setValueToString, this.title, this.icon,
      {this.isPassword = false});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Field can not be empty";
                }
                return null;
              },
              onSaved: (newValue) {
                widget.setValueToString(newValue);
              },
              obscureText: widget.isPassword,
              decoration: InputDecoration(
                hintText: widget.title,
                icon: widget.icon,
              ))
        ],
      ),
    );
  }
}
