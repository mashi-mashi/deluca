import 'package:deluca/data/provider/pick_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PickPage extends StatelessWidget {
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
    }));
  }
}
