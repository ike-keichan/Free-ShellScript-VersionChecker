#!/bin/bash
# -*- coding: utf-8 -*-

# ver1.0 ： 2020/03/21
# ver2.0 : 2020/10/17
# このプログラムは京都産業大学 情報理工学部 青木淳教授の開講する授業で必要なソフトウェアのバージョンを管理するプログラムです。
# このプログラムの実行によって必要なソフトウェアのバージョンを列挙することができます。

#ターミナルの横幅
WIDTH=$(tput cols)

#nvmコマンドを実行可能にする
NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#各バージョンチェックのフラグ
mac_flag=false
c_flag=false
java_flag=false
python_flag=false
js_flag=false
ruby_flag=false
scm_flag=false
help_flag=false;
separeter_flag=true;

#描写時の仕切り
separater(){
  printf '\n%*s\n\n' ${WIDTH} | tr ' ' =
}

#OSのバージョンチェック
os_checker(){
    echo '＜Mac OS X（macOS）＞'
    sw_vers
    separater

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

    echo '＜Java/JavaScriptおよびC/C++プログラムの整形器（フォーマッタ）clang-format＞'
    clang-format -version
    separater
}

#Javaに関するバージョンチェック
java_checker(){
    echo '＜Java仮想マシン＞'
    (export JAVA_HOME=`/usr/libexec/java_home`; java -version)
    separater

    echo '＜Javaコンパイラ＞'
    (export JAVA_HOME=`/usr/libexec/java_home`; javac -version)
    separater

    echo '＜管理中のJava＞'
    /usr/libexec/java_home -V
    separater

    echo '＜JavaプログラムビルドツールApacheAnt＞'
    ant -version
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
    echo ""
    echo "--all       You can check all versions."
    echo "--macos     You can check version for MacOS and Xcode."
    echo "--c         You can check versions for C."
    echo "--ja        You can check versions for Java."
    echo "--py        You can check versions for Python."
    echo "--js        You can check versions for Javascript."
    echo "--rb        You can check versions for Ruby."
    echo "--scm       You can check versions for SCM"
    echo "--help      You can find out more about this command."
    echo ""
}


#オプションの条件分岐
while getopts ":aoxcprsh-:" option;
do
  case "$option" in
    -)
      case "${OPTARG}" in
        all)
            mac_flag=true; c_flag=true; java_flag=true; python_flag=true;
            js_flag=true; ruby_flag=true; scm_flag=true;;
        macos)
            mac_flag=true;;
        c)
            c_flag=true;;
        ja)
            java_flag=true;;
        js)
            js_flag=true;;
        py)
            python_flag=true;;
        rb)
            ruby_flag=true;;
        scm)
            scm_flag=true;;
        help)
            help_flag=true;;
      esac ;;
    ?)
        help_flag-true;
  esac
done

#各バージョンチェックのフラグ
if "${mac_flag}" ; then os_checker ;fi
if "${c_flag}" ; then c_checker ;fi
if "${java_flag}" ; then java_checker ; fi
if "${python_flag}" ; then python_checker ; fi
if "${js_flag}" ; then js_checker ; fi
if "${ruby_flag}" ; then ruby_checker ; fi
if "${scm_flag}" ; then scm_checker ; fi
if "${help_flag}" ; then helper ; fi
