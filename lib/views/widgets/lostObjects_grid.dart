import 'package:flutter/material.dart';
import 'package:myapp/models/lost_object_model.dart';
import 'package:myapp/views/widgets/object_card.dart';

class LostObjectsGrid extends StatelessWidget {
  final List<LostObject> newLostObjects;

  const LostObjectsGrid({
    Key? key,
    required this.newLostObjects,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.5,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (newLostObjects.isEmpty) {
              return const SizedBox.shrink();
            }
            double width = MediaQuery.of(context).size.width / 2 - 12;
            double height = width / 0.6;
            LostObject lostObject = newLostObjects[index];
            return ObjectCard(
              lostObject: lostObject,
              width: width,
              height: height,
            );
          },
          childCount: newLostObjects.length,
        ),
      ),
    );
  }
}
