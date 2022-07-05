import 'package:bukulistrik/ui/pages/login_page/login_page_controller.dart';
import 'package:bukulistrik/ui/theme/spacing.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LoginPageView extends GetView<LoginPageController> {
  const LoginPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                CustomPaint(
                  painter: TrianglePainter(),
                  size: Size(Get.width, Get.height * 0.65),
                ),
                Positioned.fill(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo-white.png',
                          width: Get.width * 0.5,
                        ),
                        Spacing.h8,
                        Padding(
                          padding: Spacing.px8 * 4,
                          child: Text(
                            'Catat penggunaan listrik dengan mudah!',
                            textAlign: TextAlign.center,
                            style: Get.textTheme.headline6!.copyWith(
                              color: Get.theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SignInButtonBuilder(
                    elevation: 0,
                    key: const ValueKey("Google"),
                    text: 'Masuk dengan Google',
                    textColor: Get.theme.colorScheme.onPrimary,
                    image: Container(
                      color: Get.theme.colorScheme.primary,
                      margin: const EdgeInsets.fromLTRB(4, 4, 10.0, 4),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: const Image(
                          image: AssetImage(
                            'assets/logos/google_light.png',
                            package: 'flutter_signin_button',
                          ),
                          height: 36.0,
                        ),
                      ),
                    ),
                    backgroundColor: Get.theme.colorScheme.primary,
                    onPressed: () {
                      controller.signInWithGoogle();
                    },
                    innerPadding: const EdgeInsets.all(0),
                    height: 36.0,
                  ),
                  Spacing.h4,
                  Padding(
                    padding: Spacing.px8,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            style: Get.textTheme.caption,
                            text:
                                'Dengan menekan tombol di atas, Anda menyetujui ',
                          ),

                          // terms and conditions
                          // TextSpan(
                          //   text: 'Syarat dan Ketentuan',
                          //   style: Get.textTheme.caption!.copyWith(
                          //     color: Get.theme.colorScheme.primary,
                          //   ),
                          //   recognizer: TapGestureRecognizer()
                          //     ..onTap = () async {
                          //       const url = 'https://bukulistrik.web.app/terms';
                          //       if (await canLaunchUrlString(url)) {
                          //         await launchUrlString(url);
                          //       }
                          //     },
                          // ),
                          // TextSpan(
                          //   style: Get.textTheme.caption,
                          //   text: ' serta ',
                          // ),
                          TextSpan(
                            text: 'Kebijakan Privasi',
                            style: Get.textTheme.caption!.copyWith(
                              color: Get.theme.colorScheme.primary,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                const url =
                                    'https://bukulistrikapp.web.app/policy.html';
                                if (await canLaunchUrlString(url)) {
                                  await launchUrlString(url);
                                }
                              },
                          ),
                          TextSpan(
                            style: Get.textTheme.caption,
                            text: ' kami.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Get.theme.colorScheme.primary
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.8);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Paint paint = Paint();
    // paint.color = Colors.blue;
    // if (true != null) {
    //   paint.style = PaintingStyle.fill;
    // } else {
    //   paint.style = PaintingStyle.stroke;
    // }
    // paint.strokeCap = StrokeCap.round;
    // paint.strokeJoin = StrokeJoin.round;
    // paint.strokeWidth = 5;
    // Offset offset = Offset(size.width * 0.5, size.height);

    // Rect rect = Rect.fromCenter(center: offset, width: 50, height: 50);
    // canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
