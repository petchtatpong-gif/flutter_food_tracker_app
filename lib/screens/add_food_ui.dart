import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_food_tracker_app/models/food_model.dart';
import 'package:flutter_food_tracker_app/services/food_service.dart';

class AddFoodUi extends StatefulWidget {
  const AddFoodUi({super.key});

  @override
  State<AddFoodUi> createState() => _AddFoodUiState();
}

class _AddFoodUiState extends State<AddFoodUi> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _peopleController = TextEditingController();
  
  String _selectedTimePeriod = 'กลางวัน';
  DateTime _selectedDate = DateTime.now();
  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _peopleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("เพิ่มข้อมูลอาหาร", style: GoogleFonts.kanit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.fastfood, size: 80, color: Colors.brown),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "ชื่ออาหาร",
                  border: OutlineInputBorder(),
                  hintText: "เช่น KFC, พิซซ่า",
                ),
                validator: (v) => v?.isEmpty ?? true ? "กรุณากรอกชื่ออาหาร" : null,
              ),
              const SizedBox(height: 20),
              const Text("ช่วงเวลาที่ทาน:"),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: ['เช้า', 'กลางวัน', 'เย็น', 'ว่าง'].map((period) {
                  return ChoiceChip(
                    label: Text(period),
                    selected: _selectedTimePeriod == period,
                    onSelected: (selected) {
                      setState(() {
                        _selectedTimePeriod = period;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "ราคา (บาท)",
                  border: OutlineInputBorder(),
                  hintText: "เช่น 299.50",
                ),
                validator: (v) => v?.isEmpty ?? true ? "กรุณากรอกราคา" : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _peopleController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "จำนวนคน",
                  border: OutlineInputBorder(),
                  hintText: "เช่น 3",
                ),
                validator: (v) => v?.isEmpty ?? true ? "กรุณากรอกจำนวนคน" : null,
              ),
              const SizedBox(height: 20),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: Text("วันที่: ${_selectedDate.toString().split(' ')[0]}"),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[100],
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_selectedImage!, fit: BoxFit.cover),
                        )
                      : const Center(child: Text("แตะเพื่อเลือกรูปภาพ")),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _isLoading = true);
                          FoodService.addFood(
                            name: _nameController.text,
                            timePeriod: _selectedTimePeriod,
                            price: double.tryParse(_priceController.text) ?? 0.0,
                            people: int.tryParse(_peopleController.text) ?? 0,
                            date: _selectedDate.toString().split(' ')[0],
                            imageFile: _selectedImage,
                          ).then((success) {
                            if (mounted) {
                              setState(() => _isLoading = false);
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("บันทึกข้อมูลสำเร็จ"), backgroundColor: Colors.green),
                                );
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("เกิดข้อผิดพลาดในการบันทึก"), backgroundColor: Colors.red),
                                );
                              }
                            }
                          });
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text("บันทึกข้อมูล", style: GoogleFonts.kanit(fontSize: 20)),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("ยกเลิก", style: TextStyle(color: Colors.red, fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}