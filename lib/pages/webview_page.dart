import 'package:deluca/data/provider/article_provider.dart';
import 'package:deluca/data/provider/pick_provider.dart';
import 'package:deluca/pages/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  WebViewPage({Key? key, required this.article}) : super(key: key);
  final Article article;

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
          title: Text(widget.article.title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined),
            onPressed: () async {
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return HomePage();
                }),
              );
            },
          ),
        ),
        body: IndexedStack(index: position, children: [
          WebView(
            initialUrl: widget.article.url,
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
        floatingActionButton: HookBuilder(builder: (context) {
          final pickModel = useProvider(pickProvider);
          return Container(
              margin: EdgeInsets.only(bottom: 25.0),
              child: SpeedDial(
                icon: Icons.menu_outlined,
                backgroundColor: Colors.black54,
                foregroundColor: Colors.white,
                activeIcon: Icons.remove,
                closeManually: false,
                buttonSize: 56.0,
                visible: true,
                elevation: 8.0,
                shape: CircleBorder(),
                children: [
                  SpeedDialChild(
                    child: Icon(Icons.favorite),
                    backgroundColor: Colors.black54,
                    foregroundColor: Colors.white,
                    onTap: () async {
                      await pickModel.add(
                          id: widget.article.id,
                          title: widget.article.title,
                          url: widget.article.url,
                          providerId: widget.article.providerId);
                    },
                  ),
                  SpeedDialChild(
                    child: Icon(Icons.copy_outlined),
                    backgroundColor: Colors.black54,
                    foregroundColor: Colors.white,
                    // label: 'Second',
                    // labelStyle: TextStyle(fontSize: 18.0),
                    onTap: () async {
                      await Clipboard.setData(
                          ClipboardData(text: widget.article.url));
                    },
                  ),
                ],
              ));
        }));
  }
}
