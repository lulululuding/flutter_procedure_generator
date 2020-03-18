import 'dart:async';
import 'dart:convert';
import 'package:web_app/ProjectDrawer/Project.dart';

//import '../topLevel/home.dart' show AllMap;
import 'package:http/http.dart' as http;
import 'package:web_app/topLevel/home.dart';

List<String> loadedProject = [];

const String rootUrl = 'http://localhost:3000';
//const String rootUrl = 'http://49.234.235.46:3000';

enum LoadRemoteProject {
  isLoading,
  completeLoading,
}

loadRemoteProject(id) async {
  http.Response res = await http.get(rootUrl+'/upload/$id');
  Map<String,dynamic> map = (jsonDecode(res.body)).cast()['data'];
  //print(map);
  return map;
}

Future<void> loadProjectList() async {
  var res = await http.get(rootUrl+'/projectList/' + USERNAME);
  if (res.statusCode != 200){
    print('error');
    return;
  }
  Map map = (jsonDecode(res.body)).cast();
  List l = map['data'];
  loadedProject.clear();
  l.forEach((item){
    Project project = Project.fromJson(item);
    projects.add(project);
    loadedProject.add(project.id);
  });
  //print(projects);
  await Future.delayed(const Duration(milliseconds: 500));
}

Future<bool> login(String username,String password) async {
  var res = await http.post(rootUrl+'/login',body: {'username':username,'password':password});
  if (res.statusCode != 200){
    print('error');
    return false;
  }
  Map map = (jsonDecode(res.body)).cast();
  String status = map['status'] as String;
  if(status == 'ok'){
    return true;
  } else {
    return false;
  }
}