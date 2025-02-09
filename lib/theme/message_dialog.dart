import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:news_app_flutter/theme/style.dart';

import '../constant/constant.dart';

//SHOW MESSAGE DIALOG
Future<void> showMessageDialog(BuildContext context, String message, bool status) async {
  Flushbar(
    messageText: Row(
      children: [
        Icon(
          status ? Icons.check : Icons.clear,
          color: status ? Colors.green : Colors.red,
        ),
        Style.space(10, 0),
        Text(
          message,
          style: const TextStyle(
            fontSize: 15, // Kích thước font chữ
            fontWeight: FontWeight.w600, // Kiểu chữ đậm
            color: Colors.black, // Màu chữ
            fontFamily: textFontContent, // Font chữ tùy chỉnh
          ),
        ),
      ],
    ),
    boxShadows: [
      BoxShadow(
          color: Colors.grey.withOpacity(0.8),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3)),
    ],
    duration: const Duration(seconds: 2),
    backgroundColor: Colors.white60,
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
  ).show(context);
}

//CONVERT FOMART DATE
String formatDate(String date) {
  DateTime parsedDate = DateTime.parse(date);
  return DateFormat('EEEE, dd MMMM yyyy').format(parsedDate);
}

//DIALOG SHARE
void showDialogShareLink(BuildContext context, String url, bool isShare){
  TextEditingController controller = TextEditingController();
  controller.text = url;
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text("Link news"),
      content: Container(
        width: 60,
        height: 60,
        child: TextField(
          readOnly: true,
          textAlign: TextAlign.center,
          maxLines: 1, // Single line to enable horizontal scrolling
          decoration: InputDecoration(
            hintText: controller.text,
            hintStyle: const TextStyle(
                fontFamily: textFontContent,
                fontSize: 10,
                fontWeight: FontWeight.w600
            ),
            suffixIcon: IconButton(
              onPressed: () {
                try {
                  Clipboard.setData(ClipboardData(text: controller.text));
                  showMessageDialog(context, "Copied Link", true);
                } catch (e) {
                  showMessageDialog(context, "Clip board unavailable", false);
                }
              },
              icon: const Icon(Icons.copy),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          style: const TextStyle(overflow: TextOverflow.ellipsis), // Display ellipsis if text is too long
          scrollPadding: EdgeInsets.zero,
          scrollPhysics: const BouncingScrollPhysics(), // For smoother scrolling
          textInputAction: TextInputAction.none,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            isShare = !isShare;
            Navigator.pop(context);
          },
          child: const Text("Done"),
        )
      ],
    ),
  );
}

