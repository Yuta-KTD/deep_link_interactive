import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  String? _receivedId;
  final _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
  }

  Future<void> _handleIncomingLinks() async {
    _appLinks.uriLinkStream.listen(
      (uri) {
        setState(() {
          _receivedId = uri.queryParameters['id'];
        });
      },
      onError: (err) {
        debugPrint('エラーが発生しました: $err');
      },
    );
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        setState(() {
          _receivedId = uri.queryParameters['id'];
        });
      }
    } catch (e) {
      debugPrint('初期リンクの取得に失敗しました: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('受信したIDの表示'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '受信したID:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Text(
              _receivedId ?? 'IDはまだ受信していません',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
