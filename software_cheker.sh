#!/bin/bash
# -*- coding: utf-8 -*-

#ターミナルの横幅
WIDTH=$(tput cols)

#nvmコマンドを実行可能にする
NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#各バージョンチェックのフラグ
os_flag=false
xcode_flag=false
c_flag=false
java_flag=false
js_flag=false
c_ja_js_flag=false
python_flag=false
ruby_flag=false
scm_flag=false
help_flag=true

#描写時の仕切り
separater(){
  printf '\n%*s\n\n' ${WIDTH} | tr ' ' =
}

#OSのバージョンチェック
os_checker(){
  echo '＜Mac OS X（macOS）＞'
    sw_vers
  separater
}

#Xcodeのバージョンチェック
xcode_checker(){
  echo '＜Xcode（コマンドラインツール）＞'
    xcodebuild -version
    printf '%*s\n' ${WIDTH} | tr ' ' -
    pkgutil --pkg-info=com.apple.pkg.CLTools_Executables | grep version
  separater
}

#Cに関するバージョンチェック
c_checker(){
  echo '＜Cコンパイラ＞'
    cc --version
    printf '%*s\n' ${WIDTH} | tr ' ' -
    gcc --version
    printf '%*s\n' ${WIDTH} | tr ' ' -
    clang --version
  separater

  echo '＜CプログラムビルドツールMake＞'
    make --version
  separater

  echo '＜Cプログラム静的コード解析器（アナライザ）scan-build（およびscan-view）＞'
    scan-build --help | grep checker-
  separater
}

#Javaに関するバージョンチェック
java_checker(){
  echo '＜Java仮想マシン＞'
    (export JAVA_HOME=`/usr/libexec/java_home -v "1.8"`; java -version)
  separater

  echo '＜Javaコンパイラ＞'
    (export JAVA_HOME=`/usr/libexec/java_home -v "1.8"`; javac -version)
  separater

  echo '＜管理中のJava＞'
    /usr/libexec/java_home -V
  separater

  echo '＜JavaプログラムビルドツールApacheAnt＞'
    ant -version
  separater
}

#Javascriptに関するバージョンチェック
js_checker(){
  echo '＜JavaScript処理系＞'
    jsc -e 'let v = version(); print(v);    // Currently does nothing. It will return undefined.'
  separater

  echo '＜Node.js＞'
    node --version
  separater

  echo '＜Node.jsバージョン管理ツールnvm＞'
    nvm --version
  separater

  echo '＜管理中のNode.js＞'
    nvm ls
  separater
}

#Java/JavaScriptおよびC/C++に関するバージョンチェック
c_ja_js_checker(){
  echo '＜Java/JavaScriptおよびC/C++プログラムの整形器（フォーマッタ）clang-format＞'
    clang-format -version
  separater
}

#Pythonに関するバージョンチェック
python_checker(){
  echo '＜Python処理系＞'
    python --version
  separater

  echo '＜Pythonバージョン管理ツールpyenv＞'
    pyenv --version
  separater

  echo '＜管理中のPython＞'
    pyenv versions
  separater
}

#Rubyに関するバージョンチェック
ruby_checker(){
  echo '＜Ruby処理系＞'
    ruby --version
  separater

  echo '＜Rubyバージョン管理ツールrbenv＞'
    rbenv --version
  separater

  echo '＜管理中のRuby＞'
    rbenv versions
  separater
}

#SCMに関するバージョンチェック
scm_checker(){
  echo '＜集中型のソフトウェア構成管理SVN(Subversion)＞'
    svn --version
  separater

  echo '＜分散型のソフトウェア構成管理Git＞'
    git --version
  separater
}

#オプションの説明
helper(){
  echo "-a, --all          You can check all versions."
  echo "-o, --macos        You can check the OS version."
  echo "-x, --xcode        You can check the Xcode version."
  echo "-c                 You can check versions for C."
  echo "--ja, --java       You can check versions for Java."
  echo "--js, --javascript You can check versions for Javascript."
  echo "-p, --python       You can check versions for Python."
  echo "-r, --ruby         You can check versions for Ruby."
  echo "-s, --scm          You can check versions for SCM."
  echo "-h, --help         You can find out more about this command."
  separater
}

separater

#オプションの条件分岐
while getopts ":aoxcprsh-:" option;
do
  case "$option" in
    -)
      case "${OPTARG}" in
        all)
          os_flag=true;
          xcode_flag=true;
          c_flag=true;
          java_flag=true;
          js_flag=true;
          c_ja_js_flag=true;
          python_flag=true;
          ruby_flag=true;
          scm_flag=true;
          help_flag=false;;
        macos)
          os_flag=true;
          help_flag=false;;
        xcode)
          xcode_flag=true;
          help_flag=false;;
        ja)
          java_flag=true;
          c_ja_js_flag=true;
          help_flag=false;;
        java)
          java_flag=true;
          c_ja_js_flag=true;
          help_flag=false;;
        js)
          js_flag=true;
          c_ja_js_flag=true;
          help_flag=false;;
        javascript)
          js_flag=true;
          c_ja_js_flag=true;
          help_flag=false;;
        python)
          python_flag=true;
          help_flag=false;;
        ruby)
          ruby_flag=true;
          help_flag=false;;
        scm)
          scm_flag=true;
          help_flag=false;;
        help)
          help_flag=true;;
      esac
      ;;
    a)
      os_flag=true;
      xcode_flag=true;
      c_flag=true;
      java_flag=true;
      js_flag=true;
      c_ja_js_flag=true;
      python_flag=true;
      ruby_flag=true;
      scm_flag=true;
      help_flag=false;;
    o)
      os_flag=true;
      help_flag=false;;
    x)
      xcode_flag=true;
      help_flag=false;;
    c)
      c_flag=true;
      c_ja_js_flag=true;
      help_flag=false;;
    p)
      python_flag=true;
      help_flag=false;;
    r)
      ruby_flag=true;
      help_flag=false;;
    s)
      scm_flag=true;
      help_flag=false;;
    h)
      help_flag=true;;
    ?)
      help_flag=true;;
  esac
done

#各バージョンチェックのフラグ
if "${os_flag}"; then
  os_checker
fi

if "${xcode_flag}"; then
  xcode_checker
fi

if "${c_flag}"; then
  c_checker
fi

if "${java_flag}"; then
  java_checker
fi

if "${js_flag}"; then
  js_checker
fi

if "${c_ja_js_flag}"; then
  c_ja_js_checker
fi

if "${python_flag}"; then
  python_checker
fi

if "${ruby_flag}"; then
  ruby_checker
fi

if "${scm_flag}"; then
  scm_checker
fi

if "${help_flag}"; then
  helper
fi
