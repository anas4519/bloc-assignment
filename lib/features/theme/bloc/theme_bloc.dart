import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ThemeEvent {}

class ToggleTheme extends ThemeEvent {}

class InitializeTheme extends ThemeEvent {}

class ThemeState {
  final bool isDarkMode;

  ThemeState({required this.isDarkMode});
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences prefs;
  static const String _themeKey = 'isDarkMode';

  ThemeBloc({required this.prefs}) : super(ThemeState(isDarkMode: false)) {
    on<InitializeTheme>((event, emit) {
      final isDarkMode = prefs.getBool(_themeKey) ?? false;
      emit(ThemeState(isDarkMode: isDarkMode));
    });

    on<ToggleTheme>((event, emit) {
      final isDarkMode = !state.isDarkMode;
      prefs.setBool(_themeKey, isDarkMode);
      emit(ThemeState(isDarkMode: isDarkMode));
    });
  }
}
