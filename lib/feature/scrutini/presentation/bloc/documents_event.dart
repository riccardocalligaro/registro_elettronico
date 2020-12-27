part of 'documents_bloc.dart';

@immutable
abstract class DocumentsEvent {}

class GetDocuments extends DocumentsEvent {}

class UpdateDocuments extends DocumentsEvent {}
