class AppUrl {
  final int id;
  final String type;

  AppUrl({required this.id, required this.type});

  factory AppUrl.parseUrl(String url) {
    List<String> parts = url.split('?');
    return AppUrl(
      id: int.parse(parts[1].toString()),
      type: parts[0].split("/").last,
    );
  }
}
