import 'package:deluca/model/firestore_provider_model.dart';
import 'package:flutter/material.dart';

import '../data/firebase/firestore.dart';
import '../data/firebase/firestore_reference.dart';

class ProviderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: Firestore.getByQuery<Map<String, dynamic>>(
                  FirestoreReference.providers().orderBy('createdAt')),
              builder: (context, documents) {
                // データが取得できた場合
                if (documents.hasData) {
                  // 取得した投稿メッセージ一覧を元にリスト表示
                  return ListView(
                    children: documents.data!
                        .map((d) => FirestoreProviderModel.fromJson(d))
                        .map((provider) {
                      return Card(
                        child: ListTile(
                          title: Text(provider.title),
                          subtitle: Text(provider.feedUrl),
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
