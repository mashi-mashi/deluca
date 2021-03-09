import 'package:flutter/material.dart';

import '../data/firebase/firestore_reference.dart';
import '../data/firebase/firestore.dart';

class ProviderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Proverderページ'), actions: <Widget>[
        IconButton(icon: Icon(Icons.new_releases_outlined), onPressed: () {}),
      ]),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            child: Text(''),
          ),
                    Expanded(
            child: FutureBuilder<Iterable<Map<String, dynamic>>>(
              future: Firestore.getByQuery<Map<String, dynamic>>(FirestoreReference.providers().orderBy('createdAt')),
              builder: (context, documents) {
                // データが取得できた場合
                if (documents.hasData) {
                  // 取得した投稿メッセージ一覧を元にリスト表示
                  return ListView(
                    children: documents.data.map((document) {
                      return Card(
                        child: ListTile(
                          title: Text(document['title'] as String),
                          subtitle: Text(document['feedUrl'] as String),
                        ),
                      );
                    }).toList(),
                  );
                }
                // データが読込中の場合
                return Center(
                  child: Text('読込中...'),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
