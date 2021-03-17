import 'package:deluca/data/firebase/firestore.dart';
import 'package:deluca/data/firebase/firestore_reference.dart';
import 'package:deluca/pages/webview_page.dart';
import 'package:deluca/utils/timestamp_util.dart';
import 'package:flutter/material.dart';

class Article {
  String title;
  String url;
  DateTime createdAt;

  Article(this.title, this.url, this.createdAt);
}

class ListPage extends StatefulWidget {
  ListPage();

  @override
  _ListPage createState() => _ListPage();
}

class _ListPage extends State<ListPage> {
  late ScrollController? controller;
  late dynamic? _lastData;
  late bool _isLoading = true;

  late final List<Map<String, dynamic>> _data = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    controller = ScrollController()..addListener(_scrollListener);
    super.initState();
    _lastData = null;
    _isLoading = true;
    _getData();
  }

  void _scrollListener() {
    if (!_isLoading) {
      if (controller!.position.pixels == controller!.position.maxScrollExtent) {
        setState(() => _isLoading = true);
        _getData();
      }
    }
  }

  Future<dynamic> _getData() async {
    var data = _lastData == null
        ? await Firestore.getByQuery<Map<String, dynamic>>(
            FirestoreReference.articles()
                .orderBy('createdAt', descending: true)
                .limit(10))
        : await Firestore.getByQuery<Map<String, dynamic>>(
            FirestoreReference.articles()
                .orderBy('createdAt', descending: true)
                .startAfter([_lastData?['createdAt']]).limit(10));

    if (data.toList().isNotEmpty) {
      _lastData = data.toList()[data.toList().length - 1];
      if (mounted) {
        setState(() {
          _isLoading = false;
          _data.addAll(data.toList());
        });
      }
    } else {
      setState(() => _isLoading = false);
      scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('データがありません.'),
        ),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ListTile makeListTile(Article article) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          title: Text(
            article.title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                    child: LinearProgressIndicator(
                        backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                        value: 1,
                        valueColor: AlwaysStoppedAnimation(Colors.green))),
              ),
              Expanded(
                flex: 9,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                        formatDatetime(article.createdAt,
                            format: 'yyyy/MM/dd H:m'),
                        style: TextStyle(color: Colors.white))),
              ),
            ],
          ),
          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () async {
            await Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) {
                return WebViewPage(url: article.url);
              }),
            );
          },
        );

    Card makeCard(Article article) {
      print('make card ${article.title}');
      return Card(
        elevation: 8.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
          child: makeListTile(article),
        ),
      );
    }

    return Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        body: Column(children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _data.clear();
                _lastData = null;
                await _getData();
              },
              child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: controller,
                  itemCount: _data.length + 1,
                  itemBuilder: (context, index) {
                    if (index < _data.length) {
                      final d = _data[index];
                      return makeCard(Article(
                          d['title'] as String,
                          d['url'] as String,
                          dateFromTimestampValue(d['publishDate'])));
                    } else {
                      return Container();
                    }
                  }),
            ),
          )
        ]));
  }
}
