import 'package:riverpod/legacy.dart';

final widgetNotifierProvider = StateProvider<int>((ref) => 0);

final refreshTriggerProvider = StateProvider<int>((ref) => 0); // костыль для обхода setState(() {})

final autoRunProvider = StateProvider<bool>((ref) => false);