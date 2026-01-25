import '../../domain/entities/user.dart';

class UserModel {
  final int id;
  final String email;
  final String username; // غيرناfullname لـ username ليتطابق مع الـ JSON
  final String city;     // غيرنا address لـ city لأننا سنأخذ المدينة فقط كـ String
  final String phone;
  final String firstName; // أضفنا هذه الحقول لاستخدامها في الـ Entity
  final String lastName;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.city,
    required this.phone,
    required this.firstName,
    required this.lastName,
  });

  // تم تصحيح الـ Getter
  String get fullName => '$firstName $lastName';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // هنا يكمن سر الحل: استخراج القيم من الخرائط المتداخلة (Nested Maps)
    return UserModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      // ✅ استخراج المدينة من داخل خريطة العنوان
      city: json['address']['city'],
      phone: json['phone'],
      // ✅ استخراج الاسم الأول والأخير من داخل خريطة الاسم
      firstName: json['name']['firstname'],
      lastName: json['name']['lastname'],
    );
  }

  User toEntity() {
    return User(
      id: id,
      fullName: fullName, // نمرر الاسم المدمج
      email: email,
      phone: phone,
      city: city, // نمرر المدينة
    );
  }
}