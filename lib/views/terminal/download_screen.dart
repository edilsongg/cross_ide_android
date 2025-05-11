import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:global_repository/global_repository.dart';
import 'package:path/path.dart' as p;

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  final Dio dio = Dio();
  Response<String>? response;
  final String filesPath = RuntimeEnvir.usrPath;
  List<String> androidAdbFiles = [
    'https://github.com/termux/termux-packages/releases/download/bootstrap-2025.04.27-r1%2Bapt.android-7/bootstrap-aarch64.zip'
    // 'https://nightmare-my.oss-cn-beijing.aliyuncs.com/Termare/bootstrap-aarch64.zip',
  ];
  String cur = '';
  double fileDownratio = 0.0;
  String title = '';
  Future<void> downloadFile(String urlPath) async {
    response = await dio.head<String>(urlPath);
    final int? fullByte = int.tryParse(
      response!.headers.value('content-length').toString(),
    ); //得到服务器文件返回的字节大小
    // final String _human = getFileSize(_fullByte); //拿到可读的文件大小返回给用户
    print('fullByte======$fullByte ${p.basename(urlPath)}');
    final String savePath = '$filesPath/${p.basename(urlPath)}';
    // print(savePath);
    await dio.download(
      urlPath,
      savePath,
      onReceiveProgress: (count, total) {
        final double process = count / total;
        fileDownratio = process;
        setState(() {});
        // );
      },
    );
    final ProcessResult result = Process.runSync(
      'chmod',
      <String>[
        '0777',
        savePath,
      ],
      environment: RuntimeEnvir.envir(),
    );
    Log.e(result.stderr);
    Log.d(result.stdout);
    await installModule(savePath);
  }

  Future<void> installModule(String modulePath) async {
    title = 'Extraindo';
    setState(() {});
    // Read the Zip file from disk.
    final bytes = File(modulePath).readAsBytesSync();
    // Decode the Zip file
    final archive = ZipDecoder().decodeBytes(bytes);
    // Extract the contents of the Zip archive to disk.
    final int total = archive.length;
    int count = 0;
    // print('total -> $total count -> $count');
    for (final file in archive) {
      final filename = file.name;
      final String path = '${RuntimeEnvir.usrPath}/$filename';
      cur = path;

      if (file.isFile) {
        final data = file.content as List<int>;
        await File(path).create(recursive: true);
        await File(path).writeAsBytes(data);
      } else {
        Directory(path).create(
          recursive: true,
        );
      }
      count++;
      fileDownratio = count / total;

      setState(() {});
    }
    File(modulePath).delete();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    execDownload();
  }

  Future<void> execDownload() async {
    List<String> needDownloadFile = [];
    if (Platform.isAndroid) {
      needDownloadFile = androidAdbFiles;
    }
    for (final String urlPath in needDownloadFile) {
      title = '${p.basename(urlPath)} ';
      setState(() {});
      await downloadFile(urlPath);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: AlertDialog(
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                child: LinearProgressIndicator(
                  value: fileDownratio,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                child: Text(
                  'Baixando $cur',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onPopInvoked: (didpop) async {
        showToast('Cancelar instalção');

        ///return false;
      },
    );
  }
}
