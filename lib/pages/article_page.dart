import 'package:deluca/data/pick_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ArticlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: HookBuilder(builder: (context) {
      final futurePickList = useProvider(pickListProvider);
      final snapshot = useFuture(futurePickList, initialData: null);

      if (snapshot.hasData) {
        final picks = snapshot.data
            ?.map((pick) => Card(
                  child: ListTile(
                    title: Text(pick.id),
                    subtitle: Text(pick.title),
                  ),
                ))
            .toList();
        return ListView(children: picks ?? [Center(child: Text('データがありません'))]);
      } else {
        return Center(child: CircularProgressIndicator());
      }
    })
        // body: Column(
        //   children: <Widget>[
        //     Container(
        //       padding: EdgeInsets.all(8),
        //       child: Text(''),
        //     ),
        //     Expanded(
        //       child: FutureBuilder<Iterable<Map<String, dynamic>>>(
        //         future: Firestore.getByQuery<Map<String, dynamic>>(
        //             FirestoreReference.providers().orderBy('createdAt')),
        //         builder: (context, documents) {
        //           // データが取得できた場合
        //           if (documents.hasData) {
        //             // 取得した投稿メッセージ一覧を元にリスト表示
        //             return ListView(
        //               children: documents.data!.map((document) {
        //                 return Card(
        //                   child: ListTile(
        //                     title: Text(document['title'] as String),
        //                     subtitle: Text(document['feedUrl'] as String),
        //                   ),
        //                 );
        //               }).toList(),
        //             );
        //           }
        //           // データが読込中の場合
        //           return Center(
        //             child: Text('読込中...'),
        //           );
        //         },
        //       ),
        //     )
        //   ],
        // ),
        );
  }
}
