import 'package:deluca/pages/article_page.dart';
import 'package:deluca/utils/constants.dart';
import 'package:flutter/material.dart';

class CategorySelection extends StatefulWidget {
  @override
  _CategorySelectionState createState() => _CategorySelectionState();
}

class _CategorySelectionState extends State<CategorySelection> {
  List<int> selectedIndices = [];
  void selectUnselect(int index) {
    setState(() {
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index);
      } else {
        selectedIndices.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                return GestureDetector(
                  onTap: () async {
                    selectUnselect(index);
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return ArticlePage(
                          providerId: StaticData.categories[index].id,
                        );
                      }),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedIndices.contains(index)
                          ? Constants.primaryColor
                          : Color.fromRGBO(245, 246, 250, 1),
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StaticData.categories[index].icon,
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          StaticData.categories[index].title,
                        )
                      ],
                    ),
                  ),
                );
              },
              itemCount: StaticData.categories.length,
            )
          ],
        ),
      ),
    );
  }
}

class Category {
  final String id;
  final String title;
  final Widget icon;

  Category({required this.id, required this.title, required this.icon});
}

class StaticData {
  static List<Category> categories = [
    Category(
      id: '05pdQxokIqC9MJvkB76W',
      title: 'TypeScript',
      icon: Icon(
        Icons.ac_unit,
      ),
    ),
    Category(
      id: '7W95xCWlIwJkRRa9La1y',
      title: 'React',
      icon: Icon(
        Icons.ac_unit,
      ),
    ),
    Category(
      id: 'JKB8Uku6UoHn3R4wQ7Am',
      title: 'VSCode',
      icon: Icon(
        Icons.ac_unit,
      ),
    ),
    Category(
      id: 'hn5ef9fNYNIPV1bXBe2F',
      title: 'Python',
      icon: Icon(Icons.ac_unit),
    ),
  ];
}
