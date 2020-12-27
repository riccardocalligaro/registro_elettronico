part of 'documents_bloc.dart';

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

class DocumentsLoadNotConnected extends DocumentsState {}

// Api update

class DocumentsUpdateLoadInProgress extends DocumentsState {}

class DocumentsUpdateLoadSuccess extends DocumentsState {}

class DocumentsUpdateLoadError extends DocumentsState {}
