import 'package:moor/moor.dart';

import '../models/model.dart';
import '../database/moor_database.dart';

part 'dao.g.dart';

@UseDao(tables: [Tasks])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  final AppDatabase db;

  TaskDao(this.db) : super(db);

  Future<List<Task>> getAllTasks() => select(tasks).get();
  Stream<List<Task>> watchAllTasks() => select(tasks).watch();

  Stream<List<Task>> watchCompletedTasks() {
    return (select(tasks)
      ..orderBy([
        (t) => OrderingTerm(expression: t.title, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.dueDate, mode: OrderingMode.desc),
      ])
      ..where((t) => t.completed)).watch();
  }

  Future<int> insertTask(Insertable<Task> task) => into(tasks).insert(task);
  Future<bool> updateTask(Insertable<Task> task) => update(tasks).replace(task);
  Future<int> deleteTask(Insertable<Task> task) => delete(tasks).delete(task);
}