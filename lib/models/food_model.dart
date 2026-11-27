class Food {
  final String id;
  final String name;
  final String timePeriod; // เช้า, กลางวัน, เย็น, ว่าง
  final double price;
  final int people;
  final String date;
  final String? imageUrl;

  Food({
    required this.id,
    required this.name,
    required this.timePeriod,
    required this.price,
    required this.people,
    required this.date,
    this.imageUrl,
  });

  /// แปลงข้อมูลเป็น Map เพื่อส่งไปยัง Supabase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'time_period': timePeriod,
      'price': price,
      'people': people,
      'date': date,
      'image_url': imageUrl,
    };
  }

  /// สร้าง Object จาก Map ที่ได้รับจาก Supabase
  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      timePeriod: map['time_period'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      people: (map['people'] ?? 0).toInt(),
      date: map['date'] ?? '',
      imageUrl: map['image_url'],
    );
  }
}