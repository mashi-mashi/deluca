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
            // SizedBox(
            //   height: 20.0,
            // ),
            // Text(
            //   'Select your \nfavorite section.',
            //   style: TextStyle(
            //     fontSize: 24.0,
            //     fontWeight: FontWeight.w600,
            //   ),
            // ),
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
                  onTap: () {
                    selectUnselect(index);
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
  final int id;
  final String title;
  final Widget icon;

  Category({required this.id, required this.title, required this.icon});
}

class StaticData {
  static List<Category> categories = [
    Category(
      id: 1,
      title: 'Most Popular',
      icon: Icon(
        Icons.ac_unit,
      ),
    ),
    Category(
      id: 2,
      title: 'World',
      icon: Icon(
        Icons.ac_unit,
      ),
    ),
    Category(
      id: 3,
      title: 'Science',
      icon: Icon(
        Icons.ac_unit,
      ),
    ),
    Category(
      id: 4,
      title: 'Politics',
      icon: Icon(Icons.ac_unit),
    ),
  ];
}
