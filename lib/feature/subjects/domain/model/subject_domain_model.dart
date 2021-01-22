import 'package:flutter/material.dart';
import 'package:registro_elettronico/core/data/local/moor_database.dart';
import 'package:registro_elettronico/core/infrastructure/presentation_constants.dart';
import 'package:registro_elettronico/feature/professors/domain/model/professor_domain_model.dart';
import 'package:registro_elettronico/utils/global_utils.dart';
import 'package:registro_elettronico/utils/string_utils.dart';

class SubjectDomainModel {
  int id;
  String name;
  int order;
  List<ProfessorDomainModel> professors;

  SubjectDomainModel({
    @required this.id,
    @required this.name,
    @required this.order,
    @required this.professors,
  });

  SubjectDomainModel.fromLocalModel({
    @required List<ProfessorDomainModel> professors,
    @required SubjectLocalModel l,
  }) {
    this.id = l.id;
    this.name = l.name;
    this.order = l.orderNumber;
    this.professors = professors;
  }

  String get professorsText {
    String professorsText = '';

    if (PresentationConstants.isForPresentation) {
      professorsText +=
          '${StringUtils.titleCase(GlobalUtils.getMockupName())}, ';
    } else {
      if (this.professors == null) {
        return '';
      }
      this.professors.forEach((prof) {
        String name = StringUtils.titleCase(prof.name);
        if (!professorsText.contains(name)) {
          professorsText += "${StringUtils.titleCase(prof.name)}, ";
        }
      });
    }
    professorsText = StringUtils.removeLastChar(professorsText);

    return professorsText;
  }
}
