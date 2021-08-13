import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'questionItem.dart';
import 'affiliations.dart';
import 'character.dart';
import 'dart:math';


void main() {
  runApp(MaterialApp(
    home: TrekCharacterPicker(),
  ));
}


class TrekCharacterPicker extends StatefulWidget {
  const TrekCharacterPicker({Key? key}) : super(key: key);

  @override
  _TrekCharacterPickerState createState() => _TrekCharacterPickerState();
}

class _TrekCharacterPickerState extends State<TrekCharacterPicker> {

  String dropdownValue = affiliations[0].value;

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Text(
              'Which Trek Character Are You?',
              style: TextStyle(
                  color: Colors.amber)
          ),
          centerTitle: true,
          backgroundColor: Colors.grey[800],
          elevation: 20,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(ctx, CharacterPage(dropdownValue));
          },
          child: Icon(Icons.arrow_right,
            color: Colors.amber,
            size: 50,
          ),
          backgroundColor: Colors.grey[800],
        ),
        body: Padding(
            padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      'Which best describes you?',
                      style: TextStyle(
                        color: Colors.lightBlueAccent[700],
                        fontSize: 24,
                      )
                  ),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_downward, color: Colors.grey[800],
                        size: 24),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                        print(dropdownValue);
                      });
                    },
                    items: affiliations
                        .map<DropdownMenuItem<String>>((
                        QuestionItem affiliation) {
                      return DropdownMenuItem<String>(
                          value: affiliation.value,
                          child: Text(
                            affiliation.answer,

                          ));
                    }).toList(),
                    hint: Text(
                        'Which best describes you?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        )
                    ),
                  ),
                ])),
    );
  }
  }

class CharacterPage extends MaterialPageRoute<Null> {
  CharacterPage(affiliation) : super(builder: (BuildContext ctx) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.grey[800],
            elevation: 10,
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                icon: Icon(Icons.close),
              )
            ]
        ),
        body: Center(
          child: FutureBuilder<Character>(
            future: fetchCharacter(affiliation),
            builder: (ctx, snapshot){
              if(snapshot.hasData){
                final character = snapshot.data;
                return Column(children: <Widget>[
                  Text('${character?.name}'),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                      child: Image(
                      image: NetworkImage('${character?.imageUrl}'),
                      loadingBuilder: (ctx, child, progress) {
                        return progress == null
                          ? child
                          : LinearProgressIndicator();
                    },
                        fit: BoxFit.cover,
                    width: 300,
                    height: 300,
                    semanticLabel: '${character?.name}',
                  )
                  ),
                  Text(
                    'You are a ${character?.race} '
                        'from ${character?.origin} '
                        'and loyal to ${character?.affiliation}'
                  )
                ]);
              } else if(snapshot.hasError) {
                return Text("${snapshot.error.toString()}");
              }

              return CircularProgressIndicator();
            }
          )

        )
    );
  });
}


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

