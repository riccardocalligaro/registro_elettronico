import 'package:meta/meta.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';

@immutable
abstract class DocumentsState {}

class DocumentsInitial extends DocumentsState {}

class DocumentsLoadInProgress extends DocumentsState {}

class DocumentsLoadSuccess extends DocumentsState {
  final List<SchoolReport> schoolReports;
  final List<Document> documents;

  DocumentsLoadSuccess({
    @required this.schoolReports,
    @required this.documents,
  });
}

class DocumentsLoadError extends DocumentsState {}

// Api update

class DocumentsUpdateLoadInProgress extends DocumentsState {}

class DocumentsUpdateLoadSuccess extends DocumentsState {}

class DocumentsUpdateLoadError extends DocumentsState {}
