import 'time_slot.dart';

class PeriodConfig {
  int index;
  TimeSlot start;
  TimeSlot end;

  PeriodConfig({
    required this.index,
    required this.start,
    required this.end,
  });
}
