import './character.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:convert';

Future<Character> fetchCharacter(affiliation) async {
  final response = await http
      .get(
      Uri.parse(
          'https://trek-dex.herokuapp.com/api/v1/characters/filter?affiliation=$affiliation'
      )
  );
  if (response.statusCode == 200) {
    final characterList = jsonDecode(response.body);
    Random random = new Random();
    int randomIndex = random.nextInt(characterList.length);
    return Character.fromJson(characterList[randomIndex]);

  } else {
    throw Exception('Failed to load character');
  }
}