import 'package:ite_project/models/sessionStudents.dart';

class ReportForm {
  final SessionStudents student;
  final String presencePercentage;
  final String absencePercentage;
  final String subjectName;
  final String teacherName;
  ReportForm(this.teacherName, this.subjectName, this.student,
      this.presencePercentage, this.absencePercentage);
}
