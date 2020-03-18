List<String> getTime () {
  DateTime now = DateTime.now();
  String time = now.toString();
  String key =  time.replaceAll(RegExp(' '), '').replaceAll(RegExp(':'),'').split('.')[0]; // 2019-08-1214:32:31
  String nowDate = time.split(' ')[0];  // 2019-08-12
  return [key,nowDate];
}