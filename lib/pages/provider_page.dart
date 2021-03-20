import 'package:deluca/data/provider/provider_provider.dart';
import 'package:deluca/data/provider/user_subscription_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProviderSelection extends StatefulWidget {
  @override
  _ProviderSelectionState createState() => _ProviderSelectionState();
}

class _ProviderSelectionState extends State<ProviderSelection> {
  List<String> selectedIds = [];

  @override
  void initState() {
    super.initState();
    Future(() async {
      final ids =
          (await UserSubscriptionModel().load()).map((s) => s.providerId);
      print('ids - ${ids.toString()}');
      selectedIds = ids.toList();
    });
  }

  Future<void> selectUnselect(DelucaProvider provider) async {
    if (selectedIds.contains(provider.id)) {
      setState(() {
        selectedIds.remove(provider.id);
      });
      await UserSubscriptionModel().delete(provider);
    } else {
      setState(() {
        selectedIds.add(provider.id);
      });
      await UserSubscriptionModel().add(provider);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: HookBuilder(builder: (context) {
      final providerModel = useProvider(providerProvider);
      final snapshot =
          useFuture(useMemoized(providerModel.loadAll, []), initialData: null);

      return snapshot.connectionState == ConnectionState.waiting
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                      ),
                      itemBuilder: (context, index) {
                        final provider = providerModel.providers[index];
                        return GestureDetector(
                          onTap: () async {
                            await selectUnselect(provider);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selectedIds.contains(provider.id)
                                  ? Color.fromRGBO(251, 89, 84, 1)
                                  : Color.fromRGBO(245, 246, 250, 1),
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.ac_unit,
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  provider.name,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: providerModel.providers.length,
                    )
                  ],
                ),
              ),
            );
    }));
  }
}
