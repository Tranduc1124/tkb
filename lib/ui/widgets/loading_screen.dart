import 'dart:async';
import 'package:flutter/cupertino.dart';  // ✅ Thêm import này
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../screens/home/home_screen.dart';
import 'glass_card.dart';  // ✅ Import GlassCard
import 'beautiful_icon_box.dart';  // ✅ Import BeautifulIconBox

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeInOut),
      ),
    );

    _controller.forward().then((_) {
      Timer(const Duration(milliseconds: 500), () {
        _navigateToHome();
      });
    });
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeWrapper()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Nền gradient hồng
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.pinkLight, AppColors.pinkDeep],
              ),
            ),
          ),
          
          // ✅ FIXED: Đơn giản hóa animation, chỉ dùng 1 controller
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: GlassCard(
                    opacity: 0.7,
                    padding: const EdgeInsets.all(40),
                    borderRadius: 30,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ✅ FIXED: Icon đúng tên + Rotation đơn giản
                        Transform.rotate(
                          angle: _controller.value * 2 * 3.14159, // 360° theo progress
                          child: const BeautifulIconBox(
                            icon: Icons.schedule,  // ✅ Icon Material thay vì Cupertino
                            color: Colors.blueAccent,
                            size: 60,
                          ),
                        ),
                        
                        const SizedBox(height: 25),
                        
                        // Text fade in
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: [
                              Text(
                                "Student Dashboard",
                                style: GoogleFonts.quicksand(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Đang tải dữ liệu...",
                                style: GoogleFonts.quicksand(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: _controller.value,  // ✅ Dùng controller.value
                            minHeight: 8,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.blueAccent,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 15),
                        
                        // 3 dots loading
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: (_controller.value * 3 - index)
                                            .clamp(0.0, 1.0) >
                                        0.5
                                    ? Colors.blueAccent
                                    : Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
