import 'package:flutter/material.dart';
import 'package:ite_project/constants.dart';
import 'package:select_form_field/select_form_field.dart';

class SubjectSelect extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final String title;
  final Function onChanged;
  SubjectSelect({@required this.items, @required this.title, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.white70,
            Colors.white24,
          ],
        ),
      ),
      child: ListTile(
        leading: Icon(
          Icons.format_shapes,
          size: 30,
          color: Colors.teal,
        ),
        title: Container(
          padding: EdgeInsets.only(left: 70),
          child: SelectFormField(
            type: SelectFormFieldType.dialog, // or can be dialog
            textDirection: TextDirection.ltr,
            enableSearch: true,
            dialogSearchHint: 'البحث',
            dialogCancelBtn: 'تراجع',
            labelText: 'اختر المادة',
            style: kDefaultTextStyle.copyWith(fontSize: 25, color: Colors.teal),
            decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintStyle: kDefaultTextStyle.copyWith(
                    fontSize: 25, color: Colors.teal),
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                hintText: title),

            items: items,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
