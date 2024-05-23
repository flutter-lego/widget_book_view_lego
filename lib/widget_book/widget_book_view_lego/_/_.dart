import 'package:device_preview_minus/device_preview_minus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class NewView extends StatefulWidget {
  const NewView({super.key});

  @override
  State<NewView> createState() => _NewViewState();
}

class _NewViewState extends State<NewView> {
  int _selectedIndex = 0;
  final FocusNode _focusNode = FocusNode();
  bool _loading = false;
  bool _switchMobileMode = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: (KeyEvent event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
              _setSelectedIndex((_selectedIndex - 1).clamp(0, 2));
            } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
              _setSelectedIndex((_selectedIndex + 1).clamp(0, 2));
            }
          }
        },
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 4,
              child: Container(
                color: Colors.black,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Gap(20),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_iphone,
                          color: Colors.white,
                          size: 30,
                        ),
                        Gap(10),
                        CupertinoSwitch(
                          value: _switchMobileMode,
                          onChanged: (bool value) {
                            switchModeEvent(value);
                          },
                        ),
                      ],
                    ).padding(left: 20),
                    Gap(20),
                    Text("[User]'s\nWidget Book",
                            style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold))
                        .padding(left: 20, right: 10),
                    Gap(20),
                    _buildTextButton('First', 0),
                    _buildTextButton('Second', 1),
                    _buildTextButton('Third', 2),
                  ],
                ),
              ),
            ),
            // const VerticalDivider(thickness: 1, width: 1),
            Flexible(
              flex: 7,
              child: IndexedStack(
                index: _loading ? 0 : 1,
                children: <Widget>[
                  DevicePreview(
                    builder: (context) => CupertinoActivityIndicator().center(),
                    backgroundColor: Colors.grey.withOpacity(0.1),
                    isToolbarVisible: false,
                  ),
                  _buildContent(_switchMobileMode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextButton(String text, int index) {
    return TextButton(
      onPressed: () {
        _setSelectedIndex(index);
      },
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: _selectedIndex == index ? Colors.white : Colors.grey,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    ).padding(vertical: 2, horizontal: 10);
  }

  Widget _buildContent(bool switchMobileMode) {
    switch (_selectedIndex) {
      case 0:
        return DevicePreview(
          enabled: switchMobileMode,
          builder: (context) => Container(color: Colors.red),
          backgroundColor: Colors.grey.withOpacity(0.1),
          isToolbarVisible: false,
        );
      case 1:
        return DevicePreview(
          enabled: switchMobileMode,
          builder: (context) => Container(color: Colors.green),
          backgroundColor: Colors.grey.withOpacity(0.1),
          isToolbarVisible: false,
        );
      case 2:
        return DevicePreview(
          enabled: switchMobileMode,
          builder: (context) => Container(color: Colors.blue),
          backgroundColor: Colors.grey.withOpacity(0.1),
          isToolbarVisible: false,
        );
      default:
        return NewView();
    }
  }

  _setSelectedIndex(int index) {
    startLoading();
    setState(() {
      _selectedIndex = index;
    });
  }

  startLoading() {
    if (!_switchMobileMode) return;
    setState(() {
      _loading = true;
    });
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _loading = false;
      });
    });
  }

  /// event ///
  switchModeEvent(bool value) {
    setState(() {
      _switchMobileMode = value;
    });
  }
}

void main() async {
  runApp(MaterialApp(
    home: NewView(),
  ));
}
