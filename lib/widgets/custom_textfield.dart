import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key key,
    @required Function onChanged,
    String hintText = 'Enter Something',
    @required TextEditingController controller,
  })  : _onChanged = onChanged,
        _hintText = hintText,
        _controller = controller,
        super(key: key);

  final Function _onChanged;
  final String _hintText;
  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: _controller,
        onChanged: _onChanged,
        decoration: InputDecoration(
          hintText: _hintText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
