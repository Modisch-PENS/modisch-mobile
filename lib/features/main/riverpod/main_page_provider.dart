import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_page_provider.g.dart';

enum MainPageTab {
  home,
  wardrobe,
  model
}

@riverpod
class MainPageNotifier extends _$MainPageNotifier {
  @override
  MainPageTab build() {
    return MainPageTab.home;
  }

  void changePageToTab(MainPageTab tab) {
    state = tab;
  }
  
  void changePageToIndex(int index) {
    state = MainPageTab.values[index];
  }
  
  int get currentIndex => state.index;
  
  bool get isWardrobePage => state == MainPageTab.wardrobe;
}