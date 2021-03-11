import 'package:deluca/data/firebase/firestore.dart';
import 'package:deluca/data/firebase/firestore_reference.dart';
import 'package:flutter/material.dart';

class Article {
  String title;
  String url;
  DateTime createdAt;

  Article(this.title, this.url, this.createdAt);
}

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ListTile makeListTile(Article article) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          // leading: Container(
          //   padding: EdgeInsets.only(right: 12.0),
          //   decoration: BoxDecoration(
          //       border: Border(
          //           right: BorderSide(width: 1.0, color: Colors.white24))),
          // ),
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
                    child: Text(article.url,
                        style: TextStyle(color: Colors.white))),
              ),
            ],
          ),
          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
        );

    Card makeCard(Article article) {
      print('makee ${article.title}');
      return Card(
        elevation: 8.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
          child: makeListTile(article),
        ),
      );
    }

    Future<List<Map<String, dynamic>>> fetch() async =>
        Firestore.getByQuery<Map<String, dynamic>>(
            FirestoreReference.articles().orderBy('createdAt').limit(10));

    return Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        body: Column(children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            child: Text(''),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetch(),
              builder: (context, documents) {
                // データが取得できた場合
                if (documents.hasData) {
                  final articles = documents.data!
                      .map((d) => Article(d['title'] as String,
                          d['url'] as String, DateTime.now()))
                      .toList();
                  print('llllll ${articles.length}');
                  return Container(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: documents.data!.length,
                        itemBuilder: (context, index) =>
                            makeCard(articles[index])),
                  );
                }
                return Center(
                  child: Text('読込中...'),
                );
              },
            ),
          )
        ]));
  }
}
