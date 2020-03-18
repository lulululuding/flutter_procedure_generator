import 'package:flutter/foundation.dart';

List<Project> projects = [
  // Project(title: '1',createdAt: '12',lastUpdatedAt: '6/21',id: '13'),
  // Project(title: '100',createdAt: '12000',lastUpdatedAt: '7/24',id: '13000')
];

class Project{
  String title;
  //String createdAt;
  String lastUpdatedAt;
  String id;

  Project({
    @required this.title,
    //this.createdAt,
    this.lastUpdatedAt = '刚刚',
    @required this.id
  });

  Project.fromJson(Map<String, dynamic> json)
    : title = json['title'],
    //createdAt = json['createdAt'],
    id = json['projectId'],
    lastUpdatedAt = '刚刚';

}