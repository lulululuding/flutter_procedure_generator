import 'package:flutter/material.dart';
import '../topLevel/home.dart' show AllMap;
import 'dialogues.dart';
import 'InnerStep.dart';

class ConfigForm extends StatefulWidget {
  final Map map;
  final String chapterKey;
  final Function topLevelUpdate;
  ConfigForm(this.map,this.chapterKey,this.topLevelUpdate);
  @override
  _ConfigFormState createState() => _ConfigFormState();
}

class _ConfigFormState extends State<ConfigForm> {

  List<bool> isExpandedList;
  List hints;
  List btns;

  _removeChapter(){
    if(!AllMap.containsKey(widget.chapterKey)){return;}
    AllMap.remove(widget.chapterKey);
    widget.topLevelUpdate();
  }

  _onPopMenuSelected(String value,String chapterKey,int index){
    switch(value){
      case '删除':
        if( (index + 1) > hints.length ) return;
        hints.removeAt(index);
        btns.removeAt(index);
        isExpandedList.removeAt(index);
        setState(() {});
        AllMap[widget.chapterKey] = {'hints':hints,'btnContent':btns};
        break;

      case '修改':
        String lHint =widget.map['hints'][index].toString();
        String lBtn =widget.map['btnContent'][index].toString();
        addOrEditDialogue(context, true, callback: _addOrEditSteps,index: index,lHint: lHint,lBtn: lBtn);
        break;
    }
  }

  _addOrEditSteps ({@required String hint,@required String btn,bool isEdit = false,int index}) {
    if(isEdit){
      if( (index + 1) > hints.length ) return;
      hints[index] = hint;
      btns[index] = btn;
      print(btn);
      setState(() {});
    } else {
      hints.add(hint);
      btns.add(btn);
      isExpandedList.add(true);
      Future.delayed(const Duration(milliseconds: 600)).then((_){
        setState(() {});
      });
    }
    AllMap[widget.chapterKey] = {'hints':hints,'btnContent':btns};

  }

  Widget _buildSteps(){
    int count = 0;
//    List hints = widget.map['hints'] as List;
//    List btns = widget.map['btnContent'] as List;
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton.icon(
                onPressed: (){removeChapterConfirmDialogue(context,remove: _removeChapter);},
                icon: Icon(Icons.clear,color: Colors.red),
                label: Text('删除整个章节')
              ),
              SizedBox(width: 30),
              IconButton(icon: Icon(Icons.add_circle),iconSize: 25,color: Colors.green,
                onPressed: (){addOrEditDialogue(context, false, callback: _addOrEditSteps);}
              ),
            ],
          ),
          SizedBox(height: 8),
          hints.length == 0 ?
          Center(child: Text('当前还未有操作步骤'))
              :
          ExpansionPanelList(
            expansionCallback: (idx,isOpen){
              isExpandedList[idx] = !isOpen;
              setState(() {});
            },
            children: hints.map((item){
              int i = count;
              count++;
              return ExpansionPanel(
                isExpanded: isExpandedList[i],
                headerBuilder: (context,isExpanded){
                  return Text('第$i个测试');
                },
                body: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InnerStep(hint: hints[i].toString(),btn: btns[i].toString()),
                        PopupMenuButton(
                            onSelected: (value){_onPopMenuSelected(value,widget.chapterKey,i);},
                            itemBuilder: (BuildContext context) =><PopupMenuItem<String>>[
                              PopupMenuItem(value:"删除",child: Text("删除")),
                              PopupMenuItem(value: "修改",child: Text("修改")),
                            ]
                        )
                      ],
                    )
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    isExpandedList = List.generate((widget.map['hints'] as List).length, (_){return false;});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print(isExpandedList);
    hints = widget.map['hints'] as List;
    btns = widget.map['btnContent'] as List;
    return Container(
      //height: 300,
      child: _buildSteps(),
    );
  }
}