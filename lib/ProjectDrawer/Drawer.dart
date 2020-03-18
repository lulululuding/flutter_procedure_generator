import 'package:flutter/material.dart';
import 'package:web_app/ProjectDrawer/Dialogues.dart';
import 'package:web_app/topLevel/home.dart' as home;
import 'package:web_app/utils/fileDownload.dart';
import 'package:web_app/utils/generateKey.dart';
import 'package:web_app/utils/loadProject.dart';
import './Project.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer({this.updateCbk});
  final Function updateCbk;
  @override
  MyDrawerState createState() => MyDrawerState();
}

class MyDrawerState extends State<MyDrawer> {
  static int currentIndex;

  @override
  void initState() {
    super.initState();
    if (projects.length > 0){
      if (currentIndex == null){
        currentIndex = 0;
      }
    }
  }

  _callback(index){
    if (index == currentIndex || home.status == LoadRemoteProject.isLoading) return;
    currentIndex = index;
    setState(() {});
    Future.delayed(const Duration(milliseconds: 300)).then((_){
      home.status = LoadRemoteProject.isLoading;
      home.streamCtn.sink.add(index);
      widget.updateCbk(index);
    });
  }

  List<Widget> _createProjects(){
    int i = -1;
    return projects.map((project){
      ++i;
      return ProjectItem(project,i == currentIndex,i,selectCbk: _callback,delCbk: _delDialogue,);
    }).toList();
  }

  _addProject(String name){
    List<String> keys = getTime();
    projects.add(Project(title:name,lastUpdatedAt: '刚刚',id:'${home.USERNAME}&${keys[0]}'));
    setState(() {});
  }

  _delDialogue(index){
    delConfirmDialogue(context, projects[index].title, index, _delProject);
  }

  _delProject(index){
    String id = projects[index].id;
    projects.removeAt(index);
    setState(() {});
    projectDel(id);
    loadedProject.remove(id);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.9),
      height: MediaQuery.of(context).size.height,
      width: 300,
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 50,vertical: 5),
            child: RaisedButton(
              color: Colors.green,
              onPressed: (){
                addDialogue(context,_addProject);
              },
              child: Center(child:Text('新建项目')),
            ),
          )
        ]..addAll(_createProjects()),
      ),
    );
  }
}

class ProjectItem extends StatelessWidget {
  ProjectItem(this.project,this.isSelected,this.index,{@required this.selectCbk,@required this.delCbk});
  final Project project;
  final bool isSelected;
  final Function selectCbk;
  final Function delCbk;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        selectCbk(index);
      },
      child: Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(
            color:isSelected ? Colors.blue : Colors.grey,
          )
        )
      ),
      height: 50,
      width: double.infinity,
      margin:EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(project.title,style: TextStyle(color: isSelected ? Colors.blue : Colors.black),),
              Text('上次修改于  ${project.lastUpdatedAt}',style: TextStyle(color: isSelected ? Colors.blue : Colors.black))
            ],
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.red
              ),
              child: Text('删除'),
            ),
            onTap: (){
              delCbk(index);
            },
          )
        ],
      ),
    ),
    );
  }
}

