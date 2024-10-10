import 'package:flutter/material.dart';
import 'package:myapp/models/lost_object_model.dart';
import 'package:myapp/providers/lost_objects_provider.dart';
import 'package:myapp/utils/util_functions.dart';
import 'package:myapp/views/filter_page.dart';
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

  Widget _lostObjectsGrid(
      BuildContext context, List<LostObject> newLostObjects) {
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
                lostObject: lostObject, width: width, height: height);
          },
          childCount: newLostObjects.length,
        ),
      ),
    );
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
        backgroundColor: const Color(0xFF211E29),
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
                        _buildFilterSection(context, lostObjectsProvider),
                        _buildCustomFilterSection(lostObjectsProvider),
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
                ),
              ),
              _lostObjectsGrid(context, filteredLostObjects),
            ],
            if (newLostObjects.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
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
                ),
              ),
              _lostObjectsGrid(context, newLostObjects),
            ],
            if (formerLostObjects.isNotEmpty) ...[
              SliverToBoxAdapter(
                  child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(
                      "$formerObjectsCount objets déjà consultés",
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
              )),
              _lostObjectsGrid(context, formerLostObjects),
            ],
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
        ));
  }

  Widget _buildFilterSection(
      BuildContext context, LostObjectsProvider lostObjectsProvider) {
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
                      content:
                          _buildDialogContent(context, lostObjectsProvider),
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
      ],
    );
  }

  Widget _buildCustomFilterSection(LostObjectsProvider lostObjectsProvider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildDateFilterButton(lostObjectsProvider),
          const SizedBox(width: 8.0),
          _buildStationFilterButton(lostObjectsProvider),
          const SizedBox(width: 8.0),
          _buildTypeFilterButton(lostObjectsProvider),
          const SizedBox(width: 8.0),
          _buildNatureFilterButton(lostObjectsProvider),
        ],
      ),
    );
  }

  Widget _buildDateFilterButton(LostObjectsProvider lostObjectsProvider) {
    String selectedDate =
        formatDate(lostObjectsProvider.dateFilter.toString(), "d MMM yyyy");
    String butonLabel = selectedDate != 'Date invalide' ? selectedDate : 'Date';
    return ElevatedButton.icon(
        onPressed: () {
          _showCustomDatePicker(context, lostObjectsProvider);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: const BorderSide(color: Color(0xFF9B9ECE), width: 1),
          ),
        ),
        icon: const Icon(Icons.calendar_today, color: Colors.white),
        label: Text(butonLabel, style: const TextStyle(color: Colors.white)));
  }

  Widget _buildNatureFilterButton(LostObjectsProvider lostObjectsProvider) {
    int numberOfNatures = lostObjectsProvider.natureFilter.length;
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilterPage(
                filterType: 'Nature de l\'objet',
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: const BorderSide(color: Color(0xFF9B9ECE), width: 1),
          ),
        ),
        child: Row(
          children: [
            const Text('Nature de l\'objet',
                style: TextStyle(color: Colors.white)),
            if (numberOfNatures > 0) ...[
              const SizedBox(
                width: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                decoration: BoxDecoration(
                  color: const Color(0xFF9B9ECE),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Text(
                  numberOfNatures.toString(),
                  textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                    applyHeightToLastDescent: false,
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ]
          ],
        ));
  }

  Widget _buildTypeFilterButton(LostObjectsProvider lostObjectsProvider) {
    int numberOfTypes = lostObjectsProvider.typeFilter.length;
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilterPage(
                filterType: 'Type d\'objet',
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: const BorderSide(color: Color(0xFF9B9ECE), width: 1),
          ),
        ),
        child: Row(
          children: [
            const Text('Type d\'objet', style: TextStyle(color: Colors.white)),
            if (numberOfTypes > 0) ...[
              const SizedBox(
                width: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                decoration: BoxDecoration(
                  color: const Color(0xFF9B9ECE),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Text(
                  numberOfTypes.toString(),
                  textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                    applyHeightToLastDescent: false,
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ]
          ],
        ));
  }

  Widget _buildStationFilterButton(LostObjectsProvider lostObjectsProvider) {
    int numberOfStations = lostObjectsProvider.stationFilter.length;
    return ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilterPage(
                filterType: 'Gare de départ',
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: const BorderSide(color: Color(0xFF9B9ECE), width: 1),
          ),
        ),
        icon: const Icon(Icons.location_city, color: Colors.white),
        label: Row(
          children: [
            const Text('Gare de départ', style: TextStyle(color: Colors.white)),
            if (numberOfStations > 0) ...[
              const SizedBox(
                width: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                decoration: BoxDecoration(
                  color: const Color(0xFF9B9ECE),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Text(
                  numberOfStations.toString(),
                  textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                    applyHeightToLastDescent: false,
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ]
          ],
        ));
  }

  Widget _buildDialogContent(
      BuildContext context, LostObjectsProvider lostObjectsProvider) {
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
        // ListTile(
        //   title: const Text("Ordre alphabétique: de la nature de l'objet"),
        //   onTap: () {
        //     Navigator.pop(context);
        //     lostObjectsProvider.setSelectedSort('gc_obo_nature_c', 'asc');
        //   },
        // ),
      ],
    );
  }

  void _showCustomDatePicker(
      BuildContext context, LostObjectsProvider lostObjectsProvider) {
    DateTime? dateFilter = lostObjectsProvider.dateFilter;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsPadding: EdgeInsets.zero,
          titlePadding: const EdgeInsets.all(8),
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          title: const Text(
            'Quand avez-vous perdu votre bien ?',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          content: SizedBox(
            width: 1000,
            child: CalendarDatePicker(
              initialDate: dateFilter,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              onDateChanged: (picked) {
                dateFilter = picked;
              },
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    lostObjectsProvider.resetDate();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Réinitialiser',
                    style: TextStyle(color: Color(0xFF9B9ECE)),
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Annuler',
                          style: TextStyle(color: Color(0xFF6665DD))),
                    ),
                    TextButton(
                      onPressed: () {
                        if (dateFilter != null) {
                          lostObjectsProvider.setSelectedDate(dateFilter!);
                        }
                        Navigator.pop(context);
                      },
                      child: const Text('OK',
                          style: TextStyle(color: Color(0xFF6665DD))),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
