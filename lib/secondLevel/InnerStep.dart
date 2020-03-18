import 'package:flutter/material.dart';

class InnerStep extends StatelessWidget {
  InnerStep({@required this.hint,@required this.btn});
  final String hint;
  final String btn;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Text('操作提示：'),SizedBox(width: 10),Text(hint,style: TextStyle(fontStyle: FontStyle.italic,color: Colors.blue))
        ],mainAxisSize: MainAxisSize.min),
        SizedBox(height: 5),
        Row(children: <Widget>[
          Text('按钮内容：'),SizedBox(width: 10),Text(btn,style: TextStyle(fontStyle: FontStyle.italic,color: Colors.blue))
        ],mainAxisSize: MainAxisSize.min),
      ],
    );
  }
}

