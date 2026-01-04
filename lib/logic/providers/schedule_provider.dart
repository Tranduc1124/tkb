import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/models/subject.dart';
import '../../data/models/period_config.dart';
import '../../data/models/time_slot.dart';

enum HomeState { learning, upcoming, free }

class ScheduleProvider with ChangeNotifier {
  HomeState currentState = HomeState.free;
  String statusTitle = "Tự do!";
  String statusSubtitle = "Không có tiết học lúc này";
  Color statusColor = Colors.green;
  IconData statusIcon = CupertinoIcons.smiley;

  List<PeriodConfig> timeConfigs = [
    PeriodConfig(
      index: 1,
      start: TimeSlot(7, 0),
      end: TimeSlot(7, 45),
    ),
    PeriodConfig(
      index: 2,
      start: TimeSlot(7, 50),
      end: TimeSlot(8, 35),
    ),
  ];

  Map<int, List<Subject>> weeklySchedule = {};

  ScheduleProvider() {
    _initMockData();
    Timer.periodic(const Duration(minutes: 1), (_) => updateHomeState());
    updateHomeState();
  }

  void _initMockData() {
    int today = DateTime.now().weekday + 1;
    weeklySchedule[today] = [
      Subject(name: "Lập Trình Mobile", room: "Lab 3", isOff: false),
      Subject(name: "Cấu Trúc Dữ Liệu", room: "B202", isOff: false),
    ];
  }

  void updateHomeState() {
    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final todayWeekday = now.weekday + 1;

    final todaySubjects = weeklySchedule[todayWeekday];

    if (todaySubjects == null || todaySubjects.isEmpty) {
      _setFree("Hôm nay được nghỉ!");
      return;
    }

    bool found = false;

    for (int i = 0;
        i < timeConfigs.length && i < todaySubjects.length;
        i++) {
      final config = timeConfigs[i];
      final subject = todaySubjects[i];
      if (subject.isOff) continue;

      final startMin = config.start.toMinutes;
      final endMin = config.end.toMinutes;

      if (currentMinutes >= startMin && currentMinutes <= endMin) {
        currentState = HomeState.learning;
        statusTitle = "Đang học: ${subject.name}";
        statusSubtitle =
            "Còn ${endMin - currentMinutes} phút nữa hết giờ";
        statusColor = Colors.blueAccent;
        statusIcon = CupertinoIcons.book_fill;
        found = true;
        break;
      }

      if (currentMinutes < startMin &&
          currentMinutes >= startMin - 15) {
        currentState = HomeState.upcoming;
        statusTitle = "Tiết sau: ${subject.name}";
        statusSubtitle =
            "Phòng ${subject.room} - Vào lúc ${config.start.toStringFormat()}";
        statusColor = Colors.orangeAccent;
        statusIcon = CupertinoIcons.time;
        found = true;
        break;
      }
    }

    if (!found) {
      _setFree("Đã hết lịch hoặc đang nghỉ giải lao");
    }

    notifyListeners();
  }

  void _setFree(String msg) {
    currentState = HomeState.free;
    statusTitle = "Tự do!";
    statusSubtitle = msg;
    statusColor = Colors.green;
    statusIcon = CupertinoIcons.smiley;
  }

  void debugSimulate(HomeState state) {
    currentState = state;
    if (state == HomeState.learning) {
      statusTitle = "Đang học: Demo Flutter";
      statusSubtitle = "Còn 30 phút";
      statusColor = Colors.blueAccent;
      statusIcon = CupertinoIcons.book_fill;
    } else if (state == HomeState.upcoming) {
      statusTitle = "Sắp học: Toán";
      statusSubtitle = "Phòng A101";
      statusColor = Colors.orangeAccent;
      statusIcon = CupertinoIcons.time;
    } else {
      _setFree("Debug: Rảnh");
    }
    notifyListeners();
  }
}
