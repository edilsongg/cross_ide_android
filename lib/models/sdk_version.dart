class SdkVersionModel {
  final String tagName;
/*   final String downloadUrl; */

  SdkVersionModel({
    required this.tagName,
    /* required this.downloadUrl */
  });

  factory SdkVersionModel.fromJson(Map<String, dynamic> json) {
    /*   final asset = (json['assets'] as List).firstWhere(
      (a) => (a as Map<String, dynamic>)['name'].contains('.zip'),
      orElse: () => null,
    ); */
    return SdkVersionModel(
      tagName: json['tag_name'],
      /* downloadUrl: (asset as Map<String, dynamic>)['browser_download_url'], */
    );
  }
}
