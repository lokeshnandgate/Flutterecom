import 'package:flutter/material.dart';
import '../modules/auth/screens/login_screen.dart';
import '../modules/auth/screens/user_register_screen.dart';
import '../modules/auth/screens/business_register_screen.dart';
import '../modules/auth/screens/dashboard_screen.dart';
import '../modules/auth/screens/profile_screen.dart';
import '../modules/auth/screens/chat_list_screen.dart';

class Routes {
  static const String home = '/';
  static const String login = '/login';
  static const String userRegister = '/register/user';
  static const String businessRegister = '/register/business';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String chats = '/chats';

  static const String chatDetail = '/chat/detail';
  static const String productDetail = '/product/detail';
  static const String addProduct = '/product/add';

  static Map<String, WidgetBuilder> get all {
    return {
      home: (context) => const HomeScreen(),
      login: (context) => const LoginScreen(),
      userRegister: (context) => const UserRegisterScreen(),
      businessRegister: (context) => const BusinessRegisterScreen(),
      dashboard: (context) => const DashboardScreen(),
      profile: (context) => const ProfileScreen(),
      chats: (context) => const ChatListScreen(),
    };
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0E3659), Color(0xFF0A4B7A)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to Your All-in-One Service Hub!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'From food to fashion, digital downloads to destination stays — everything you need is right here.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ..._buildServiceItems(),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, Routes.login),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  List<Widget> _buildServiceItems() {
    final services = [
      {
        'title': 'Online Product Marketplace 🛍',
        'desc': 'Discover an ever-growing selection of goods in our marketplace. Whether it’s electronics, fashion, or handmade crafts, shop confidently with trusted vendors and smooth delivery.'
      },
      {
        'title': '🍽 Food Delivery & Table Booking',
        'desc': 'Craving your favorite meal or planning a dinner out? Order from local restaurants or reserve your table in advance — hassle-free and instant.'
      },
      {
        'title': '🏨 Hotel & Room Booking',
        'desc': 'Book comfortable stays at the best prices. From boutique hotels to beachfront resorts, enjoy instant confirmation and exclusive deals.'
      },
      {
        'title': '💇‍♀️ Salon & Spa Booking',
        'desc': 'Pamper yourself with spa treatments, salon visits, and wellness sessions. Book your time slot easily and skip the wait.'
      },
      {
        'title': '🛒 Grocery & Essentials Delivery',
        'desc': 'Shop groceries, household items, and daily needs from local stores and get them delivered to your doorstep quickly and safely.'
      },
      {
        'title': '🎫 Event Ticket Booking',
        'desc': 'Secure your spot at concerts, workshops, or sports events. Browse listings, pick seats, and get e-tickets instantly.'
      },
      {
        'title': '🚗 Rental Marketplace',
        'desc': 'Rent cars, bikes, tools, or even party supplies. A flexible and cost-effective way to get what you need when you need it.'
      },
      {
        'title': '💾 Digital Products Store',
        'desc': 'Download eBooks, software, design assets, and more. A secure platform for instant access to digital content.'
      },
      {
        'title': '🌿 Hyperlocal Farm/Food Delivery',
        'desc': 'Get fresh produce, dairy, and organic items straight from nearby farms. Support local growers while enjoying peak freshness.'
      },
    ];

    return services.map((service) => _buildServiceItem(service['title']!, service['desc']!)).toList();
  }


  Widget _buildServiceItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              color: Color(0xFF80D8FF),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}






