import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/infrastructure/localizations/app_localizations.dart';
import 'package:registro_elettronico/core/infrastructure/presentation_constants.dart';
import 'package:registro_elettronico/core/presentation/widgets/cusotm_placeholder.dart';
import 'package:registro_elettronico/feature/lessons/domain/model/lesson_domain_model.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';

class LessonsList extends StatelessWidget {
  final List<LessonDomainModel> lessons;

  const LessonsList({
    Key key,
    @required this.lessons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (lessons == null || lessons.isEmpty) {
      return _EmptyList();
    }

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: 24.0),
      shrinkWrap: true,
      itemCount: lessons.length,
      itemBuilder: (ctx, index) {
        final lesson = lessons[index];
        return Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 0.0),
          child: Card(
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                child: Text(
                  PresentationConstants.isForPresentation
                      ? GlobalUtils.getMockupName()
                      : StringUtils.titleCase(lesson.author),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                child: Text(
                  lesson.lessonArgoment != ""
                      ? lesson.lessonArgoment
                      : lesson.lessonType,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EmptyList extends StatelessWidget {
  const _EmptyList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 38.0),
      child: CustomPlaceHolder(
        icon: Icons.subject,
        text: AppLocalizations.of(context).translate('empty_lessons'),
        showUpdate: false,
      ),
    );
  }
}
