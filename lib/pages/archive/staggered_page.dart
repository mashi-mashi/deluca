import 'package:deluca/data/firebase/firestore.dart';
import 'package:deluca/data/firebase/firestore_reference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


class StaggeredPage2 extends StatelessWidget {
  Future<List> fetch() async {
    return Firestore.getByQuery<Map<String, dynamic>>(
        FirestoreReference.articles().orderBy('createdAt'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List>(
        future: fetch(),
        builder: (context, documents) {
          // データが取得できた場合
          if (documents.hasData) {
            // 取得した投稿メッセージ一覧を元にリスト表示
            return StaggeredGridView.count(
              crossAxisCount: 4, // I only need two card horizontally
              padding: const EdgeInsets.all(8),
              children: documents.data!.map((document) {
                return _Tile(Colors.green, document['title'] as String,
                    document['url'] as String);
              }).toList(),
              staggeredTiles: documents.data!
                  .map<StaggeredTile>((_) => StaggeredTile.fit(4))
                  .toList(),
              mainAxisSpacing: 3.0,
              crossAxisSpacing: 4.0, // add
            );
          }
          // データが読込中の場合
          return Center(
            child: Text('読込中...'),
          );
        },
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(this.backgroundColor, this.title, this.url);

  final Color backgroundColor;
  final String title;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: InkWell(
        onTap: () {},
        child: Container(
          height: 135,
          child: Stack(children: <Widget>[
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Image.network(
                          'https://picsum.photos/200/10',
                          fit: BoxFit.scaleDown,
                        ),
                      ],
                    ))),
            Positioned(
                top: 8,
                left: 0,
                right: 0,
                child: Container(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        subtitle: Text(
                          url,
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                )),
          ]),
        ),
      ),
    );
  }
}
