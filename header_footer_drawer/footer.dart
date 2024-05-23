import 'package:flutter/material.dart';

import '../event/event_index_page.dart';
import '../user/my_page.dart';

class Footer extends StatefulWidget {

  final int pageNumber;
  const Footer({super.key, required this.pageNumber});

  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  late int _selectedIndex;
  final _bottomNavigationBarItems = <BottomNavigationBarItem>[];

  //アイコン情報
  static const _footerIcons = [
    Icons.calendar_month,
    Icons.groups,
    Icons.chat,
    Icons.edit_note,
    Icons.account_circle,
  ];

  //アイコン文字列
  static const _footerItemNames = [
    'イベント',
    '出席管理',
    'チャット',
    '議事録',
    'マイページ',
  ];

  //アイコンや文字列のカラー
  final List<Color?> _footerItemColor = [
    Colors.purple[200],
    Colors.pinkAccent,
    Colors.orange,
    Colors.blue,
    Colors.lightGreen,
  ];

  final _routes = [
    EventIndexPage(),
    EventIndexPage(),
    EventIndexPage(),
    EventIndexPage(),
    const MyPage(),
  ];

  @override
  void initState() {
    _selectedIndex = widget.pageNumber;
    super.initState();
    for ( var i =0; i < _footerItemNames.length; i++) {
      if(_selectedIndex != i) {
        _bottomNavigationBarItems.add(_UpdateDeactiveState(i));
      }
      else {
        _bottomNavigationBarItems.add(_UpdateActiveState(_selectedIndex));
      }
    }
  }

  // インデックスのアイテムをアクティベートする
  BottomNavigationBarItem _UpdateActiveState(int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        _footerIcons[index],
        color: _footerItemColor[index],
      ),
      label: _footerItemNames[index],

    );
  }

  // インデックスのアイテムをディアクティベートする
  BottomNavigationBarItem _UpdateDeactiveState(int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        _footerIcons[index],
        color: Colors.black26,
      ),
      label: _footerItemNames[index],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _bottomNavigationBarItems[_selectedIndex] = _UpdateDeactiveState(_selectedIndex);
      _bottomNavigationBarItems[index] = _UpdateActiveState(index);
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: _routes.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,  //これを書かないと３つまでしか表示されない
          items: _bottomNavigationBarItems,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}