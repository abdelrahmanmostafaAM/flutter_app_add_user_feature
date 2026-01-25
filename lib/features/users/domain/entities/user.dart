import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email;
  final String fullName; // تم توحيد الاسم ليطابق الـ Model
  final String phone;
  final String city;     // تم التغيير من address إلى city لتناسب البيانات المستخرجة

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.city,
  });

  @override
  List<Object?> get props => [id, email, fullName, phone, city];
}