import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class NewsDetail extends StatefulWidget {
  final String url;
  final String title;
  const NewsDetail({Key? key, required this.url, required this.title})
      : super(key: key);

  @override
  State<NewsDetail> createState() => NewsDetailState();
}

class NewsDetailState extends State<NewsDetail> {
  bool loaded = false;

  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    // 使用 FlutterWebViewPlugin 插件监听对象的加载速度
    flutterWebViewPlugin.onStateChanged.listen((state) {
      print('state : ${state.type}');
      if (state.type == WebViewState.finishLoad) {
        setState(() {
          loaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> titleContent = [];
    titleContent.add(Text(
      widget.title,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 20.0),
    ));
    if (!loaded) {
      titleContent.add(CupertinoActivityIndicator());
    }
    titleContent.add(Container(width: 50.0));

    return Scaffold(
        body: WebviewScaffold(
          url: widget.url,
          appBar: AppBar(
            title: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: titleContent,
              ),
            ),
          ),
          withZoom: false,
          withLocalStorage: true,
          withJavascript: true,
        ),
    );
  }


}
