import 'package:deluca/data/provider/pick_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PickPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: HookBuilder(builder: (context) {
      final futurePicks = useProvider(pickListProvider);
      final snapshot = useFuture(futurePicks, initialData: null);

      if (snapshot.hasData) {
        final picks = snapshot.data
            ?.map((pick) => GestureDetector(
                onTap: () {
                },
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(233, 233, 233, 1),
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromRGBO(233, 233, 233, 1),
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      SizedBox(
                        width: 30.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              pick.id,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              pick.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color.fromRGBO(139, 144, 165, 1),
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              children: [
                                Text(
                                  pick.id,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  ' | ',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  pick.id,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Color.fromRGBO(251, 89, 84, 1),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )))
            .toList();
        return ListView(children: picks ?? [Center(child: Text('データがありません'))]);
      } else {
        return Center(child: CircularProgressIndicator());
      }
    }));
  }
}
