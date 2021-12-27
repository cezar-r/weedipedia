import 'package:flutter/material.dart';
import 'Helpers.dart';
import 'app_user.dart';

// AppUser user = AppUser();

/// A widget class that represents the review text
class ReviewText extends StatefulWidget {
  final String text;

  const ReviewText({required this.text});

  @override
  _ReviewTextState createState() => _ReviewTextState();
}

class _ReviewTextState extends State<ReviewText> {
  String firstHalf = '';
  String secondHalf = '';
  bool flag = true;

  @override
  void initState() {
    super.initState();

    if (widget.text.length > 150) {
      firstHalf = widget.text.substring(0, 150);
      secondHalf = widget.text.substring(150, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: secondHalf.isEmpty
          ? SelectableText(
        firstHalf,
        style: style(fontWeight: FontWeight.normal),
      )
          : Column(
        children: <Widget>[
          SelectableText(
            flag ? (firstHalf + "...") : (firstHalf + secondHalf),
            style: style(fontWeight: FontWeight.normal),
          ),
          InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  flag ? "show more" : "show less",
                  style: style(color: AppUser.getColor()),
                ),
              ],
            ),
            onTap: () {
              setState(() {
                flag = !flag;
              });
            },
          ),
        ],
      ),
    );
  }
}
