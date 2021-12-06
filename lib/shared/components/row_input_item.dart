import 'package:flutter/material.dart';

class RowInputItem extends StatelessWidget {
  final String labelTitle;
  final Widget inputField;
  final double? spaceBetweenLabelAndInput;
  RowInputItem({
    required this.labelTitle,
    required this.inputField,
    this.spaceBetweenLabelAndInput = 0.03,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(end: spaceBetweenLabelAndInput!),
          child: Text(
            labelTitle,
            style: TextStyle(
              fontSize: width * 0.085,
            ),
          ),
        ),
        Expanded(
          child: inputField,
        ),
      ],
    );
  }
}
