import 'package:url_launcher/url_launcher.dart';

class MapService {
  static Future<void> launchMaps(double latitude, double longitude, String label) async {
    final double lat = latitude;
    final double lng = longitude;
    
    // Android uses geo: URL or Google Maps intent
    final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    final appleMapsUrl = 'https://maps.apple.com/?q=$label&ll=$lat,$lng';

    try {
      await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
    } catch (_) {
      try {
        await launchUrl(Uri.parse(appleMapsUrl), mode: LaunchMode.externalApplication);
      } catch (e) {
        throw 'Could not launch Maps for coordinates $lat, $lng';
      }
    }
  }
}
