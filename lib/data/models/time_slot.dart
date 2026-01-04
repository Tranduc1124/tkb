class TimeSlot {
  int hour;
  int minute;

  TimeSlot(this.hour, this.minute);

  int get toMinutes => hour * 60 + minute;

  String toStringFormat() =>
      "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
}
