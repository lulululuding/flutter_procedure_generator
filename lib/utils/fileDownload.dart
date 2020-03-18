import 'package:web_app/ProjectDrawer/Project.dart';
import './loadProject.dart' show loadedProject, rootUrl;
import '../topLevel/home.dart' show AllMap,USERNAME;
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../ProjectDrawer/Drawer.dart';

resSave() async {
  Project item =  projects[MyDrawerState.currentIndex];
  String id = item.id;
  String title = item.title;
  String str = jsonEncode(AllMap);
  var res = await http.post(rootUrl+'/upload/$id', body: {'data':str,'title':title,'user':USERNAME});
  if (!loadedProject.contains(id)){
    loadedProject.add(id);
  }
  print(res);

}

projectDel(String id) async {
  http.get(rootUrl+'/projectDel/$id');
}