import 'package:flutter/material.dart';

class RadioQuestion extends StatefulWidget {
  final String question;
  final List<String> labels;
  final int amount;
  final Function(int) onChanged;

  const RadioQuestion({
    Key? key,
    required this.question,
    required this.labels,
    required this.amount,
    required this.onChanged,
  }) : super(key: key);

  @override
  RadioQuestionState createState() => RadioQuestionState();
}

class RadioQuestionState extends State<RadioQuestion> {
  int _choice = -1;

  @override
  Widget build(BuildContext context) {
    final radioTiles = <Widget>[
      Text(
        widget.question,
        style: const TextStyle(fontSize: 18),
      ),
    ];

    for (var i = 0; i < widget.amount; ++i) {
      radioTiles.add(
        Row(
          children: [
            Radio<int>(
              value: i,
              groupValue: _choice,
              onChanged: (int? value) {
                setState(() {
                  _choice = value!;
                  widget.onChanged(value);
                });
              },
            ),
            Text(widget.labels[i])
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: radioTiles,
    );
  }
}
