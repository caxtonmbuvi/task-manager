import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager/features/task/model/task_model.dart';

class FirebaseService {
  CollectionReference get tasksCollection {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not authenticated");
    }
    // Tasks are stored under each user's document.
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks');
  }

  /// Fetch tasks from the current user’s tasks collection.
  Future<List<TaskModel>> fetchTasks() async {
  final snapshot = await tasksCollection.get();
  final docs = snapshot.docs;

  // For each doc, get the subtasks in parallel
  final futures = docs.map((doc) async {
    final data = doc.data() as Map<String, dynamic>;
    // Parse the main task
    TaskModel task = TaskModel.fromJson(data);

    // Fetch subtasks
    final subtasksSnapshot = await doc.reference.collection('subtasks').get();
    final subtasks = subtasksSnapshot.docs
        .map((subDoc) => SubTask.fromJson(subDoc.data()))
        .toList();

    // Attach the subtasks
    return task.copyWith(subtasks: subtasks);
  }).toList();

  return Future.wait(futures);
}

  /// Upload (or update) a task in the current user’s tasks collection.
  Future<bool> uploadTask(TaskModel task) async {
    try {
      final taskMap = task.toJson();
      taskMap.remove('subtasks');
      await tasksCollection.doc(task.uniqueId).set(
            taskMap,
            SetOptions(merge: true),
          );

      await uploadSubtasks(task.uniqueId, task.subtasks);
      return true;
    } catch (e) {
      log('Error uploading task: $e');
      return false;
    }
  }

  Future<bool> uploadSubtasks(String taskId, List<SubTask> subtasks) async {
    try {
      final taskDoc = tasksCollection.doc(taskId);
      final batch = FirebaseFirestore.instance.batch();

      // 1. Clear existing subtasks
      final existingSubtasks = await taskDoc.collection('subtasks').get();
      for (var doc in existingSubtasks.docs) {
        batch.delete(doc.reference);
      }

      // 2. Add each new subtask
      for (final subtask in subtasks) {
        final subtaskDoc = taskDoc.collection('subtasks').doc(subtask.id);
        batch.set(subtaskDoc, subtask.toJson());
      }

      await batch.commit();
      return true;
    } catch (e) {
      log('Error uploading subtasks: $e');
      return false;
    }
  }

  // Reads all subtasks from the given task's subcollection in Firestore.
  Future<List<SubTask>> fetchSubTasks(String taskId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not authenticated");

    final snapshot =
        await tasksCollection.doc(taskId).collection('subtasks').get();

    return snapshot.docs.map((doc) => SubTask.fromJson(doc.data())).toList();
  }
}
