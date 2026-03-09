import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/date_idea.dart';

/// Loads date ideas from the JSON asset file at runtime.
Future<List<DateIdea>> loadDateIdeas() async {
  final String jsonString =
      await rootBundle.loadString('assets/data/date_ideas.json');
  final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
  return jsonList
      .map((e) => DateIdea.fromJson(e as Map<String, dynamic>))
      .toList();
}
