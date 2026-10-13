import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/constants/utils.dart';
import 'common_app_bar.dart';
import 'common_text.dart';

class CommonWebView extends StatefulWidget {
  final String title;
  final String url;
  const CommonWebView({super.key, required this.title, required this.url});

  @override
  State<CommonWebView> createState() => _CommonWebViewState();
}

class _CommonWebViewState extends State<CommonWebView> {

  Uri? url;
  late WebViewController webViewController;
  ValueNotifier<bool> internet = ValueNotifier(false);
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory(() => EagerGestureRecognizer())
  };

  @override
  void initState() {
    super.initState();
    _internetPermission();
    url = Uri.parse(widget.url);
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            isLoading.value = false;
          },
        ),
      )
      ..loadRequest(url!);
  }

  Future<void> _internetPermission() async {
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.wifi)) {
      internet.value = true;
    } else if(connectivityResult.contains(ConnectivityResult.mobile)) {
      internet.value = true;
    } else {
      internet.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: CommonText(
          widget.title,
        ),
      ),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: internet,
          builder: (context, value, child) {
            if(value){
              return ValueListenableBuilder(
                valueListenable: isLoading,
                builder: (context, value, child) {
                  return value ? Center(
                    child: commonLoader(),
                  ) : WebViewWidget(
                    controller: webViewController,
                  );
                },
              );
            } else {
              return errorTextWidget(title: noInternetFound, tryAgain: () {
                webViewController = WebViewController()
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..setNavigationDelegate(
                    NavigationDelegate(
                      onPageFinished: (String url) {
                        isLoading.value = false;
                      },
                    ),
                  )
                  ..loadRequest(url!);
              });
            }
          },
        ),
      ),
    );
  }
}
