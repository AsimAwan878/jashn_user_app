
class Handler {
  late String url;

  Handler(String controller) {
    url = 'http://haulers.tech/jashn/mobile/$controller';
  }

  String getUrl() {
    return url;
  }
}