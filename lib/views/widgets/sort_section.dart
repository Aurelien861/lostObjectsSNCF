import 'package:flutter/material.dart';
import 'package:myapp/providers/lost_objects_provider.dart';
import 'package:myapp/utils/theme.dart';

class SortSection extends StatelessWidget {
  final LostObjectsProvider lostObjectsProvider;

  const SortSection({
    Key? key,
    required this.lostObjectsProvider,
  }) : super(key: key);

  // Fonction pour afficher la boîte de dialogue de tri
  void _showSortDialog(BuildContext context) {
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
  }

  // Contenu de la boîte de dialogue (vous pouvez remplacer cette méthode)
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => _showSortDialog(context),
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Trier",
                    style: TextStyle(color: AppTheme.teaGreenColor, fontSize: 18),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.sort, color: AppTheme.teaGreenColor),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
