import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url = 'https://gpmjvqlsiulbprdbzbal.supabase.co';
  // ให้ใช้ Anon Key ที่ถูกต้องจาก Dashboard (คุณสามารถเปลี่ยนค่านี้ได้ภายหลัง)
  static const String anonKey = 'sb_publishable_z7rmGPK2tmmq09o_WVGwSw_RSKl_5U1';

  static Future<void> init() async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}