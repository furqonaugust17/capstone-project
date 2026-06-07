import 'package:drift/drift.dart';

class Scores extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get label => text()();
  RealColumn get confidence => real()();
  IntColumn get timestamp => integer()();
}
