import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectImagePage extends StatelessWidget {
  SelectImagePage({super.key});



  @override
  Widget build(BuildContext context) {

    final List<String> pathList = [
      for (int i = 1; i < 6; i++) 'assets/images/select/profile-$i.jpg',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("头像选择")),
      body: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(pathList.length, (index) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: Image.asset(pathList[index]),
                onTap: (){
                  Navigator.pop(context, pathList[index]);
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}
