import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'service/bill_service.dart';
import 'models/bill_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from the .env file in root
  await dotenv.load(fileName: ".env");

  // Initialize Supabase using environment variables
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CoachMint',
      // Theme matching your UI screenshots
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF00E676),
        scaffoldBackgroundColor: const Color(0xFF121417),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section matching the dashboard context
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
                child: Text(
                  "Upcoming Bills",
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.white
                  ),
                ),
              ),
              
              // Horizontal slider taking up ~30% of screen height
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: FutureBuilder<List<BillModel>>(
                  // Fetching data for Mukesh (User ID: '1')
                  future: BillService().fetchBills('1'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text("No bills found", style: TextStyle(color: Colors.grey))
                      );
                    }

                    final bills = snapshot.data!;
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: bills.length,
                      itemBuilder: (context, index) {
                        final bill = bills[index];
                        return Container(
                          width: 220,
                          margin: const EdgeInsets.only(right: 16, top: 10, bottom: 20),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            // Dark card background color
                            color: const Color(0xFF1C1F26),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                bill.name, 
                                style: const TextStyle(fontSize: 14, color: Colors.grey)
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "₹${bill.amount}", 
                                style: const TextStyle(
                                  fontSize: 30, 
                                  fontWeight: FontWeight.bold, 
                                  color: Color(0xFF00E676) // Mint accent color
                                )
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 14, color: Colors.white70),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Due: ${bill.dueDate.day}/${bill.dueDate.month}/${bill.dueDate.year}",
                                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                                  ),
                                ],
                              ),
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
      ),
    );
  }
}