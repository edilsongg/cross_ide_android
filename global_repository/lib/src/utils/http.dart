library http;

import 'package:dio/dio.dart';
part 'src/exception.dart';
part 'src/dio_utils.dart';
part 'src/interceptors.dart';

// 一个dio的全局单例
Dio httpInstance = DioUtils.getInstance();
