import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String theMovieDbKey = 
      const String.fromEnvironment('THE_MOVIEDB_KEY', 
          defaultValue: '') != '' 
        ? const String.fromEnvironment('THE_MOVIEDB_KEY') 
        : dotenv.env['THE_MOVIEDB_KEY'] ?? 'No API Key';
        
  static void debugApiKey() {
    print('=== DEBUG API KEY ===');
    print('API Key from Environment: ${const String.fromEnvironment('THE_MOVIEDB_KEY')}');
    print('API Key from dotenv: ${dotenv.env['THE_MOVIEDB_KEY']}');
    print('Final API Key: $theMovieDbKey');
    print('dotenv loaded keys: ${dotenv.env.keys}');
    print('===================');
  }
}