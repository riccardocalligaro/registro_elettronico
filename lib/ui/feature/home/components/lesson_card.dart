import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LessonCard extends StatelessWidget {
  final Color color;

  const LessonCard({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: Container(
        width: 220.0,
        height: 140,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(5.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ClipOval(
                    child: Container(
                      width: 40.0,
                      height: 40.0,
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(color: Colors.white),
                      child: SvgPicture.asset(
                        "assets/icons/book.svg",
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 7.0, vertical: 4.0),
                        decoration: BoxDecoration(
                            color: Colors.grey[200].withOpacity(0.4),
                            borderRadius: BorderRadius.circular(8)),
                        child: Opacity(
                          opacity: 0.85,
                          child: Text(
                            '2H',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      'INFORMATICA',
                      style: Theme.of(context)
                          .textTheme
                          .headline
                          .copyWith(fontSize: 12, color: Colors.white),
                    ),
                  ),
                  Text(
                    'lorem ipsum dolor sit a met this is only a tes...',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
