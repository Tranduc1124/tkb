import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../logic/providers/schedule_provider.dart';
import '../../../logic/providers/theme_provider.dart';
import '../../widgets/beautiful_icon_box.dart';

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final schedule = Provider.of<ScheduleProvider>(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Cài đặt",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildSectionHeader("Giao diện"),
                ListTile(
                  leading: const BeautifulIconBox(
                    icon: CupertinoIcons.photo,
                    color: Colors.purpleAccent,
                    size: 40,
                  ),
                  title: const Text("Đổi hình nền"),
                  subtitle: const Text("Chọn ảnh từ thư viện"),
                  trailing:
                      const Icon(CupertinoIcons.chevron_right, size: 16),
                  onTap: () async {
                    final picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery);
                    if (image != null) {
                      // ignore: use_build_context_synchronously
                      Provider.of<ThemeProvider>(context, listen: false)
                          .setBackgroundImage(image.path);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  },
                ),
                ListTile(
                  leading: const BeautifulIconBox(
                    icon: CupertinoIcons.arrow_counterclockwise,
                    color: Colors.pinkAccent,
                    size: 40,
                  ),
                  title: const Text("Mặc định (Nền hồng)"),
                  onTap: () {
                    Provider.of<ThemeProvider>(context, listen: false)
                        .resetBackground();
                    Navigator.pop(context);
                  },
                ),
                const Divider(height: 40),
                _buildSectionHeader("Test trạng thái"),
                const Text(
                  "Dùng để debug UI nhanh:",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _testBtn(context, "Đang học", HomeState.learning,
                        Colors.blue, schedule),
                    _testBtn(context, "Sắp học", HomeState.upcoming,
                        Colors.orange, schedule),
                    _testBtn(context, "Rảnh", HomeState.free, Colors.green,
                        schedule),
                  ],
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const BeautifulIconBox(
                    icon: CupertinoIcons.calendar_today,
                    color: Colors.teal,
                    size: 40,
                  ),
                  title: const Text("Cấu hình thời khóa biểu"),
                  trailing: const Icon(CupertinoIcons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            "Phần editor TKB chi tiết sẽ implement sau."),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  Widget _testBtn(
    BuildContext context,
    String label,
    HomeState state,
    Color color,
    ScheduleProvider schedule,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
      ),
      onPressed: () {
        schedule.debugSimulate(state);
        Navigator.pop(context);
      },
      child: Text(label),
    );
  }
}
