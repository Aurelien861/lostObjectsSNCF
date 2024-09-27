import 'package:flutter/material.dart';
import 'package:myapp/models/lost_object_model.dart';
import 'package:myapp/providers/lost_objects_provider.dart';
import 'package:myapp/utils/util_functions.dart';
import 'package:myapp/views/object_card.dart';
import 'package:provider/provider.dart';

class LazyLoadingGrid extends StatefulWidget {
  @override
  _LazyLoadingGridState createState() => _LazyLoadingGridState();
}

class _LazyLoadingGridState extends State<LazyLoadingGrid> {
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


  Widget _buildLoadingIndicator(bool isLoadingMore) {
    if (isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF9B9ECE),
          ),
        ),
      );
    } else {
      return SizedBox.shrink(); // Ne rien afficher s'il n'y a pas de chargement
    }
  }

  @override
  Widget build(BuildContext context) {
    final lostObjectsProvider = Provider.of<LostObjectsProvider>(context);

    if (lostObjectsProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF9B9ECE),
        ),
      );
    }
    final lostObjects = lostObjectsProvider.lostObjects;
    final objectCount = lostObjects.length;
    final newObjectsCount = formatLargeNumber(lostObjectsProvider.totalCount);
    return Padding(
        padding: EdgeInsets.all(16),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // En-tête fixe
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Center(
                    child: Image.asset(
                      'assets/images/background_sncf.png',
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Un objet perdu ? 🙃",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Recherchez votre objet, peut être que nous l'avons retrouvé...",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 32),
                  _buildFilterSection(context),
                  const SizedBox(height: 16),
                  _buildCustomFilterSection(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        "$newObjectsCount nouveaux objets",
                        style: const TextStyle(color: Color(0xFF8EF1D9)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: const Color(0xFF8EF1D9),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.6,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index == objectCount) {
                    return _buildLoadingIndicator(
                        lostObjectsProvider.isLoading);
                  }
                  double width = MediaQuery.of(context).size.width / 2 - 12;
                  double height = width / 0.6;
                  LostObject lostObject = lostObjects[index];
                  return ObjectCard(
                      lostObject: lostObject, width: width, height: height);
                  // return Container(
                  //   margin: EdgeInsets.all(4), // Espacement entre les cellules
                  //   color: index % 2 == 0 ? Colors.red : Colors.green,
                  //   child: Center(
                  //     child: Text(
                  //       items[index], // Affiche l'élément
                  //       style: TextStyle(color: Colors.white, fontSize: 20),
                  //     ),
                  //   ),
                  // );
                },
                childCount: lostObjects.length, // Nombre d'éléments affichés
              ),
            ),
            // Indicateur de chargement
            SliverToBoxAdapter(
              child: lostObjectsProvider.isLoading
                  ? Container(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : SizedBox.shrink(),
            ),
          ],
        ));
  }

  Widget _buildFilterSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      title: const Text('Trier'),
                      content: _buildDialogContent(context),
                    );
                  },
                );
              },
              style: TextButton.styleFrom(
                textStyle: TextStyle(fontSize: 16),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Trier",
                    style: TextStyle(color: Color(0xFF8EF1D9), fontSize: 18),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.sort, color: Color(0xFF8EF1D9)),
                ],
              ),
            ),
          ],
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCategoryButton("Sac à dos"),
              const SizedBox(width: 8),
              _buildCategoryButton("Appareil audio"),
              const SizedBox(width: 8),
              _buildCategoryButton("Valise"),
              const SizedBox(width: 8),
              _buildCategoryButton("Montre"),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildCustomFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Filtres personnalisés",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        SizedBox(height: 8.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterButton("Date"),
              const SizedBox(width: 8.0),
              _buildFilterButton("Nature de l'objet"),
              const SizedBox(width: 8.0),
              _buildFilterButton("Gare de départ"),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildCategoryButton(String label) {
    return ElevatedButton(
      onPressed: () {
        // Action pour filtrer par catégorie
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF9B9ECE),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _buildFilterButton(String label) {
    return ElevatedButton(
      onPressed: () {
        // Action pour le filtre
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: const BorderSide(color: Color(0xFF9B9ECE), width: 1),
        ),
      ),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: const Text('Plus récent'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Moins récent'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Ordre alphabétique: du type d’objet'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class LostObjectsList extends StatefulWidget {
  @override
  _LostObjectsListState createState() => _LostObjectsListState();
}

class _LostObjectsListState extends State<LostObjectsList> {
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

    if (lostObjectsProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF9B9ECE),
        ),
      );
    }

    final lostObjects = lostObjectsProvider.lostObjects;
    final objectCount = lostObjects.length;
    final newObjectsCount = formatLargeNumber(lostObjectsProvider.totalCount);
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(0),
      itemCount: objectCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (context, index) {
        if (index == objectCount) {
          return _buildLoadingIndicator(lostObjectsProvider.isLoading);
        }
        double width = MediaQuery.of(context).size.width / 2 - 12;
        double height = width / 0.6;
        LostObject lostObject = lostObjects[index];
        return ObjectCard(lostObject: lostObject, width: width, height: height);
      },
    );
    // return Column(
    //   children: [
    //     Row(
    //       children: [
    //         Text(
    //           "$newObjectsCount nouveaux objets",
    //           style: const TextStyle(color: Color(0xFF8EF1D9)),
    //         ),
    //         const SizedBox(width: 8),
    //         Expanded(
    //           child: Container(
    //             height: 2,
    //             color: const Color(0xFF8EF1D9),
    //           ),
    //         ),
    //       ],
    //     ),
    //     const SizedBox(height: 16),
    //     Expanded(
    //       child: GridView.builder(
    //         controller: _scrollController,
    //         padding: const EdgeInsets.all(0),
    //         itemCount: objectCount,
    //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //           crossAxisCount: 2,
    //           crossAxisSpacing: 8.0,
    //           mainAxisSpacing: 8.0,
    //           childAspectRatio: 0.6,
    //         ),
    //         itemBuilder: (context, index) {
    //           if (index == objectCount) {
    //             return _buildLoadingIndicator(lostObjectsProvider.isLoading);
    //           }
    //           double width = MediaQuery.of(context).size.width / 2 - 12;
    //           double height = width / 0.6;
    //           LostObject lostObject = lostObjects[index];
    //           return ObjectCard(
    //               lostObject: lostObject, width: width, height: height);
    //         },
    //       ),
    //     ),
    //   ],
    // );
  }

  // Widget pour afficher l'indicateur de chargement au bas de la liste
  Widget _buildLoadingIndicator(bool isLoadingMore) {
    if (isLoadingMore) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF9B9ECE),
          ),
        ),
      );
    } else {
      return SizedBox.shrink(); // Ne rien afficher s'il n'y a pas de chargement
    }
  }
}
