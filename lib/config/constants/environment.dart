import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String theMovieDbKey = 
      const String.fromEnvironment('THE_MOVIEDB_KEY', 
          defaultValue: '') != '' 
        ? const String.fromEnvironment('THE_MOVIEDB_KEY') 
        : dotenv.env['THE_MOVIEDB_KEY'] ?? 'No API Key';
}