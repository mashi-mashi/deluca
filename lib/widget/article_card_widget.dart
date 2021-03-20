import 'package:deluca/model/article_model.dart';
import 'package:deluca/utils/constants.dart';
import 'package:deluca/utils/timestamp_util.dart';
import 'package:flutter/material.dart';

Card makeCard(Article article, Future<dynamic> Function() onTap) {
  return Card(
    elevation: 8.0,
    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
    child: Container(
      decoration: BoxDecoration(color: Constants.cardDecorationColor),
      child: makeListTile(article, onTap),
    ),
  );
}

ListTile makeListTile(Article article, Future<dynamic> Function() onTap) =>
    ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                    value: 1,
                    valueColor: AlwaysStoppedAnimation(Colors.green))),
          ),
          Expanded(
            flex: 9,
            child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                    formatDatetime(article.createdAt, format: 'yyyy/MM/dd H:m'),
                    style: TextStyle(color: Colors.white))),
          ),
        ],
      ),
      trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
      onTap: () async {
        await onTap();
      },
    );
