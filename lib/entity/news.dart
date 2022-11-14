/// 用于装在从 api 接口返回的新闻数据
class News{
  int? code;
  String? msg;
  String? ctime;
  String? title;
  String? description;
  String? picUrl;
  String? url;

  News({this.code,this.msg,this.ctime,this.title,this.description,this.picUrl,this.url});

  factory News.fromJson(Map<String,dynamic> json){
    return News(
      code: json['code'],
      msg: json['msg'],
      ctime: json['ctime'],
      title: json['title'],
      description: json['description'],
      picUrl: json['picUrl'],
      url: json['url']
    );
  }
}