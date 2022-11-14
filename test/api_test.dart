import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

void main(){
  test('api请求测试', () async {
    String apiKey = '744cc18a73be0b692f8fbc512f98e121';
    String newsUrl =
        'http://api.tianapi.com/generalnews/index?key=${apiKey}&num=5&page=0';
    // 获取响应体
    final response = await http.get(Uri.parse(newsUrl));

    // 对响应体转码后，使用 convert 将其转为 Map 对象。
    Utf8Decoder decode = new Utf8Decoder();
    Map<String, dynamic> result =
    jsonDecode(decode.convert(response.bodyBytes));

    print(result.toString());
  });
}