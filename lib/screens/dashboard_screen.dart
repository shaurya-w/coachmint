import 'package:flutter/material.dart';
import 'package:my_app/service/bill_service.dart';
import '../models/bill_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121417), // Match design background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
              child: Text(
                "Upcoming Bills",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            
            // Expanded allows the list to fill the remaining vertical space
            Expanded(
              child: FutureBuilder<List<BillModel>>(
                future: BillService().fetchBills('1'), // Mukesh's ID from DB
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFF00E676)));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No bills found", style: TextStyle(color: Colors.grey)));
                  }

                  final bills = snapshot.data!;
                  return ListView.builder(
                    // Removed scrollDirection: Axis.horizontal to make it vertical
                    padding: const EdgeInsets.all(16),
                    itemCount: bills.length,
                    itemBuilder: (context, index) {
                      final bill = bills[index];
                      return Container(
                        // Width is now automatic (fills screen width)
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1F26), // Card color
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: Row( // Use Row to put amount and name side-by-side if stacked
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(bill.name.toUpperCase(), 
                                  style: const TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 1.2)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time_filled, size: 14, color: Colors.white54),
                                    const SizedBox(width: 6),
                                    Text("Due ${bill.dueDate.day}/${bill.dueDate.month}", 
                                      style: const TextStyle(color: Colors.white54, fontSize: 13)),
                                  ],
                                ),
                              ],
                            ),
                            Text("₹${bill.amount.toStringAsFixed(0)}", 
                              style: const TextStyle(
                                color: Color(0xFF00E676), // Mint accent
                                fontSize: 24, 
                                fontWeight: FontWeight.bold
                              )),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}