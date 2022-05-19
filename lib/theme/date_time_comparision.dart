dateCompare({required DateTime day1, required DateTime day2}) {
  return day1.day == day2.day &&
      day1.month == day2.month &&
      day1.year == day2.year;
}
