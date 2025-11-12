import 'package:flutter/material.dart';
import '../data/exams.dart';
import '../models/exam_model.dart';
import '../widgets/exam_card.dart';
import 'exam_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Exam> sorted = List.of(studentExams)
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    final total = sorted.length;
    final now = DateTime.now();

    const scaffoldColor = Color(0xFFFAF7EF);
    const appBarColor = Color(0xFF5D4037);
    final chipBorder = Colors.brown.shade200;

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        backgroundColor: scaffoldColor,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 16,
        title: Text(
          'Распоред за испити - $studentIndex',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.2,
            color: appBarColor,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Colors.brown),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 112),
        itemCount: sorted.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final exam = sorted[index];
          return ExamCard(
            exam: exam,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ExamDetailScreen(exam: exam)),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: scaffoldColor,
            border: Border(top: BorderSide(color: Colors.brown)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: chipBorder, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.list_alt,
                      size: 18,
                      color: const Color(0xFF6D4C41),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Вкупно испити: $total',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: chipBorder, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 18,
                      color: const Color(0xFF6D4C41),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Преостанати: ${sorted.where((e) => e.dateTime.isAfter(now)).length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
