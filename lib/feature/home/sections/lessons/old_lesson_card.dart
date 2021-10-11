import 'package:flutter/material.dart';
import 'package:registro_elettronico/feature/lessons/domain/model/last_lessons_domain_model.dart';
import 'package:registro_elettronico/utils/color_utils.dart';

class LessonCard extends StatelessWidget {
  final LessonWithDurationDomainModel? lesson;

  const LessonCard({
    Key? key,
    this.lesson,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (lesson == null || lesson?.lesson == null) {
      return Container();
    }

    return Container(
      width: 190,
      child: Card(
        margin: EdgeInsets.zero,
        child: Row(
          children: [
            Container(
              height: double.infinity,
              width: 35,
              decoration: BoxDecoration(
                color: ColorUtils.getLessonCardColor(context),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  bottomLeft: Radius.circular(4.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${lesson!.duration}'),
                  Text('Ora'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 125,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      lesson!.lesson!.subjectDescription.toString(),
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Flexible(
                      child: Text(
                        lesson!.lesson!.lessonArgoment!,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
