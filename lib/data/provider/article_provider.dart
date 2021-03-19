import 'package:deluca/data/firebase/firestore.dart';
import 'package:deluca/data/firebase/firestore_reference.dart';
import 'package:deluca/model/article_model.dart';
import 'package:deluca/utils/timestamp_util.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final articleProvider = ChangeNotifierProvider(
  (ref) => ArticleModel(),
);

class ArticleModel extends ChangeNotifier {
  ArticleModel() : super() {
    load().then((value) => value);
  }

  dynamic? _lastData;
  final List<Article> _articles = [];
  dynamic get lastData => _lastData;
  List<Article> get articles => _articles;
  //late bool _isLoading = true;
  //late final List<Map<String, dynamic>> _data = [];

  Future<void> load() async {
    final data = _lastData == null
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
      _articles.addAll(data
          .map((d) => Article(d['id'] as String, d['title'] as String,
              d['url'] as String, dateFromTimestampValue(d['publishDate'])))
          .toList());
    }

    print('last ${_lastData['title']}');

    notifyListeners();
    return;
  }
}
