import 'package:deluca/pages/main_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  WebViewPage({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  State<StatefulWidget> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  int position = 1;

  void doneLoading(String _) => setState(() => position = 0);

  void startLoading(String _) => setState(() => position = 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Webview '),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return MainPage();
                }),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add_comment),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('webviewの上に表示'),
                    );
                  });
            },
          ),
        ],
      ),
      body: IndexedStack(index: position, children: [
        WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {},
          onPageFinished: doneLoading, // indexを０にしてWebViewを表示
          onPageStarted: startLoading, // indexを1にしてプログレスインジケーターを表示
          gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
            Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
            ),
          },
        ),
        Container(
          child: Center(
            child: CircularProgressIndicator(backgroundColor: Colors.blue),
          ),
        ),
      ]),
    );
  }
}