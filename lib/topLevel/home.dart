import 'dart:async';

import 'package:flutter/material.dart';
import 'package:web_app/ProjectDrawer/Project.dart';
import '../secondLevel/ConfigForm.dart';
import 'dialogues.dart';
import '../Search.dart';
import '../utils/fileDownload.dart';
import '../utils/loadProject.dart' as loader;
import '../ProjectDrawer/Drawer.dart';

StreamController streamCtn;
loader.LoadRemoteProject status;

String USERNAME = '';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool isWaiting;

  _addChapter(String key){
    AllMap[key] = {"hints":[],"btnContent":[]};
    topLevelUpdate();
  }

  bool _isExisted({@required String errCode,@required String title}){
    return AllMap.containsKey('$errCode-$title');
  }

  topLevelUpdate(){
    setState(() {});
  }

  Widget _emptyWidget(){
    return Container(
      width: MediaQuery.of(context).size.width*.6,
      height: MediaQuery.of(context).size.height*.7,
      child: Center(child: Text('您还没有选择工作的项目或当前的项目还没有内容'),),
    );
  }

  _load(index) async {
    setState(() {
      status = loader.LoadRemoteProject.isLoading;
    });
//    if (index % 2 == 0){
//      AllMap = AllMap1;
//    } else {
//      AllMap = AllMap2;
//    }
    await Future.delayed(const Duration(seconds: 1));
    if (index > (projects.length - 1)){
      return;
    }
    String pid = projects[index].id;
    if (loader.loadedProject.contains(pid)){
      AllMap = await loader.loadRemoteProject(pid);
    } else {
      AllMap = Map<String,Map>();
    }

    _loadComplete();
  }

  _loadComplete(){
    setState(() {
      status = loader.LoadRemoteProject.completeLoading;
    });
  }

  Widget _createWidget(){
    if (AllMap == null){
        return _emptyWidget();
    }
    Map map = AllMap;
    List<String> keys = AllMap.keys.toList();
    if (keys.length == 0){
      return _emptyWidget();
    }
    final double screenWidth = MediaQuery.of(context).size.width;
    return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * .05,vertical: 10),
        itemCount: keys.length,
        itemBuilder: (BuildContext context,int index){
          final Map item = map[keys[index]];
          final String key = keys[index];
          final List<String> l = key.split('-');
          final String errCode = l[0];
          final String title = l[1];
          return ExpansionTile(
            title: Text(title),
            trailing: Text(errCode),
            children: <Widget>[ConfigForm(item,key,topLevelUpdate)],
          );
        }
    );
  }

  Widget _create({int index,bool isNull = false}) {
    if (status == loader.LoadRemoteProject.isLoading){
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (projects.length < 1){
      return _emptyWidget();
    }
    return _createWidget();
  }

  _loadProjectList() async {
    projects.clear();
    await loader.loadProjectList();
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      isWaiting = false;
      status = loader.LoadRemoteProject.isLoading;
    });
    if (loader.loadedProject.length > 0) {
      Future.delayed(const Duration(seconds: 1)).then((_){
        _load(0);
      });
    } else {
      _loadComplete();
    }
  }

  @override
  void initState() {
    super.initState();
    streamCtn = StreamController();
    isWaiting = true;
    Future.delayed(const Duration(milliseconds: 500)).then((_){
      loginDialogue(context,_loadProjectList);
    });
  }

  @override
  void dispose() {
    streamCtn.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    if(isWaiting){
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.grey[200],
        elevation: 0,
        title: Text(widget.title),
        actions: <Widget>[
          RaisedButton(
            child: Text('保存'),
            onPressed: (){
              resSave();
            },
          ),
          SizedBox(
            width: 20,
          ),
          // Container(
          //   alignment: Alignment.center,
          //   margin:EdgeInsets.symmetric(vertical: 10),
          //   width: 300,
          //   child: SearchBar(),
          // ),
          SizedBox(width: screenWidth * 0.03),
          RaisedButton.icon(
              onPressed: (){addChapterDialogue(context,isExisted: _isExisted,addChapter: _addChapter);},
              icon: Icon(Icons.add,color:Colors.red),
              label: Text('新增章节')
          ),
          SizedBox(width: screenWidth * 0.05),
        ],
      ),
      body: Container(
        //padding: EdgeInsets.symmetric(horizontal: screenWidth * .1,vertical: 50),
        child: _create()
        // StreamBuilder(
        //   initialData: projects.length > 0 ? 0 : -1,
        //   stream: streamCtn.stream,
        //   builder: (context,snapshot){
        //     if(!snapshot.hasData) {return Container();}
        //     if (snapshot.data < 0){
        //       return _create(isNull: true);
        //     }
        //     return _create(index: snapshot.data);
        //   },
        // ),
      ),
      endDrawer: Drawer(
        child: MyDrawer(updateCbk: _load),
      ),
      floatingActionButton: Builder(
        builder: (BuildContext con){
          return FloatingActionButton(
            onPressed: (){
              Scaffold.of(con).openEndDrawer();
            },
            child: Center(child: Text('全部\n项目')),
            backgroundColor: Colors.green,
            hoverColor: Colors.greenAccent,
          );
        },
      ),
    );
  }
}

Map<String,dynamic> AllMap;

Map<String,Map> AllMap1 = {};

Map<String,Map> AllMap2 = {
  "P2185-冷却液温度传感器2电路电压过高 故障类别1": {
    "hints":[
      "将断线盒A56短接5V电源信号线",
      "钥匙上电置于ON档",
      "启动车辆，进行一次未决故障检测的循环",
      "熄火并保存测试文件",
      "钥匙上电置于ON档",
      "启动车辆，进行一次确认故障检测循环",
      "熄火并保存测试文件",
      "移除断线盒短路，消除故障",
      "钥匙上电置于ON档",
      "进行三个驾驶循环或特定循环，消除故障",
      "熄火并保存测试文件"
    ],
    "btnContent": [
      "确认完成",
      "开始测量",
      "确认完成",
      "保存文件",
      "开始测量",
      "确认完成",
      "保存文件",
      "确认完成",
      "开始测量",
      "确认完成",
      "保存文件"
    ]
  },
  "P0106-进气压力传感器压力超范围高故障 故障类别2":{
    "hints": [
      "将信号发生器串接在A12ECU端及A27"
    ],
    "btnContent": [
      "确认完成"
    ]
  }
};
