// ignore_for_file: avoid_print

part of http;

class DioUtils {
  DioUtils._();
  static Dio? _instance;
  static CancelToken? cancelToken;

  static Dio getInstance() {
    if (_instance == null) {
      _instance = Dio();
      _instance!.interceptors.add(HeaderInterceptor());
      _instance!.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            // print(options.extra);
            // print('');
            // Log.v('>>>>>>>>HTTP LOG');
            // Log.v('>>>>>>>>URI: ${options.uri}');
            // // Log.v('>>>>>>>>Method: ${options.method}');
            // // Log.v('>>>>>>>>Headers: ${options.headers}');
            // JsonEncoder encoder = const JsonEncoder.withIndent('  ');
            // String prettyprint = encoder.convert(options.data);
            // Log.v('>>>>>>>>Body: $prettyprint');
            // Log.v('<<<<<<<<');
            // print('');
            handler.next(options);
          },
        ),
      );
    }
    return _instance!;
  }
}
