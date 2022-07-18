import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToggleBar extends StatelessWidget {
  final List items;
  final int selectedIndex;
  final double itemWidth;
  final ValueChanged<int> onItemSelected;

  const ToggleBar(
      {Key? key,
      required this.items,
      this.selectedIndex = 0,
      required this.onItemSelected,
      this.itemWidth = 170})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(8.0),
        height: Get.height * 0.1,
        width: Get.width,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(
              width: 1.0,
              color: Theme.of(context).dividerTheme.color ?? Colors.white),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.map((item) {
            var index = items.indexOf(item);
            return GestureDetector(
              onTap: () => onItemSelected(index),
              child: ItemWidget(
                item: item,
                isSelected: index == selectedIndex,
                width: itemWidth,
              ),
            );
          }).toList(),
        ));
  }
}

class ItemWidget extends StatelessWidget {
  final bool isSelected;
  final ToggleBarItem item;
  final double width;
  const ItemWidget({
    Key? key,
    required this.item,
    required this.isSelected,
    this.width = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      selected: isSelected,
      child: AnimatedContainer(
        width: width,
        height: 60,
        duration: const Duration(milliseconds: 270),
        curve: Curves.linear,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.grey.withOpacity(.4)
              : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
            child: Text(
          item.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline4!.copyWith(
                fontWeight: FontWeight.bold,
                // color: Theme.of(context).dividerTheme.color
              ),
        )),
      ),
    );
  }
}

/// The [ToggleBarItem.items] definition.
class ToggleBarItem {
  ToggleBarItem({
    required this.title,
    this.activeColor = Colors.blue,
    this.inactiveColor,
  });

  final String title;

  final Color activeColor;

  final Color? inactiveColor;
}




///////////////////////////
/* class ToggleBar extends StatefulWidget {
  final TextStyle labelTextStyle;
  final Color backgroundColor;
  final double w;
  final BoxBorder backgroundBorder;
  final Color selectedTabColor;
  final Color selectedTextColor;
  final Color textColor;
  final List<String> labels;
  final Function(int) onSelectionUpdated;

  const ToggleBar(
      {Key? key,
      required this.labels,
      this.w = 170,
      this.backgroundColor = Colors.black,
      required this.backgroundBorder,
      this.selectedTabColor = Colors.deepPurple,
      this.selectedTextColor = Colors.white,
      this.textColor = Colors.black,
      this.labelTextStyle = const TextStyle(),
      required this.onSelectionUpdated})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ToggleBarState();
  }
}

class _ToggleBarState extends State<ToggleBar> {
  LinkedHashMap<String, bool> _hashMap = LinkedHashMap();
  int _selectedIndex = 0;

  @override
  void initState() {
    _hashMap = LinkedHashMap.fromIterable(widget.labels,
        value: (value) => value = false);
    _hashMap[widget.labels[0]] = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      height: Get.height * 0.1,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
            width: 1.0,
            color: Theme.of(context).dividerTheme.color ?? Colors.white),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ListView.builder(
          itemCount: widget.labels.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  child: Container(
                    width: widget.w,
                    decoration: BoxDecoration(
                      color: _hashMap.values.elementAt(index)
                          ? (Get.isDarkMode
                              ? Theme.of(context).scaffoldBackgroundColor
                              : Colors.grey.withOpacity(.4))
                          : null,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                        child: Text(
                      _hashMap.keys.elementAt(index),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            fontWeight: FontWeight.bold,
                            // color: Theme.of(context).dividerTheme.color
                          ),
                    )),
                  ),
                  onHorizontalDragUpdate: (dragUpdate) async {
                    int calculatedIndex = ((widget.labels.length *
                                    (dragUpdate.globalPosition.dx /
                                        (MediaQuery.of(context).size.width -
                                            32)))
                                .round() -
                            1)
                        .clamp(0, widget.labels.length - 1);

                    if (calculatedIndex != _selectedIndex) {
                      _updateSelection(calculatedIndex);
                    }
                  },
                  onTap: () async {
                    if (index != _selectedIndex) {
                      _updateSelection(index);
                    }
                  }),
            );
          }),
    );
  }

  _updateSelection(int index) {
    setState(() {
      _selectedIndex = index;
      widget.onSelectionUpdated(_selectedIndex);
      _hashMap.updateAll((label, selected) => selected = false);
      _hashMap[_hashMap.keys.elementAt(index)] = true;
    });
  }
}
 */