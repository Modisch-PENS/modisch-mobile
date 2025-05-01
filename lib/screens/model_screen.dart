import 'package:flutter/material.dart';
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

                    bool isValid(String? img) =>
                        img != null && !img.contains('none');

                    return Container(
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
        backgroundColor: const Color(0xFF21ABDE),
        child: const Icon(Icons.add),
        onPressed: () async {
          // navigasi ke PreviewScreen
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PreviewScreen()),
          );
        },
      ),
    );
  }
}
