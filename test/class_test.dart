import 'package:FakeQQ/database/database.dart';
import 'package:FakeQQ/entity/news.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';


void main(){
  group("测试用户和新闻类设计", () {
    test("测试用户类", (){
      QQUser testUser = QQUser.create(1, '5120205830', 'wangxiande', '123456', 'null');

      expect(testUser.nickname, 'wangxiande');
      expect(testUser.userId, 1);
    });

    test("测试新闻类的创建", (){
      String jsonString = "{\"id\":\"0d167e6d767660bdc4c7adca8ede2ed5\",\"ctime\":\"2022-11-08 14:00:29\",\"title\":\"丰田考斯特16座多少钱 豪华汇报商务版\",\"description\":\"丰田考斯特16座多少钱豪华汇报商务版\",\"source\":\"车讯网\",\"picUrl\":\"https://img1.chexun.com/chexunimg/erpimg/2022/1108/icon_0_0_3af5d68d60b648e59122ba2fed0a1f03.jpg\",\"url\":\"http://www.chexun.com/2022-11-08/113789647.html\"}";
      const JsonDecoder jsonDecoder =  JsonDecoder();
      Map<String, dynamic> jsonMap = jsonDecoder.convert(jsonString);
      News temp = News.fromJson(jsonMap);
      expect(temp.ctime, "2022-11-08 14:00:29");
    });
  });
}