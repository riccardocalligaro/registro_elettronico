import 'package:registro_elettronico/data/db/moor_database.dart';

abstract class PeriodsRepository {
  // Updates the periods for the user. Q1 and Q2..
  Future updatePeriods();
  // Get all Pewriods
  Future<List<Period>> getAllPeriods();
  // Stream for periods
  Stream<List<Period>> watchAllPeriods();
}
