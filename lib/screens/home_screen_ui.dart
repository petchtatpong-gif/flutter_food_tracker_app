import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_food_tracker_app/services/food_service.dart';
import 'package:flutter_food_tracker_app/models/food_model.dart';
import 'package:flutter_food_tracker_app/screens/add_food_ui.dart';
import 'package:flutter_food_tracker_app/screens/food_detail_ui.dart';

class HomeScreenUi extends StatefulWidget {
  const HomeScreenUi({super.key});

  @override
  State<HomeScreenUi> createState() => _HomeScreenUiState();
}

class _HomeScreenUiState extends State<HomeScreenUi> {
  late Future<List<Food>> _foodsFuture;

  @override
  void initState() {
    super.initState();
    _foodsFuture = FoodService.fetchFoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Food Tracker",
          style: GoogleFonts.kanit(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Logo and Title Section
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                ),
                const SizedBox(height: 10),
                Text(
                  "กินกันเถอะ",
                  style: GoogleFonts.kanit(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
              ],
            ),
          ),
          // List of Foods
          Expanded(
            child: FutureBuilder<List<Food>>(
              future: _foodsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("เกิดข้อผิดพลาด: "));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("ยังไม่มีข้อมูลการบันทึกอาหาร"));
                }

                final foods = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: foods.length,
                  itemBuilder: (context, index) {
                    final food = foods[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            food.imageUrl ?? '',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.fastfood, size: 40, color: Colors.brown),
                          ),
                        ),
                        title: Text(
                          food.name,
                          style: GoogleFonts.kanit(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          "วันที่:  | ช่วงเวลา:  | ราคา:  บาท",
                          style: GoogleFonts.kanit(fontSize: 12, color: Colors.grey[700]),
                        ),
                        trailing: const Icon(Icons.chevron_right, color: Colors.brown),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FoodDetailUi(food: food),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Add Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton.large(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddFoodUi()),
                );
              },
              backgroundColor: Colors.brown[800],
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}
