import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_food_tracker_app/models/food_model.dart';
import 'package:flutter_food_tracker_app/services/food_service.dart';
import 'package:flutter_food_tracker_app/screens/edit_food_ui.dart';

class FoodDetailUi extends StatelessWidget {
  final Food food;

  const FoodDetailUi({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(food.name, style: GoogleFonts.kanit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                food.imageUrl ?? '',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                    Container(height: 250, color: Colors.grey[300], child: Icon(Icons.fastfood, size: 100, color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "รายละเอียดข้อมูลอาหาร",
              style: GoogleFonts.kanit(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildDetailRow("ชื่ออาหาร:", food.name),
            _buildDetailRow("ช่วงเวลา:", food.timePeriod),
            _buildDetailRow("ราคา:", " บาท"),
            _buildDetailRow("จำนวนคน:", " คน"),
            _buildDetailRow("วันที่ทาน:", food.date),
            const SizedBox(height: 40),
            Text(
              "จัดการข้อมูล",
              style: GoogleFonts.kanit(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditFoodUi(food: food),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700]),
                    child: const Text("แก้ไขข้อมูล", style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      bool success = await FoodService.deleteFood(food.id);
                      if (success) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ลบข้อมูลสำเร็จ")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ลบข้อมูลไม่สำเร็จ")));
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
                    child: const Text("ลบข้อมูล", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: GoogleFonts.kanit(fontSize: 14, color: Colors.grey[600])),
          Text(value, style: GoogleFonts.kanit(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
