import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trek_character_picker/shareable_widget.dart';
import 'answers/answers_1.dart';
import 'character.dart';
import 'question_widget.dart';
import 'answers/answers_2.dart';
import 'answers/answers_3.dart';
import 'answers/answers_4.dart';
import 'answers/answers_5.dart';
import 'affiliationCount.dart';
import './api.dart';

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
  String dropdownValue_4 = answers_4[0].value;
  String dropdownValue_5 = answers_5[0].value;

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
            Navigator.push(ctx, CharacterPage(
                [dropdownValue_1, dropdownValue_2, dropdownValue_3, dropdownValue_4, dropdownValue_5]
            ));
          },
          child: Icon(Icons.arrow_right,
            color: Colors.amber,
            size: 50,
          ),
          backgroundColor: Colors.grey[800],
        ),
        body: Padding(
            padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
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
                        });
                      }
                    ),
                    QuestionWidget(
                      question: 'How do you prefer to travel?',
                      answers: answers_5,
                      selectedValue: dropdownValue_5,
                      onChange: (String? newValue) {
                        setState(() {
                          dropdownValue_5 = newValue!;
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
                        });
                      }
                    ),
                    QuestionWidget(
                        question: 'Media reports are speaking of a frightening new virus. What\'s your reaction?',
                        answers: answers_4,
                        selectedValue: dropdownValue_4,
                        onChange: (String? newValue) {
                          setState(() {
                            dropdownValue_4 = newValue!;
                          });
                        }
                    ),
                    SizedBox(
                      height: 75,
                    )
                  ]),
            )
        ),
    );
  }
  }

class CharacterPage extends MaterialPageRoute<Null> {
  CharacterPage(affiliations) : super(builder: (BuildContext ctx) {
    final _screenshotController = ScreenshotController();

    final affiliationCounts = affiliationCount(affiliations);
    affiliationCounts.shuffle();
    affiliationCounts.sort((a, b) => b['amt'] - a['amt']);
    final affiliation = affiliationCounts[0]['name'];

    return Scaffold(
        backgroundColor: Colors.grey[850],
        appBar: AppBar(
            backgroundColor: Colors.grey[800],
            elevation: 10,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: FutureBuilder<Character>(
              future: fetchCharacter(affiliation),
              builder: (ctx, snapshot){
                if(snapshot.hasData){
                  final character = snapshot.data;
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(
                          '${character?.name}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              letterSpacing: 2,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            )
                      ),
                    ),
                    SizedBox(height: 30),
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
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Text(
                          (character?.affiliation.toLowerCase() == 'rogue')
                              ? 'You are a ${character?.race} '
                              'from ${character?.origin}'
                              ' and loyal to no one'
                              : 'You are a ${character?.race} '
                              'from ${character?.origin}'
                              ' and loyal to ${character?.affiliation}',

                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.lightBlueAccent[700],
                        )
                      ),
                    ),
                        SizedBox(height: 10),
                        ElevatedButton(
                            onPressed: () {
                              var container = ShareableWidget(character: character);
                              _screenshotController
                                .captureFromWidget(
                                  InheritedTheme.captureAll(
                                      ctx, Material(child: container)),
                                      delay: Duration(seconds: 1))
                                .then((capturedImage) {
                                  showCapturedWidget(ctx, capturedImage);
                              });
                            },
                            child: Icon(
                                Icons.share,
                                color: Colors.amberAccent,
                            )
                        ),
                  ]);
                } else if(snapshot.hasError) {
                  return Text("${snapshot.error.toString()}");
                }

                return Column(
                    children: <Widget>[
                      SizedBox(height: 250),
                      CircularProgressIndicator()
                    ]
                );
              }
            )

          ),
        )
    );
  }
  );
}

Future<dynamic> showCapturedWidget(
  BuildContext context, Uint8List capturedImage) async {

    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/flutter.png');
    image.writeAsBytesSync(capturedImage);

  return showDialog(
    useSafeArea: false,
    context: context,
    builder: (context) => Scaffold(
        backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.grey[600],
        elevation: 20,
        title: Text(
            'Which Trek character am I?',
            style: TextStyle(
                color: Colors.amber
            ),
        ),
        leading: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            }
      ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[600],
        onPressed: () {
          Share.shareFiles([image.path], text: "Shared form Trek Character Picker!");
          },
        child: Text(
            'Share!',
            style: TextStyle(
              color: Colors.amberAccent,
            )
        ),
      ),
      body: Center(
          child: Image.memory(capturedImage)
      ),

    )

  );


}

