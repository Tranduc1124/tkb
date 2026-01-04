// lib/ui/screens/home/home_screen.dart - FIXED VERSION
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../logic/providers/schedule_provider.dart';
import '../../../logic/providers/theme_provider.dart';
import '../../widgets/beautiful_icon_box.dart';
import '../../widgets/glass_card.dart';
import '../settings/settings_screen.dart';

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ThemeProvider>(
        builder: (context, theme, child) {
          return Stack(
            children: [
              // ✅ FIXED: Kiểm tra null trước khi dùng Image
              Positioned.fill(
                child: theme.backgroundImagePath != null && 
                       theme.backgroundImagePath!.isNotEmpty
                    ? Image.file(
                        File(theme.backgroundImagePath!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Fallback nếu ảnh lỗi
                          return _buildDefaultBackground();
                        },
                      )
                    : _buildDefaultBackground(),
              ),
              const SafeArea(child: HomeScreen()),
              Positioned(
                right: 20,
                bottom: 30,
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const SettingsSheet(),
                    );
                  },
                  child: const Icon(
                    CupertinoIcons.settings,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ✅ Helper method cho nền mặc định hồng nhẹ
  Widget _buildDefaultBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.pinkLight,
            AppColors.pinkDeep,
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final schedule = Provider.of<ScheduleProvider>(context);
    final now = DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          _buildHeader(now),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  _buildMainCard(schedule),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Lịch trình hôm nay",
                      style: GoogleFonts.quicksand(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildTodayList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(DateTime now) {
    final thu = "Thứ ${now.weekday + 1}";
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              thu,
              style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            Text(
              DateFormat('dd/MM/yyyy').format(now),
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black.withOpacity(0.6),
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        GlassCard(
          opacity: 0.4,
          padding: const EdgeInsets.all(10),
          borderRadius: 16,
          child: Icon(
            now.hour < 18
                ? CupertinoIcons.sun_max_fill
                : CupertinoIcons.moon_stars_fill,
            color: now.hour < 18 ? Colors.orange : Colors.indigo,
            size: 30,
          ),
        )
      ],
    );
  }

  Widget _buildMainCard(ScheduleProvider schedule) {
    return GlassCard(
      child: Column(
        children: [
          BeautifulIconBox(
            icon: schedule.statusIcon,
            color: schedule.statusColor,
            size: 70,
          ),
          const SizedBox(height: 20),
          Text(
            schedule.statusTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          const SizedBox(height: 10),
          Text(
            schedule.statusSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: schedule.statusColor,
            ),
          ),
          const SizedBox(height: 20),
          if (schedule.currentState == HomeState.learning)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const LinearProgressIndicator(
                value: 0.7,
                minHeight: 6,
                backgroundColor: Colors.black12,
                valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTodayList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 2,
      itemBuilder: (ctx, index) {
        final isFirst = index == 0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            opacity: 0.4,
            borderRadius: 16,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Tiết ${index + 1}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isFirst ? "Toán Cao Cấp" : "Vật Lý Đại Cương",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isFirst ? "Phòng A101" : "Phòng B202",
                      style: const TextStyle(
                          fontSize: 14, color: Colors.black54),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
