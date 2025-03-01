import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:deep_link_main/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _receivedId;
  final _appLinks = AppLinks();
  String _launchStatus = '';

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
  }

  Future<void> _handleIncomingLinks() async {
    _appLinks.uriLinkStream.listen(
      (Uri uri) {
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

  Future<void> _launchURLScheme() async {
    final Uri url = Uri.parse(Platform.isIOS
        ? 'deepLinkSubScheme://fetch'
        : 'deepLinkSubScheme://fetchid');

    try {
      await launchUrl(url);
    } catch (e) {
      setState(() {
        _launchStatus = 'エラーが発生しました: $e';
      });
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
            ElevatedButton(
              onPressed: _launchURLScheme,
              child: const Text('別アプリを開く'),
            ),
            const SizedBox(height: 8),
            Text(
              _launchStatus,
              style: const TextStyle(color: Colors.blue),
            ),
            const SizedBox(height: 16),
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
