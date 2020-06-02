import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
class CategoryMenu extends StatefulWidget {
  @override
  _CategoryMenuState createState() => _CategoryMenuState();
}

class _CategoryMenuState extends State<CategoryMenu> {
  @override

  ScrollController _scrollController = ScrollController();
  AutoScrollController _autoScrollController = AutoScrollController();
  var _keys = {};
  int _selectedIndex = 0;

  Widget build(BuildContext context) {
    return Container(
      child: Container(
          height: 300,
        child: Row(
        children: <Widget>[
              _categoryListWidget(),
              _itemListWidget(),
              ],
        ),
      ),
    );
  }

  Widget _categoryListWidget() {
    return Container(
      width: 100,
      height: 300,
      child: ListView.builder(
          shrinkWrap: true,
          controller: _scrollController,
          itemCount: 4,
          itemBuilder: (context, index) {
            return GestureDetector(
              child:  Container(
                width: 100,
                height: 64,
                color: _selectedIndex == index ? Colors.red : Colors.white,
                child: Text(
                  '类目-${index}',
                  textAlign: TextAlign.center,
                ),
              ),
              onTap: () {
                  _selectedIndex = index;
                  _autoScrollController.scrollToIndex(index * 10, duration: Duration(microseconds: 200), preferPosition: AutoScrollPosition.begin);
                  setState(() {
                  });
              },
            );
          }),
    );
  }

  Widget _itemListWidget() {
    return Expanded(
        child: NotificationListener<ScrollUpdateNotification>(onNotification:(notification){

          List widgetIndexs = [];
          _keys.forEach((index, key) {
            var itemRect = getRectFromKey(index, key);

            if (itemRect != null && itemRect['offsetY'] > itemRect['height']) {
              widgetIndexs.add(itemRect);
            }
          });

          if (widgetIndexs.length > 0) {
            int widgetIndex = widgetIndexs[0]['index'];
            if ((widgetIndexs[0]['offsetY'] - widgetIndexs[0]['height']) >
                300 / 2.2) {
              widgetIndex -= 1;
            }
            if (widgetIndex ~/10 != _selectedIndex) {
              setState(() {
                _selectedIndex = widgetIndex;
              });
//              _scrollController.position.moveTo(widgetIndex ~/ 10 * 64.0 - 64.0);
            }
          }
          return true;
        },
          child: ListView.builder(
              shrinkWrap: true,
              controller: _autoScrollController,
              /// cacheExtent设置预加载区域
              cacheExtent: 300,
              itemCount: 40,
              itemBuilder: (context, index) {
                  _keys[index] = GlobalKey();
                  return AutoScrollTag(
                    key: ValueKey(index),
                    controller: _autoScrollController,
                    index: index,
                    child: Container(
                      height: 44,
                      child: Text(
                        'item-${index}',
                        textAlign: TextAlign.center,
                      ),
                      key: _keys[index],
                    ),
                  );
              },
          ),

        ),
    );
  }


  getRectFromKey(int index, GlobalKey globalKey) {
    RenderBox renderBox = globalKey?.currentContext?.findRenderObject();

    if (renderBox != null) {
      var offset = renderBox.localToGlobal(Offset(0.0, renderBox.size.height));
      return {
        'index': index,
        'height': renderBox.size.height,
        'offsetX': offset.dx,
        'offsetY': offset.dy
      };
    } else {
      return null;
    }
  }

}
