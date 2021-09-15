import 'package:flutter/material.dart';
import 'package:ite_project/constants.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class StudentsSelect extends StatelessWidget {
  final List<MultiSelectItem<dynamic>> items;
  final Function onConfirm;
  StudentsSelect({this.items, this.onConfirm});

  void _showMultiSelect(BuildContext context) async {
    await showDialog(
      barrierColor: Colors.white54,
      context: context,
      builder: (ctx) {
        return MultiSelectDialog(
          items: items,
          cancelText: Text(
            'الغاء',
            style: kDefaultTextStyle.copyWith(fontSize: 18),
          ),
          confirmText: Text(
            'اضافة',
            style: kDefaultTextStyle.copyWith(fontSize: 18),
          ),
          title: Text(
            'حدد الطلاب',
            style: kDefaultTextStyle.copyWith(fontSize: 18),
          ),
          searchHint: 'ابحث عن طالب',
          backgroundColor: Colors.white70,
          itemsTextStyle:
              kDefaultTextStyle.copyWith(fontSize: 20, color: Colors.black54),
          selectedItemsTextStyle:
              kDefaultTextStyle.copyWith(fontSize: 20, color: Colors.green),
          onConfirm: onConfirm,
          initialValue: [],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.white54, Colors.white70],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(
          Icons.person,
          size: 35,
          color: Color(0xff343a40),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: TextButton(
            onPressed: () => _showMultiSelect(context),
            child: Text(
              'اختر الطلاب',
              style: kDefaultTextStyle.copyWith(
                fontSize: 25,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
