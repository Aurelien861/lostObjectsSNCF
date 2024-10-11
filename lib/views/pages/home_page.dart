import 'package:flutter/material.dart';
import 'package:myapp/providers/lost_objects_provider.dart';
import 'package:myapp/utils/theme.dart';
import 'package:myapp/utils/util_functions.dart';
import 'package:myapp/views/widgets/filters/filter_section.dart';
import 'package:myapp/views/widgets/lostObjects_grid.dart';
import 'package:myapp/views/widgets/sort_section.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  __HomePageState createState() => __HomePageState();
}

class __HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final lostObjectsProvider =
        Provider.of<LostObjectsProvider>(context, listen: false);
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !lostObjectsProvider.isLoading) {
      lostObjectsProvider.loadMoreObjects();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lostObjectsProvider = Provider.of<LostObjectsProvider>(context);

    final newLostObjects = lostObjectsProvider.newLostObjects;
    final formerLostObjects = lostObjectsProvider.formerLostObjects;
    final filteredLostObjects = lostObjectsProvider.filteredLostObjects;
    final newObjectsCount = formatLargeNumber(lostObjectsProvider.newCount);
    final formerObjectsCount =
        formatLargeNumber(lostObjectsProvider.formerCount);
    final filteredObjectsCount =
        formatLargeNumber(lostObjectsProvider.filteredCount);

    return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 64),
                  Center(
                    child: Image.asset(
                      'assets/images/background_sncf.png',
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Un objet perdu ? 🙃",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Recherchez votre bien, peut être que nous l'avons retrouvé...",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        const SizedBox(height: 32),
                        SortSection(lostObjectsProvider: lostObjectsProvider),
                        FilterSection(lostObjectsProvider: lostObjectsProvider)
                      ],
                    ),
                  )
                ],
              ),
            ),
            if (filteredLostObjects.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        "$filteredObjectsCount objets trouvés",
                        style: const TextStyle(color: AppTheme.teaGreenColor),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: AppTheme.teaGreenColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              LostObjectsGrid(newLostObjects: filteredLostObjects),
            ],
            if (newLostObjects.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        "$newObjectsCount nouveaux objets",
                        style: const TextStyle(color: AppTheme.teaGreenColor),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: AppTheme.teaGreenColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              LostObjectsGrid(newLostObjects: newLostObjects),
            ],
            if (formerLostObjects.isNotEmpty) ...[
              SliverToBoxAdapter(
                  child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      "$formerObjectsCount objets déjà consultés",
                      style: const TextStyle(color: AppTheme.teaGreenColor),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 2,
                        color: AppTheme.teaGreenColor,
                      ),
                    ),
                  ],
                ),
              )),
              LostObjectsGrid(newLostObjects: formerLostObjects),
            ],
            SliverToBoxAdapter(
              child: lostObjectsProvider.isLoading
                  ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: const Center(
                          child: CircularProgressIndicator(
                        color: AppTheme.coolGrayColor,
                      )),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ));
  }
}
