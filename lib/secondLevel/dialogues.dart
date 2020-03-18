import 'package:flutter/material.dart';

Future<void> removeChapterConfirmDialogue (BuildContext context,{Function remove}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('确认删除章节'),
        //contentPadding: ,
        content: Text('请确认是否删除该章节，一旦删除不可恢复'),
        actions: <Widget>[
          FlatButton(child: Text('取消'),onPressed: (){Navigator.pop(context);}),
          RaisedButton(
            color: Colors.blue,
            child: Text('确认删除'),
            onPressed: (){
              Navigator.pop(context);
              remove();
          })
        ],
      );
    },
  );
}

String hint;
String btn;

addOrEditDialogue(BuildContext context,bool isEdit,{@required Function callback,int index = 0,String lBtn='',String lHint=''}){
  String title;
  if(isEdit){
    hint = lHint;
    btn = lBtn;
  } else {
    hint = '';
    btn = '';
  }
  
  if(isEdit){
    title = '修改测试章节';
  } else {
    title = '新增测试章节';
  }
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text(title),
        contentPadding: EdgeInsets.only(
            top: 20,
            bottom: 20,
            left: 24,
            right: 24
        ),
        children: <Widget>[
          ConfigTextField('操作提示',StepItemType.HINT,local: lHint),
          ConfigTextField('按钮内容',StepItemType.BTN,local: lBtn),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _createDefaultBtn("开始测量", Colors.blue[200]),
              _createDefaultBtn("保存文件", Colors.green[200]),
              _createDefaultBtn("确认完成", Colors.yellow[200])
            ],
          ),
          Container(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(child: Text('取消'),onPressed: (){Navigator.of(context).pop();}),
                RaisedButton(
                  child:Text(isEdit ? '确认修改' : '确认添加'),
                  onPressed:(){
                    if(!_isAllowed()) return;
                    callback(hint:hint,btn:btn,isEdit:isEdit,index:index);
                    Navigator.pop(context);
                  },
                  color: Colors.blue[700],
                  disabledColor: Colors.blue[200],
                )
              ],
            ),
          )
        ],
      );
    },
  );
}

class ConfigTextField extends StatefulWidget {
  @override
  _ConfigTextFieldState createState() => _ConfigTextFieldState();
  final String title;
  final StepItemType itemType;
  final String local;
  //final Function callback;
  ConfigTextField(this.title,this.itemType,{this.local = ''});

}

class _ConfigTextFieldState extends State<ConfigTextField> {
  TextEditingController _con;

  @override
  void initState() {
    if(widget.itemType == StepItemType.BTN){
      _con = _btnCon;
      _con.clear();
    } else {
      _con = TextEditingController();
    }
    if(widget.local != ""){
      _con.text = widget.local;
    }
    super.initState();
  }

  @override
  void dispose() {
    if(widget.itemType == StepItemType.HINT){
      _con.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*.4,
      //height: 55,
      margin: EdgeInsets.symmetric(vertical: 15),
      child: TextField(
        controller: _con,
        style: TextStyle(color: Colors.black,fontSize: 16),
        onChanged: (String str){
          _input(str, widget.itemType);
        },
        maxLines: 1,
        maxLength: 30,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 6,vertical: 4),
            hintText: '在这里输入${widget.title}',
            //helperText:'请输入${widget.title}，此项为必填项'
        ),
      ),
    );
  }
}

enum StepItemType {
  HINT,
  BTN,
}

_input(String str,StepItemType type){
  switch(type){
    case StepItemType.HINT:
      hint = str.trim();
      break;
    case StepItemType.BTN:
      btn = str.trim();
      break;
  }
}

bool _isAllowed(){
  if(hint == ''  || btn =='' ){
    return false;
  } else {
    return true;
  }
}

TextEditingController _btnCon = TextEditingController();

Widget _createDefaultBtn(String btn,Color color){
  return GestureDetector(
    onTap: (){
      _input(btn, StepItemType.BTN);
      _btnCon.text = btn;
    },
    child: Container(
      margin: EdgeInsets.only(right: 20),
      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
      color: color,
      child: Center(child: Text(btn)),
    ),
  );
}