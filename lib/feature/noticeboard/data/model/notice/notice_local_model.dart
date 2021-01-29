import 'package:moor/moor.dart';

@DataClassName('NoticeLocalModel')
class Notices extends Table {
  IntColumn get pubId => integer()();
  DateTimeColumn get pubDate => dateTime()();
  BoolColumn get readStatus => boolean()();
  TextColumn get eventCode => text()();
  IntColumn get contentId => integer()();
  DateTimeColumn get contentValidFrom => dateTime()();
  DateTimeColumn get contentValidTo => dateTime()();
  BoolColumn get contentValidInRange => boolean()();
  TextColumn get contentStatus => text()();
  TextColumn get contentTitle => text()();
  TextColumn get contentCategory => text()();
  BoolColumn get contentHasChanged => boolean()();
  BoolColumn get contentHasAttach => boolean()();
  BoolColumn get needJoin => boolean()();
  BoolColumn get needReply => boolean()();
  BoolColumn get needFile => boolean()();

  @override
  Set<Column> get primaryKey => {pubId};
}
