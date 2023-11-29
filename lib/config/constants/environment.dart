import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment{

  static String theMovieDBKey = dotenv.env['THE_MOVIEDB_KEY'] ?? 'No hay api key';

  static String noActorImage = 'https://st4.depositphotos.com/9998432/24428/v/450/depositphotos_244284796-stock-illustration-person-gray-photo-placeholder-man.jpg';

  static String noPosterMovieImage = 'https://sd.keepcalms.com/i/keep-calm-poster-not-found.png';

}