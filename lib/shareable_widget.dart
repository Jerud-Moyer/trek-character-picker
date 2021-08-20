import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShareableWidget extends StatelessWidget {
  final character;

  ShareableWidget({
    @required this.character
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      color: Colors.grey[850],
      child: Padding(
        padding: EdgeInsets.fromLTRB(40, 0, 30, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'I\'m ${character?.name}',
              textAlign: TextAlign.center,
              style: TextStyle(
              letterSpacing: 2,
              fontSize: 25,
              fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              )
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 20),
            Text(
              'who are you?',
               textAlign: TextAlign.center,
                style: TextStyle(
                letterSpacing: 2,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
                )
            ),
        ],
        ),
      )
    );
  }
}

