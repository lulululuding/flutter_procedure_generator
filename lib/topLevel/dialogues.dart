import 'package:flutter/material.dart';
import 'package:web_app/topLevel/home.dart';
import 'package:web_app/utils/loadProject.dart';

Future<void> addChapterDialogue (BuildContext context,{Function isExisted,Function addChapter}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text('新增测试章节'),
        contentPadding: EdgeInsets.only(
          top: 40,
          bottom: 20,
          left: 24,
          right: 24
        ),
        children: <Widget>[
          DialogueContent(context,isExisted: isExisted,addChapter: addChapter)
        ],
      );
    },
  );
}

class DialogueContent extends StatefulWidget {
  final Function isExisted;
  final Function addChapter;
  final BuildContext context;
  DialogueContent(this.context,{@required this.isExisted,@required this.addChapter});
  @override
  _DialogueContentState createState() => _DialogueContentState();
}

class _DialogueContentState extends State<DialogueContent> {
  String errCode;
  String hint;
  bool isAllowed;
  Widget err;

  _update(String str,bool isErrCode){
    if(isErrCode){
      errCode = str;
    } else {
      hint = str;
    }

    if(errCode == '' || hint == ''){
      return;
    }

    if( widget.isExisted(errCode:errCode,title:hint) ){
      err = Text('该标题已存在 请更换错误码或者章节标题',style: TextStyle(
        fontSize: 14,
        color: Colors.red
      ));
      setState(() {});
      return;
    } else {
      err = Container();
      isAllowed = true;
      setState(() {});
    }

  }

  @override
  void initState() {
    isAllowed = false;
    errCode = '';
    hint = '';
    err = Container();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ConfigTextField('错误码',_update),
          ConfigTextField('章节标题',_update),
          err,
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(child: Text('取消'),onPressed: (){Navigator.of(widget.context).pop();}),
              RaisedButton(
                child:Text('确认添加'),
                onPressed:isAllowed ? (){
                 widget.addChapter('$errCode-$hint');
                 Navigator.pop(widget.context);
                } : null,
                color: Colors.blue[700],
                disabledColor: Colors.blue[200],
              )
            ],
          ),

        ],
      ),
    );
  }
}

loginDialogue(BuildContext context,Function callback){
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text('登录'),
        contentPadding: EdgeInsets.only(
            top: 40,
            bottom: 20,
            left: 24,
            right: 24
        ),
        children: <Widget>[
          ConfigTextField("用户名", _loginInput),
          ConfigTextField("密码", _loginInput),
          Login(callback,context)
        ],
      );
    },
  );
}

_loginInput(String str,bool isUsername){
  if(isUsername) {_username = str;}
  else {_password = str;}
}

class Login extends StatefulWidget {
  final Function callback;
  final BuildContext _con;
  Login(this.callback,this._con);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Widget con;

  @override
  void initState() {
    super.initState();
    con = Container();
    _username = '';
    _password = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          con,
          RaisedButton(
            child: Text('登录'),
            color: Colors.blue,
            onPressed: (){
              if(_username == '' || _password == '') return;
              _login();
            },
          )
        ],
      ),
    );
  }

  _login() async {
    final bool res = await login(_username, _password);
    if(res){
      Navigator.pop(widget._con);
      USERNAME = _username;
      widget.callback();
    } else {
      con = Text('登陆失败',style: TextStyle(color: Colors.red));
      setState(() {});
    }
  }

}

String _username= '';
String _password = '';


class ConfigTextField extends StatelessWidget {
  final String title;
  final Function callback;
  ConfigTextField(this.title,this.callback);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*.4,
      height: 55,
      margin: EdgeInsets.symmetric(vertical: 15),
      child: TextField(
        style: TextStyle(color: Colors.black,fontSize: 16),
        onChanged: (String str){
          bool isErrCode;
          if(title == '错误码' || title == '用户名'){
            isErrCode = true;
          } else {
            isErrCode = false;
          }
          callback(str.trim(),isErrCode);
        },
        maxLines: 1,
        maxLength: 30,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 6,vertical: 4),
          hintText: '在这里输入$title'
        ),
      ),
    );
  }
}


