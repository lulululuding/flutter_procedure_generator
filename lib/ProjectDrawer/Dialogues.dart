import 'package:flutter/material.dart';

delConfirmDialogue(BuildContext con,String title,int index,Function cbk){
  return showDialog(
    context: con,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text("删除项目"),
        contentPadding: EdgeInsets.only(
            top: 20,
            bottom: 20,
            left: 24,
            right: 24
        ),
        children: <Widget>[
          Text('确认删除$title吗,一旦删除，数据将无法恢复。'),
          Container(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(child: Text('取消'),onPressed: (){Navigator.of(context).pop();}),
                SizedBox(width: 30,),
                RaisedButton(
                  child:Text('确认'),
                  onPressed:(){
                    cbk(index);
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

addDialogue(context,callback){
  projectName = '';
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text("增加项目"),
        contentPadding: EdgeInsets.only(
            top: 40,
            bottom: 20,
            left: 24,
            right: 24
        ),
        children: <Widget>[
          ProjectTextField('项目名'),
          Container(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(child: Text('取消'),onPressed: (){Navigator.of(context).pop();}),
                RaisedButton(
                  child:Text('确认添加'),
                  onPressed:(){
                    if(projectName == '') return;
                    callback(projectName);
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

String projectName;

class ProjectTextField extends StatelessWidget {
  ProjectTextField(this.title);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width*.4,
      margin: EdgeInsets.symmetric(vertical: 15),
      child: TextField(
        style: TextStyle(color: Colors.black,fontSize: 16),
        onChanged: (String str){
          projectName = str.trim();
        },
        maxLines: 1,
        maxLength: 30,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 6,vertical: 4),
            hintText: '在这里输入$title',
            helperText:'请输入$title，此项为必填项'
        ),
      ),
    );
  }
} 