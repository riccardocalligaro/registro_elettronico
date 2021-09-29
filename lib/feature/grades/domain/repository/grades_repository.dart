import 'package:dartz/dartz.dart';
import 'package:registro_elettronico/core/infrastructure/error/failures.dart';
import 'package:registro_elettronico/core/infrastructure/error/successes.dart';
import 'package:registro_elettronico/core/infrastructure/generic/resource.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grade_domain_model.dart';
import 'package:registro_elettronico/feature/grades/domain/model/grades_section.dart';
import 'package:registro_elettronico/feature/grades/domain/model/subject_data_domain_model.dart';
import 'package:registro_elettronico/feature/subjects/domain/model/subject_domain_model.dart';

abstract class GradesRepository {
  Stream<Resource<List<GradeDomainModel>>> watchLocalGrades({
    required int? subjectId,
    required int? periodPos,
  });

  Stream<Resource<List<GradeDomainModel>>> watchAllGrades();

  Stream<Resource<GradesPagesDomainModel?>> watchAllGradesSections();

  Future<Either<Failure, Success>> updateGrades({required bool ifNeeded});

  Future<Either<Failure, SubjectDataDomainModel>> getSubjectData({
    required PeriodGradeDomainModel periodGradeDomainModel,
  });

  Future<Either<Failure, List<GradeDomainModel>>> getGrades();

  Future<Either<Failure, Success>> toggleGradeLocallyCancelledStatus({
    required GradeDomainModel gradeDomainModel,
  });

  Future<Either<Failure, Success>> changeSubjectObjective({
    required int newValue,
    required SubjectDomainModel subject,
  });

  Future<Either<Failure, Success>> deleteLocalGrade({
    required GradeDomainModel gradeDomainModel,
  });

  Future<Either<Failure, Success>> addLocalGrade({
    required GradeDomainModel gradeDomainModel,
  });
}
