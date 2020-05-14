import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../data/dao.dart';
import '../data/moor_database.dart';
import 'widget/new_task_input_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool completed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tasks'),
          actions: [
            _buildCompletedSwitch(context),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: _buildTaskList(context)),
            NewTaskInput(),
          ],
        ));
  }

  StreamBuilder<List<Task>> _buildTaskList(BuildContext context) {
    final taskDao = Provider.of<TaskDao>(context);
    return StreamBuilder(
      stream: completed ? taskDao.watchCompletedTasks() : taskDao.watchAllTasks(),
      builder: (context, AsyncSnapshot<List<Task>> snapshot) {
        final tasks = snapshot.data ?? List();

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (_, index) {
            final itemTask = tasks[index];
            return _buildListItem(itemTask, taskDao);
          },
        );
      },
    );
  }

  Widget _buildListItem(Task itemTask, TaskDao taskDao) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => taskDao.deleteTask(itemTask),
        )
      ],
      child: CheckboxListTile(
        title: Text(itemTask.title),
        subtitle: Text(itemTask.dueDate?.toString() ?? 'No date'),
        value: itemTask.completed,
        onChanged: (newValue) {
          taskDao.updateTask(itemTask.copyWith(completed: newValue));
        },
      ),
    );
  }

  Widget _buildCompletedSwitch(BuildContext context) {
    return Row(children: [
      Text('Completed'),
      Switch(value: completed, onChanged: (bool value) => setState(() => completed = value),),
    ]);
  }
}