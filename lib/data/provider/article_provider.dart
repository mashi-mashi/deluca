import 'package:deluca/data/firebase/firestore.dart';
import 'package:deluca/data/firebase/firestore_reference.dart';
import 'package:deluca/utils/timestamp_util.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final FIRESTORE_LOAD_LIMIT = 15;

class Article {
  String id;
  String title;
  String url;
  String providerId;
  String providerName;
  DateTime createdAt;

  Article(
      {required this.id,
      required this.title,
      required this.url,
      required this.createdAt,
      required this.providerId,
      required this.providerName});
}

final articleProvider = ChangeNotifierProvider(
  (ref) => ArticleModel(),
);

class ArticleModel extends ChangeNotifier {
  ArticleModel() : super() {
    load(_providerId);
  }

  String _providerId = 'yfPbqBaR803SvcAvELCz';
  String get providerId => _providerId;
  String providerName = '';
  dynamic? _lastData;
  final List<Article> _articles = [];
  dynamic get lastData => _lastData;
  List<Article> get articles => _articles;

  Future<void> getProvider() async {
    final data =
        await Firestore.get(FirestoreReference.providers().doc(_providerId));
    providerName = data['title'].toString();
  }

  Future<void> load(String providerId) async {
    print('load - providerId: ${providerId.toString()}');

    _providerId = providerId;
    final data = await Firestore.getByQuery<Map<String, dynamic>>(
        FirestoreReference.providerArticles(_providerId)
            .orderBy('publishDate', descending: true)
            .limit(FIRESTORE_LOAD_LIMIT));

    if (data.toList().isNotEmpty) {
      _lastData = data.toList()[data.toList().length - 1];
      _articles.clear();
      _articles.addAll(data
          .map((d) => Article(
                id: d['id'].toString(),
                title: d['title'].toString(),
                url: d['url'].toString(),
                createdAt: dateFromTimestampValue(d['publishDate']),
                providerId: providerId,
                providerName: providerName,
              ))
          .toList());

      print(
          'length - ${articles.length.toString()} lastdata - ${_lastData['title'].toString()}');
    }
    notifyListeners();

    return;
  }

  Future<void> loadNext(dynamic lastCreatedAt) async {
    if (_providerId.isEmpty) {
      return;
    }

    final data = await Firestore.getByQuery<Map<String, dynamic>>(
        FirestoreReference.providerArticles(_providerId)
            .orderBy('publishDate', descending: true)
            .startAfter([timestampFromDateValue(lastCreatedAt)]).limit(
                FIRESTORE_LOAD_LIMIT));

    if (data.toList().isNotEmpty) {
      _lastData = data.toList()[data.toList().length - 1];
      _articles.addAll(data
          .map((d) => Article(
                id: d['id'].toString(),
                title: d['title'].toString(),
                url: d['url'].toString(),
                createdAt: dateFromTimestampValue(d['publishDate']),
                providerId: providerId,
                providerName: '',
              ))
          .toList());

      print(
          'loadNext length - ${articles.length.toString()} lastdata - ${_lastData['title'].toString()}');
    }

    notifyListeners();
    return;
  }
}
