import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF211E29),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32),
            Center(
              child: Image.asset(
                'assets/images/background_sncf.png',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            SizedBox(height: 32),
            const Text(
              "Un objet perdu ? 🙃",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.white),
            ),
            SizedBox(height: 16),
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
                const Text(
                  "37 nouveaux objets",
                  style: TextStyle(color: Color(0xFF8EF1D9)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 2, // Épaisseur de la ligne
                    color: const Color(0xFF8EF1D9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildObjetsPerdusList(),
          ],
        ),
      )),
    );
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

  Widget _buildObjetsPerdusList() {
    return GridView.builder(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (context, index) {
        double width = MediaQuery.of(context).size.width / 2 - 12;
        double height = width / 0.6;
        return _buildOLostObjectCard(context, width, height);
      },
    );
  }

  Widget _buildOLostObjectCard(
      BuildContext context, double width, double height) {
    double imageSpace = 0.8 * width;
    double imagePadding = 0.7 * ((height - imageSpace) / 2);
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color(0xFF9B9ECE),
              child: Column(children: [
                SizedBox(height: imagePadding),
                Center(
                  child: Image.asset(
                    'assets/images/objects/no_image.png',
                    fit: BoxFit.cover,
                    width: imageSpace,
                  ),
                ),
                SizedBox(height: imagePadding),
              ]),
            ),
            const Wrap(
              alignment: WrapAlignment.start,
              children: [
                Text(
                  "Le Havre",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w300),
                )
              ],
            ),
            const Wrap(
              alignment: WrapAlignment.start,
              children: [
                Text(
                  "Bagagerie: sacs, valises, cartables",
                  style: TextStyle(color: Colors.white),
                )
              ],
            )
          ],
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(0),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Text("24 sept 2024",
                      style: TextStyle(fontSize: 10, color: Color(0xFF6665DD))),
                )
              ],
            )
          ],
        )
      ],
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Column(
      mainAxisSize:
          MainAxisSize.min,
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
