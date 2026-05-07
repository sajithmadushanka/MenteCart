import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/config/env.dart';

class PayHerePaymentScreen
    extends StatefulWidget {
  final String bookingId;

  const PayHerePaymentScreen({
    super.key,
    required this.bookingId,
  });

  @override
  State<PayHerePaymentScreen>
      createState() =>
          _PayHerePaymentScreenState();
}

class _PayHerePaymentScreenState
    extends State<
      PayHerePaymentScreen
    > {
  late final WebViewController
  controller;

  @override
  void initState() {
    super.initState();

    final paymentUrl =
        '${Env.apiBaseUrl}/payments/payhere/page/${widget.bookingId}';

    controller =
        WebViewController()
          ..setJavaScriptMode(
            JavaScriptMode
                .unrestricted,
          )
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (
                request,
              ) {
                if (request.url
                    .contains(
                      '/payment/success',
                    )) {
                  Navigator.pop(
                    context,
                    true,
                  );

                  return NavigationDecision
                      .prevent;
                }

                if (request.url
                    .contains(
                      '/payment/cancel',
                    )) {
                  Navigator.pop(
                    context,
                    false,
                  );

                  return NavigationDecision
                      .prevent;
                }

                return NavigationDecision
                    .navigate;
              },
            ),
          )
          ..loadRequest(
            Uri.parse(
              paymentUrl,
            ),
          );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PayHere Payment',
        ),
      ),

      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}