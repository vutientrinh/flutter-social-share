import 'package:intl/intl.dart';

class StringUtils {
  static String formatK(int? num) {
    if (num == null) return "0";
    String result = "";
    if (num >= 1000) {
      result = (num / 1000).toString() + "k";
    } else {
      result = num.toString();
    }
    return result;
  }

  static String? calcTimePost(DateTime createdAt) {
    final now = DateTime.now().toUtc();
    if (now.year == createdAt.year) {
      final dif = now.difference(createdAt);

      final difMinutes = dif.inMinutes;
      if (difMinutes < 60) {
        if (difMinutes == 0) {
          return 'Just now';
        }
        if (difMinutes < 2) {
          return '1 minute ago';
        }
        return '${difMinutes.toString()} minutes ago';
      }

      final difHours = dif.inHours;
      if (difHours < 2) {
        return '${difHours.toString()} hour ago';
      }
      if (difHours < 24) {
        return '${difHours.toString()} hours ago';
      }

      final createdAtLocal = createdAt.toLocal();
      final hour = createdAtLocal.hour.toString().padLeft(2, '0');
      final minute = createdAtLocal.minute.toString().padLeft(2, '0');

      final format = DateFormat('MMMM d, yyyy');
      final timeAfterFormat = format.format(createdAt);
      return timeAfterFormat;
    }
  }
}
