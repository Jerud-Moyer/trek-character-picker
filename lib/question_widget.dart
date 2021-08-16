import 'package:flutter/material.dart';
import 'package:trek_character_picker/questionItem.dart';


class QuestionWidget extends StatelessWidget {

  final question;
  final answers;
  final onChange;
  final selectedValue;

  QuestionWidget({
    @required this.question,
    @required this.answers,
    @required this.onChange,
    this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 5.0, color: Colors.redAccent),
        )
      ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                child: Text(
                    question,
                    style: TextStyle(
                      color: Colors.lightBlueAccent[700],
                      fontSize: 24,
                    )
                ),
              ),
              DropdownButton<String>(
                  isExpanded: true,
                  value: selectedValue,
                  icon: Icon(Icons.arrow_downward, color: Colors.grey[800],
                      size: 24),
                  onChanged: onChange,
                  items: answers
                      .map<DropdownMenuItem<String>>((
                      QuestionItem affiliation) {
                    return DropdownMenuItem<String>(
                        value: affiliation.value,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Text(
                            affiliation.answer,
                          ),
                        )
                    );
                  }).toList(),
                  hint: Text(
                      'Which best describes you?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      )
                  ),
                ),
              SizedBox(
                height: 20
              )
            ])
    );
  }
}
