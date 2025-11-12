import 'package:flutter/material.dart';
import '../models/exam_model.dart';

class ExamCard extends StatelessWidget {
  final Exam exam;
  final VoidCallback onTap;

  const ExamCard({super.key, required this.exam, required this.onTap});

  bool get _isPast => exam.dateTime.isBefore(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final accentColor = _isPast
        ? const Color(0xFF6D4C41)
        : const Color(0xFF5D4037);
    final backgroundColor = _isPast
        ? const Color(0xFFF5F5F5)
        : const Color(0xFFFFF8E1);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        color: backgroundColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: accentColor, width: 1),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 6,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exam.subject,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: accentColor,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.event,
                              size: 18,
                              color: Colors.black54,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _formatDateTime(exam.dateTime),
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 18,
                              color: Colors.black54,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _formatTime(exam.dateTime),
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.meeting_room,
                          color: Colors.brown.shade400,
                          size: 22,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          exam.rooms.join(', '),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade900,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDateTime(DateTime dt) {
  const weekDays = ['пон', 'вто', 'сре', 'чет', 'пет', 'саб', 'нед'];
  final wd = weekDays[(dt.weekday - 1) % 7];
  final dd = dt.day.toString().padLeft(2, '0');
  final mm = dt.month.toString().padLeft(2, '0');
  final yyyy = dt.year.toString();
  return '$dd.$mm.$yyyy ($wd)';
}

String _formatTime(DateTime dt) {
  final hh = dt.hour.toString().padLeft(2, '0');
  final min = dt.minute.toString().padLeft(2, '0');
  return '$hh:$min';
}
