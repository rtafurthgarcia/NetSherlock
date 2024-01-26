import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:netsherlock/services/shodan_account_service.dart';
import 'package:qr_mobile_vision/qr_camera.dart';

class BarcodeScannerWithOverlay extends StatefulWidget {
  final ShodanAccountService shodanAccountService;

  const BarcodeScannerWithOverlay({super.key, required this.shodanAccountService});

  @override
  _BarcodeScannerWithOverlayState createState() =>
      _BarcodeScannerWithOverlayState();
}

class _BarcodeScannerWithOverlayState extends State<BarcodeScannerWithOverlay> {
  _BarcodeScannerWithOverlayState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    //controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  void onQrCodeDetected(String? newApiKey) {
    if (newApiKey == null || ShodanAccountService.validateApiKey(newApiKey) != null) {
      return;
    }

    widget.shodanAccountService.setApiKey(newApiKey);
    widget.shodanAccountService.reloadDetails();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.of(context).size.center(Offset.zero),
      width: 200,
      height: 200,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Please scan the shodan API QR code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: QrCamera(
                      onError: (context, error) => Text(
                        error.toString(),
                        style: const TextStyle(color: Colors.red),
                      ),
                      formats: const [BarcodeFormats.QR_CODE],
                      cameraDirection: CameraDirection.BACK,
                      qrCodeCallback: (value) => onQrCodeDetected(value),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: Colors.orange,
                            width: 10.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                    ),
                  ),
                  CustomPaint(
                    painter: ScannerOverlay(scanWindow),
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

class ScannerOverlay extends CustomPainter {
  ScannerOverlay(this.scanWindow);

  final Rect scanWindow;
  final double borderRadius = 12.0;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);
    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    // Create a Paint object for the white border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0; // Adjust the border width as needed

    // Calculate the border rectangle with rounded corners
// Adjust the radius as needed
    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    // Draw the white border
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
