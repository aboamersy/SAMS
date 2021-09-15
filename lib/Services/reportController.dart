import 'package:ite_project/models/reportForm.dart';
import 'package:gsheets/gsheets.dart';
import 'package:ite_project/constants.dart';

class ReportController {
  Future<void> submitReport(int row, ReportForm report, {bool clear}) async {
    try {
      // init GSheets

      final gsheets = GSheets(credentials);
      // fetch spreadsheet by its id
      final ss = await gsheets.spreadsheet(spreadsheetId);
      // get worksheet by its title
      var sheet = ss.worksheetByTitle('${report.subjectName}');
      // create worksheet if it does not exist yet
      sheet ??= await ss.addWorksheet('${report.subjectName}');

      if (row == 2) {
        if (clear) sheet.clear();
        await sheet.values.insertRow(1, firstRow);
      }

      String presence;
      report.student.presence ? presence = 'حاضر' : presence = 'غائب';
      List<String> data = [
        report.teacherName,
        report.subjectName,
        report.student.session,
        report.student.student.name,
        report.student.student.id,
        report.student.student.year,
        presence,
        report.presencePercentage,
        report.absencePercentage
      ];
      await sheet.values.insertRow(row, data);
    } catch (e) {
      print(e);
    }
  }
}
