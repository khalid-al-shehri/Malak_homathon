import 'package:flutter/material.dart';
import 'package:kksa/colors.dart';

class CustomDialogWithoutButton extends StatefulWidget {

  final String headerText;
  final Widget content;
  final double width;
  final Color backgroundColor;
  final double borderRadius;
  final double headerHeight;
  final double contentHeight;

  const CustomDialogWithoutButton({
    Key key,
    this.headerText,
    this.content,
    this.width,
    this.backgroundColor,
    this.borderRadius,
    this.headerHeight,
    this.contentHeight,
  }) : super(key: key);


  @override
  _CustomDialogWithoutButtonState createState() => _CustomDialogWithoutButtonState();
}

class _CustomDialogWithoutButtonState extends State<CustomDialogWithoutButton> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            width: widget.width,
            decoration: ShapeDecoration(
                color: widget.backgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(widget.borderRadius)
                ),
              shadows: [
                BoxShadow(
                  blurRadius: 4.0,
                  color: Colors.black.withOpacity(0.20),
                  offset: Offset(4.5, 5.0),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                // Header
                Container(
                  decoration: BoxDecoration(
                      color: otherMessageBackground,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2.0,
                          color: Colors.black.withOpacity(0.15),
                          offset: Offset(0.0, 1.0),
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(widget.borderRadius),
                        topRight: Radius.circular(widget.borderRadius),
                      )
                  ),
                  height: 50,
                  child: Center(
                    child: Text(
                      widget.headerText,
                      textScaleFactor: 1.0,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                    ),
                  ),
                ),

                //Body
                Container(
                  height: MediaQuery.of(context).size.height * 0.60,
                  child: widget.content,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}