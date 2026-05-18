import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/date_idea.dart';

/// Logs date-selection sessions and round outcomes to Firestore.
class InteractionLogger {
  InteractionLogger({FirebaseFirestore? firestore}) : _firestore = firestore;

  final FirebaseFirestore? _firestore;
  DocumentReference<Map<String, dynamic>>? _sessionRef;

  FirebaseFirestore? get _resolvedFirestore {
    if (_firestore != null) return _firestore;
    if (Firebase.apps.isEmpty) return null;
    return FirebaseFirestore.instance;
  }

  String _sessionDocumentId() {
    final now = DateTime.now();
    String two(int value) => value.toString().padLeft(2, '0');
    String three(int value) => value.toString().padLeft(3, '0');

    return '${now.year}-'
        '${two(now.month)}-'
        '${two(now.day)}_'
        '${two(now.hour)}-'
        '${two(now.minute)}-'
        '${two(now.second)}-'
        '${three(now.millisecond)}';
  }

  Future<void> startSession(List<DateIdea> ideas) async {
    try {
      final firestore = _resolvedFirestore;
      if (firestore == null) return;

      final ref = firestore
          .collection('interaction_sessions')
          .doc(_sessionDocumentId());
      _sessionRef = ref;

      await ref.set({
        'startedAt': FieldValue.serverTimestamp(),
        'startedAtClient': DateTime.now().toUtc().toIso8601String(),
        'ideaCount': ideas.length,
        'ideaOrder': ideas
            .map(
              (idea) => {
                'id': idea.id,
                'name': idea.name,
              },
            )
            .toList(),
        'status': 'in_progress',
      });
    } catch (error, stackTrace) {
      developer.log(
        'Failed to start interaction session',
        error: error,
        stackTrace: stackTrace,
        name: 'InteractionLogger',
      );
    }
  }

  Future<void> logRoundSelection({
    required int roundNumber,
    required DateIdea leftIdea,
    required DateIdea rightIdea,
    required DateIdea roundWinner,
  }) async {
    final sessionRef = _sessionRef;
    if (sessionRef == null) return;

    try {
      await sessionRef.collection('rounds').doc('round_$roundNumber').set({
        'roundNumber': roundNumber,
        'occurredAt': FieldValue.serverTimestamp(),
        'occurredAtClient': DateTime.now().toUtc().toIso8601String(),
        'leftIdea': {
          'id': leftIdea.id,
          'name': leftIdea.name,
        },
        'rightIdea': {
          'id': rightIdea.id,
          'name': rightIdea.name,
        },
        'winnerIdea': {
          'id': roundWinner.id,
          'name': roundWinner.name,
        },
      });
    } catch (error, stackTrace) {
      developer.log(
        'Failed to log round selection',
        error: error,
        stackTrace: stackTrace,
        name: 'InteractionLogger',
      );
    }
  }

  Future<void> completeSession(DateIdea winner) async {
    final sessionRef = _sessionRef;
    if (sessionRef == null) return;

    try {
      await sessionRef.update({
        'completedAt': FieldValue.serverTimestamp(),
        'completedAtClient': DateTime.now().toUtc().toIso8601String(),
        'status': 'completed',
        'winnerIdea': {
          'id': winner.id,
          'name': winner.name,
        },
      });
    } catch (error, stackTrace) {
      developer.log(
        'Failed to complete interaction session',
        error: error,
        stackTrace: stackTrace,
        name: 'InteractionLogger',
      );
    }
  }
}
