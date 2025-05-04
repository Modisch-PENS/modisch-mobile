import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboard_provider.g.dart';

@riverpod
Future<bool> onboardStatus(OnboardStatusRef Ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('has_onboarded') ?? false;
}

@riverpod
Future<void> setOnboarded(SetOnboardedRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('has_onboarded', true);
  ref.invalidate(onboardStatusProvider); // update status
}
