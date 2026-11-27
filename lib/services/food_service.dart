import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_food_tracker_app/core/supabase_config.dart';
import 'package:flutter_food_tracker_app/models/food_model.dart';

class FoodService {
  static final SupabaseClient _client = SupabaseConfig.client;

  /// ดึงข้อมูลรายการอาหารทั้งหมด
  static Future<List<Food>> fetchFoods() async {
    try {
      final response = await _client.from('food_tb').select();
      return (response as List).map((data) => Food.fromMap(data)).toList();
    } catch (e) {
      print('Error fetching foods: $e');
      return [];
    }
  }

  /// เพิ่มข้อมูลอาหารใหม่พร้อมอัปโหลดรูปภาพ
  static Future<bool> addFood({
    required String name,
    required String timePeriod,
    required double price,
    required int people,
    required String date,
    File? imageFile,
  }) async {
    try {
      String? imageUrl;
      if (imageFile != null) {
        // ตั้งชื่อไฟล์ตามเวลาและชื่อเดิม
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split(Platform.pathSeparator).last}';
        final path = 'foods/$fileName';

        await _client.storage
          .from('food_bk')
          .upload(path, imageFile);

        imageUrl = _client.storage
          .from('food_bk')
          .getPublicUrl(path);
      }

      await _client.from('food_tb').insert({
        'name': name,
        'time_period': timePeriod,
        'price': price,
        'people': people,
        'date': date,
        'image_url': imageUrl,
      });

      return true;
    } catch (e) {
      print('Error adding food: $e');
      return false;
    }
  }

  /// อัปเดตข้อมูลอาหาร
  static Future<bool> updateFood(Food food) async {
    try {
      await _client.from('food_tb').update(food.toMap()).eq('id', food.id);
      return true;
    } catch (e) {
      print('Error updating food: $e');
      return false;
    }
  }

  /// ลบข้อมูลอาหาร
  static Future<bool> deleteFood(String id) async {
    try {
      await _client.from('food_tb').delete().eq('id', id);
      return true;
    } catch (e) {
      print('Error deleting food: $e');
      return false;
    }
  }
}