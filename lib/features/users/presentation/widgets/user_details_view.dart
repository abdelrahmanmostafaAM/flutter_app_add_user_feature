import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';

class UserDetailsView extends StatelessWidget {
  final User user;

  const UserDetailsView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. الجزء العلوي: الخلفية وصورة البروفايل
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade400,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
              ),
              Positioned(
                top: 80,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.lightBlue.shade100,
                    child: Text(
                      user.fullName[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.deepOrangeAccent,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),

          // 2. اسم المستخدم والمعرف (Username)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              user.fullName,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 24),

          // 3. بطاقة معلومات التواصل (Contact Info)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 0,
              color: Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildDetailTile(Icons.email_outlined, 'Email', user.email),
                  const Divider(indent: 50),
                  _buildDetailTile(Icons.phone_outlined, 'Phone', user.phone),
                  const Divider(indent: 50),
                  _buildDetailTile(
                    Icons.location_city_outlined,
                    'City',
                    user.city,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // زر إضافي لمظهر احترافي
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget مساعد لبناء الأسطر المعلوماتية
  Widget _buildDetailTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.deepPurple),
      ),
      title: Text(
        label,
        style: const TextStyle(fontSize: 18, color: Colors.grey),
      ),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }
}
