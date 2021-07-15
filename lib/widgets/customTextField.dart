import 'package:flutter/material.dart';
import 'package:cyclone/utils/res.dart';

class CustomTextField extends StatefulWidget {
  final String text;
  final IconData icon;
  final BorderRadius borderRadius;
  final Function onChanged;
  final Function validator;
  final bool isSuffixIcon;
  CustomTextField(
      {this.text,
      this.icon,
      this.validator,
      this.borderRadius,
      this.isSuffixIcon,
      this.onChanged});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return new Container(
      height: height * 0.111,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            offset: Offset(0.00, 8.00),
            color: Color(0xffe7eaf0),
            blurRadius: 15,
          ),
        ],
        borderRadius: this.widget.borderRadius,
      ),
      child: Center(
        child: TextFormField(
          validator: widget.validator,
          // onTap: () async {},
          obscureText: isVisible && widget.isSuffixIcon ? true : false,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: this.widget.text,
            hintStyle: TextStyle(
              fontFamily: "Segoe UI",
              fontSize: 12,
              color: Color(0xff515c6f).withOpacity(0.50),
            ),
            prefixIcon: Icon(
              this.widget.icon,
              color: Color(greyish),
            ),
            suffixIcon: widget.isSuffixIcon
                ? InkWell(
                    onTap: () {
                      setState(() {
                        isVisible = !isVisible;
                      });
                    },
                    child: Icon(
                      isVisible ? Icons.visibility_off : Icons.visibility,
                      color: Color(greyish),
                    ),
                  )
                : null,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
