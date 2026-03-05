// import 'package:supabase_flutter/supabase_flutter.dart';
// import '../models/bill_model.dart';

// class BillService {
//   final _supabase = Supabase.instance.client;

//   Future<List<BillModel>> fetchBills(String userId) async {
//     // Fetches bills from the 'bills' table for a specific user
//     final response = await _supabase
//         .from('bills')
//         .select()
//         .eq('user_id', userId); 
    
//     return (response as List).map((json) => BillModel.fromJson(json)).toList();
//   }
// }

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/bill_model.dart';

class BillService {
  final _supabase = Supabase.instance.client;

  Future<List<BillModel>> fetchBills(String userId) async {
    try {
      // Query the 'bills' table for the matching user_id string
      // final List<dynamic> response = await _supabase
      //     .from('bills')
      //     .select()
      //     .eq('user_id', userId);

      // Ensure this is exactly '1' as a string in your fetch call
      //harcoded 1
final response = await _supabase
    .from('bills')
    .select()
    .eq('user_id', '1'); // Matches 'text' type in your screenshot
      
      return response.map((json) => BillModel.fromJson(json)).toList();
    } catch (e) {
      print("Supabase Fetch Error: $e");
      return [];
    }
  }
}