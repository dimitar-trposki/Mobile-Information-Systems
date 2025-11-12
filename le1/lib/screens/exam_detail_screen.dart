import 'package:flutter/material.dart';
import '../models/exam_model.dart';

class ExamDetailScreen extends StatelessWidget {
  final Exam exam;

  const ExamDetailScreen({super.key, required this.exam});

  bool get _isPast => exam.dateTime.isBefore(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final cardColor = _isPast
        ? const Color(0xFFF5F5F5)
        : const Color(0xFFFFF8E1);

    final timeLeftText = _timeLeftText(exam.dateTime);

    return Scaffold(
      backgroundColor: Color(0xFFFAF7EF),
      appBar: AppBar(
        backgroundColor: Color(0xFFFAF7EF),
        elevation: 0,
        titleSpacing: 16,
        title: const Text(
          'Детали за испит',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color(0xFF5D4037),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.brown),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: cardColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: Color(0xFF5D4037)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 18.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.subject,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D4037),
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 12),
                Divider(color: Colors.brown),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.event, size: 20, color: Colors.black54),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(exam.dateTime),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Icon(
                      Icons.access_time,
                      size: 20,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTime(exam.dateTime),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.meeting_room,
                      size: 20,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        exam.rooms.join(', '),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(color: Colors.brown),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.brown),
                  ),
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 20,
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Статус и време',
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade900,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            _isPast
                                ? Icons.check_circle
                                : Icons.hourglass_bottom,
                            color: Colors.brown.shade400,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _isPast
                                  ? 'Испитот е поминат.'
                                  : 'Преостанато време до испит: \n$timeLeftText',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _formatDate(DateTime dt) {
  final dd = dt.day.toString().padLeft(2, '0');
  final mm = dt.month.toString().padLeft(2, '0');
  final yyyy = dt.year.toString();
  const weekDaysLong = [
    'понеделник',
    'вторник',
    'среда',
    'четврток',
    'петок',
    'сабота',
    'недела',
  ];
  final wdl = weekDaysLong[(dt.weekday - 1) % 7];
  return '$dd.$mm.$yyyy ($wdl)';
}

String _formatTime(DateTime dt) {
  final hh = dt.hour.toString().padLeft(2, '0');
  final min = dt.minute.toString().padLeft(2, '0');
  return '$hh:$min';
}

String _timeLeftText(DateTime target) {
  Duration diff = target.difference(DateTime.now());
  if (diff.isNegative) diff = Duration.zero;
  final days = diff.inDays;
  final hours = diff.inHours - days * 24;
  return '$days дена, $hours часа';
}
