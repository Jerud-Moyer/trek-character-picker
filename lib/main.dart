import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'answers_1.dart';
import 'character.dart';
import 'question_widget.dart';
import 'answers_2.dart';
import 'answers_3.dart';
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

  String dropdownValue_1 = answers_1[0].value;
  String dropdownValue_2 = answers_2[0].value;
  String dropdownValue_3 = answers_3[0].value;

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
            Navigator.push(ctx, CharacterPage(dropdownValue_2));
          },
          child: Icon(Icons.arrow_right,
            color: Colors.amber,
            size: 50,
          ),
          backgroundColor: Colors.grey[800],
        ),
        body: Padding(
            padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    QuestionWidget(
                      question: 'Which best describes you?',
                      answers: answers_1,
                      selectedValue: dropdownValue_1,
                      onChange: (String? newValue) {
                        setState(() {
                          dropdownValue_1 = newValue!;
                          print(dropdownValue_1);
                       });
                      }
                    ),
                    QuestionWidget(
                      question: 'A drunken stranger hurls insults at you, how do you respond?',
                      answers: answers_2,
                      selectedValue: dropdownValue_2,
                      onChange: (String? newValue) {
                        setState(() {
                          dropdownValue_2 = newValue!;
                          print(dropdownValue_2);
                        });
                      }
                    ),
                    QuestionWidget(
                      question: 'Two sides of your family have a political disagreement. What do you do?',
                      answers: answers_3,
                      selectedValue: dropdownValue_3,
                      onChange: (String? newValue) {
                        setState(() {
                          dropdownValue_3 = newValue!;
                          print(dropdownValue_3);
                        });
                      }
                    ),
                    QuestionWidget(
                        question: 'Two sides of your family have a political disagreement. What do you do?',
                        answers: answers_3,
                        selectedValue: dropdownValue_3,
                        onChange: (String? newValue) {
                          setState(() {
                            dropdownValue_3 = newValue!;
                            print(dropdownValue_3);
                          });
                        }
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ]),
            )
        ),
    );
  }
  }

class CharacterPage extends MaterialPageRoute<Null> {
  CharacterPage(affiliation) : super(builder: (BuildContext ctx) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.grey[800],
            elevation: 10,

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

