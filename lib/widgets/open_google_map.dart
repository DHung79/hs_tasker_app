import 'package:url_launcher/url_launcher.dart';

Future<void> openMap({required double lat, required double long}) async {
  String googleUrl =
      'https://www.google.com/maps/search/?api=1&query=$lat,$long';
  if (await canLaunchUrl(Uri.parse(googleUrl))) {
    await launchUrl(Uri.parse(googleUrl));
  } else {
    throw 'Could not open the map.';
  }
}
