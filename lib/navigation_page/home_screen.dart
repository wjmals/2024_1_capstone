import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:cappp/navigation_page/chat.dart'; // LiveChatList가 포함된 파일을 가져옵니다.
import 'package:cappp/navigation_page/like.dart';
import 'package:cappp/navigation_page/write.dart';
import 'package:cappp/navigation_page/person.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _nestedTabController;
  int _selectedIndex = 0;
  late IO.Socket _socket;

  @override
  void initState() {
    super.initState();
    _nestedTabController = TabController(length: 2, vsync: this);

    // Socket.io 연결 설정
    _socket = IO.io('ws://localhost:8080/ws/chat', <String, dynamic>{
      'transports': ['websocket'],
    });

    _socket.onConnect((_) {
      print('Connected to WebSocket');
    });

    _socket.onConnectError((data) {
      print('Connect Error: $data');
    });

    _socket.onDisconnect((_) {
      print('Disconnected from WebSocket');
    });
  }

  @override
  void dispose() {
    _nestedTabController.dispose();
    _socket.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // 네비게이션 처리
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LikeScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductRegistrationScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LiveChatList(socket: _socket),
          ),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('홈 화면'),
        bottom: _selectedIndex == 0
            ? TabBar(
          controller: _nestedTabController,
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black54,
          isScrollable: true,
          tabs: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: Tab(
                child: Text(
                  "중고거래",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: Tab(
                child: Text(
                  "공동구매",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
          padding: EdgeInsets.only(top: 25.0),
        )
            : null,
      ),
      body: _selectedIndex == 0
          ? TabBarView(
        controller: _nestedTabController,
        children: [
          Center(child: Text('중고거래')),
          Center(child: Text('공동구매')),
        ],
      )
          : Center(child: Text('Index $_selectedIndex')),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sms_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 0,
        unselectedFontSize: 0,
      ),
    );
  }
}
