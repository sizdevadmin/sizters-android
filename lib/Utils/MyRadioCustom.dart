import 'package:flutter/material.dart';

class MYRadioGroup<T> extends StatefulWidget {
  /// List of items to be shown
  final List<T> items;

  /// Function to detect selected radio button
  /// This returns selected object
  final ValueChanged onChanged;

  /// To set selected item
  final T? selectedItem;

  /// Mark list items as disabled.
  final bool disabled;

  /// Set scroll direction of list Default is vertical.
  final Axis scrollDirection;

  /// Create label for radio item
  final Widget? Function(BuildContext, int) labelBuilder;

  final Color? activeColor;

  final Color? fillColor;

  final ScrollPhysics? scrollPhysics;

  final bool shrinkWrap;

  /// This widget creates s list of radio group widget
  /// So that you can easily implement List of radio buttons
  /// Just by passing a list of String or any object.
  const MYRadioGroup({
    Key? key,
    required this.items,
    required this.onChanged,
    this.selectedItem,
    this.disabled = false,
    this.scrollDirection = Axis.vertical,
    required this.labelBuilder,
    this.scrollPhysics,
    this.shrinkWrap = false,
    this.activeColor,
    this.fillColor,
  }) : super(key: key);
  @override
  RadioGroupWidget createState() => RadioGroupWidget();
}

class RadioGroupWidget extends State<MYRadioGroup> {
  dynamic selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.selectedItem;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, index) {
          return SizedBox(
            width: widget.scrollDirection == Axis.horizontal ? 10 : 0,
            height: widget.scrollDirection == Axis.horizontal ? 0 : 10,
          );
        },
        physics: widget.scrollPhysics,
        scrollDirection: widget.scrollDirection,
        shrinkWrap: widget.shrinkWrap,
        itemCount: widget.items.length,
        itemBuilder: (ctx, index) {
          return InkWell(
            onTap: widget.disabled == true
                ? null
                : () {
                    widget.onChanged(widget.items[index]);

                    setState(() {
                      selectedItem = widget.items[index];
                    });
                  },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
              Radio<dynamic>(
                groupValue: selectedItem,
                value: widget.items[index],
                activeColor: widget.activeColor,
                fillColor: MaterialStatePropertyAll(widget.fillColor),
                visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: widget.disabled == true
                    ? null
                    : (val) {
                        widget.onChanged(val);

                        setState(() {
                          selectedItem = val;
                        });
                      },
              ),
              const SizedBox(
                width: 10,
              ),
              widget.labelBuilder(ctx, index) ?? const SizedBox.shrink(),
            ]),
          );
        });
  }
}
