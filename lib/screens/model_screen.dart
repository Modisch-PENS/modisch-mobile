import 'package:flutter/material.dart';
import 'package:modisch/constants/colors.dart';
import 'package:provider/provider.dart';
import '/model/selected_model.dart';
import '/screens/preview_screen.dart';

class ModelScreen extends StatelessWidget {
  const ModelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final outfits = Provider.of<SelectedModel>(context).savedOutfits;

    return Scaffold(
      appBar: AppBar(title: const Text("Models"), centerTitle: true),
      body:
          outfits.isEmpty
              ? const Center(child: Text("No outfit saved yet."))
              : Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: outfits.length,
                  itemBuilder: (context, index) {
                    final o = outfits[index];
                    bool isLongPressed = false;

                    bool isValid(String? img) =>
                        img != null && !img.contains('none');

                    return StatefulBuilder(
                      builder: (context, setState) {
                        return GestureDetector(
                          onLongPress: () {
                            setState(() => isLongPressed = true);
                          },
                          onTap: () {
                            if (isLongPressed) {
                              setState(() => isLongPressed = false);
                              return;
                            }
                            // Kode edit model yang sudah ada
                            final model = Provider.of<SelectedModel>(
                              context,
                              listen: false,
                            );
                            model.selectShirt(o.shirt);
                            model.selectPants(o.pants);
                            model.selectDress(o.dress);
                            model.selectShoes(o.shoes);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PreviewScreen(),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  minHeight: 180,
                                  minWidth: MediaQuery.of(context).size.width * 0.4,
                                ),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black26),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      o.name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    if (isValid(o.shirt))
                                      Image.asset(
                                        'assets/images/${o.shirt!}',
                                        height: 60,
                                      ),
                                    if (isValid(o.pants))
                                      Image.asset(
                                        'assets/images/${o.pants!}',
                                        height: 60,
                                      ),
                                    if (isValid(o.dress))
                                      Image.asset(
                                        'assets/images/${o.dress!}',
                                        height: 60,
                                      ),
                                    if (isValid(o.shoes))
                                      Image.asset(
                                        'assets/images/${o.shoes!}',
                                        height: 60,
                                      ),
                                  ],
                                ),
                              ),
                              if (isLongPressed)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      final deletedOutfit = outfits[index];
                                      final model = Provider.of<SelectedModel>(
                                        context,
                                        listen: false,
                                      );

                                      showDialog(
                                        context: context,
                                        builder:
                                            (ctx) => AlertDialog(
                                              title: const Text(
                                                'Delete Model?',
                                              ),
                                              content: const Text(
                                                'Are you sure you want to delete this model?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(ctx),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    model.deleteOutfit(index);
                                                    Navigator.pop(ctx);
                                                    setState(
                                                      () =>
                                                          isLongPressed = false,
                                                    );

                                                    // Show undo snackbar
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      SnackBar(
                                                        content: const Text(
                                                          'Model deleted',
                                                        ),
                                                        duration:
                                                            const Duration(
                                                              seconds: 5,
                                                            ),
                                                        backgroundColor:
                                                            AppColors.secondary,
                                                        action: SnackBarAction(
                                                          label: 'UNDO',
                                                          textColor:
                                                              Colors.white,
                                                          onPressed: () {
                                                            // Undo delete
                                                            model.savedOutfits
                                                                .insert(
                                                                  index,
                                                                  deletedOutfit,
                                                                );
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: const Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                      color: Color(0xFFBF2626),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color:Color(0xFFBF2626),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.2,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.checkroom), label: "Model"),
          BottomNavigationBarItem(
            icon: Icon(Icons.design_services),
            label: "Make",
          ),
        ],
        currentIndex: 0,
        onTap: (index) {},
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.tertiary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 30),
        onPressed: () async {
          Provider.of<SelectedModel>(context, listen: false).reset();
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PreviewScreen(reset: true),
            ),
          );
        },
      ),
    );
  }
}
