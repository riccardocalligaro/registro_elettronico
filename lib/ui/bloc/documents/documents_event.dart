import 'package:meta/meta.dart';

@immutable
abstract class DocumentsEvent {}

class GetDocuments extends DocumentsEvent {}

class UpdateDocuments extends DocumentsEvent {}
