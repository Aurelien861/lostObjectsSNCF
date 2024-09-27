import 'package:flutter/material.dart';
import 'package:myapp/models/lost_object_model.dart';
import 'package:myapp/providers/lost_objects_provider.dart';
import 'package:myapp/utils/util_functions.dart';
import 'package:myapp/views/object_card.dart';
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

    final lostObjects = lostObjectsProvider.lostObjects;
    final objectCount = lostObjects.length;
    final newObjectsCount = formatLargeNumber(lostObjectsProvider.totalCount);

    return Scaffold(
      backgroundColor: const Color(0xFF211E29),
      body: Padding(
          padding: const EdgeInsets.all(16),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
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
                    _buildFilterSection(context, lostObjectsProvider),
                    const SizedBox(height: 16),
                    _buildCustomFilterSection(lostObjectsProvider),
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
                  childAspectRatio: 0.5,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (lostObjects.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    double width = MediaQuery.of(context).size.width / 2 - 12;
                    double height = width / 0.6;
                    LostObject lostObject = lostObjects[index];
                    return ObjectCard(
                        lostObject: lostObject, width: width, height: height);
                  },
                  childCount: objectCount,
                ),
              ),
              SliverToBoxAdapter(
                child: lostObjectsProvider.isLoading
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: const Center(
                            child: CircularProgressIndicator(
                          color: Color(0xFF9B9ECE),
                        )),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          )),
    );
  }

  Widget _buildFilterSection(BuildContext context, LostObjectsProvider lostObjectsProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                      content: _buildDialogContent(context, lostObjectsProvider),
                    );
                  },
                );
              },
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 16),
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

  Widget _buildCustomFilterSection(LostObjectsProvider lostObjectsProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Filtres personnalisés",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        const SizedBox(height: 8.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterButton("Date", lostObjectsProvider),
              const SizedBox(width: 8.0),
              _buildFilterButton("Nature de l'objet", lostObjectsProvider),
              const SizedBox(width: 8.0),
              _buildFilterButton("Gare de départ", lostObjectsProvider),
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

  Widget _buildFilterButton(String label, LostObjectsProvider lostObjectsProvider) {
    return ElevatedButton(
      onPressed: () {
        _selectDate(context, lostObjectsProvider);
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
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildDialogContent(BuildContext context, LostObjectsProvider lostObjectsProvider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: const Text('Plus récent'),
          onTap: () {
            Navigator.pop(context);
            lostObjectsProvider.setSelectedSort('date', 'desc');
          },
        ),
        ListTile(
          title: const Text('Moins récent'),
          onTap: () {
            Navigator.pop(context);
            lostObjectsProvider.setSelectedSort('date', 'asc');
          },
        ),
        ListTile(
          title: const Text("Ordre alphabétique: de la nature de l'objet"),
          onTap: () {
            Navigator.pop(context);
            lostObjectsProvider.setSelectedSort('gc_obo_nature_c', 'asc');
          },
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, LostObjectsProvider lostObjectsProvider) async {
    DateTime? dateFilter = lostObjectsProvider.dateFilter;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateFilter,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: const Locale('fr'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6665DD), 
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6665DD), 
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != dateFilter) {
      lostObjectsProvider.setSelectedDate(picked);
    }
  }
}
