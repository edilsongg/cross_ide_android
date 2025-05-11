import 'package:global_repository/global_repository.dart';

class Consts {
  static const int initialTerminals = 1;
  static const String prefsKey = 'open_terminals_count';

  static String lockFile = '${RuntimeEnvir.dataPath}/cache/init_lock';

  static String initShell = '''
function initApp(){
  cd ${RuntimeEnvir.usrPath}/
  for line in `cat SYMLINKS.txt`
  do
    OLD_IFS="\$IFS"
    IFS="←"
    arr=(\$line)
    IFS="\$OLD_IFS"
    filename=\$(basename "\${arr[0]}")
    echo -n -e "\x1b[2K\r- \$filename"
    ln -s \${arr[0]} \${arr[3]}
  done
  echo
  rm -rf SYMLINKS.txt
  TMPDIR=${RuntimeEnvir.tmpPath}
  filename=bootstrap
  rm -rf "\$TMPDIR/\$filename*"
  rm -rf "\$TMPDIR/*"
  chmod -R 0777 ${RuntimeEnvir.binPath}/*
  chmod -R 0777 ${RuntimeEnvir.usrPath}/lib/* 2>/dev/null
  chmod -R 0777 ${RuntimeEnvir.usrPath}/libexec/* 2>/dev/null
  rm -rf $lockFile
  export LD_PRELOAD=${RuntimeEnvir.usrPath}/lib/libtermux-exec.so
  bash
}
''';
}
