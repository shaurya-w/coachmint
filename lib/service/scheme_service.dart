import 'package:supabase_flutter/supabase_flutter.dart';

class SchemeService {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchWelfareSchemes() async {
    try {
      final response = await _supabase
          .from('welfare_schemes')
          .select()
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to load schemes: $e');
    }
  }
}