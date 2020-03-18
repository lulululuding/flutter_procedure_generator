import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'topLevel/home.dart' show AllMap;

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 300,
      height: 40,
      child: GestureDetector(
        onTap: (){searchDialogue(context);},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text('在这里搜索测试章节'),
            Icon(Icons.search,color: Colors.blue[700],size: 30,)
          ],
        ),
      ),
    );
  }
}



Future<void> searchDialogue (BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text('搜索测试章节'),
        contentPadding: EdgeInsets.only(
            top: 40,
            bottom: 20,
            left: 24,
            right: 24
        ),
        children: <Widget>[
          Container(
            width: screenWidth*.7,
            height: screenHeight*.7,
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: Search(),
          )
        ],
      );
    },
  );
}

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  List<Widget> _list;
  List<String> keys;
  @override
  void initState() {
    super.initState();
    _list = [];
    keys = [];
    createKeys();
  }

  createKeys(){
    keys.clear();
    keys = AllMap.keys.toList();
  }

  _onInput(input){
    _list.clear();
    List<String> indexs =  keys.where((key){return key.contains(input);}).toList();
    _list = indexs.map((index){
      int offset = index.indexOf(input);
      return GestureDetector(
        onTap: (){},
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 3),
          height: 20,
          child: ListTile(
            title: RichText( //这里使用富文本
              text: TextSpan(
                  children: [
                    //TextSpan(text: suggestionList[index].substring(query.length), style: TextStyle(color: Colors.grey)),
                    TextSpan(text: index.substring(0,offset), style: TextStyle(color: Colors.grey)),
                    TextSpan(text: index.substring(offset,offset+input.length), style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                    TextSpan(text: index.substring(offset+input.length,index.length-1), style: TextStyle(color: Colors.grey))
                  ]
              ),
            ),
          )
        ),
      );
    }).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          onChanged: _onInput,
          maxLines: 1,
          maxLength: 30,
          decoration: InputDecoration(
            hintText: '可以根据错误码或者章节描述搜索',
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 5,vertical: 3)
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView(
            children: _list,
          ),
        )
      ],
    );
  }
}






