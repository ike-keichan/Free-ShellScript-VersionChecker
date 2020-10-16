#!/bin/bash
# -*- coding: utf-8 -*-

# ver1.0 ： 2020/10/17
# ver1.1 ： 2020/10/17
# 現バージョンはいくつか問題があります。そもそも、確認するソフトウェアがインストールされていない場合、ShellScriptがエラーを出します。
# また、それぞれのコマンドのパスが通っていない場合などもShellScriptがエラーを出すでしょう。
# そのほかにはgccのバージョンチェックの際に「Configured with:~~~」と表示され、見栄えが悪くなります。
# これらのことを理解した上でお使いくださいませ。修正はしたいです。（願望）（予定）（確定ではない）
#
# このプログラムは京都産業大学 情報理工学部 青木淳教授の開講する授業で必要なソフトウェアのバージョンを管理するプログラムです。
# このプログラムの実行によって青木さんと自分のソフトウェアのバージョンの比較をすることができます。
# 青木さんのバージョンと同じバージョンを使っていれば授業でのトラブルは減ります。

# Javaのオプションを非表示にする。
_SILENT_JAVA_OPTIONS="$_JAVA_OPTIONS"
unset _JAVA_OPTIONS
alias java='java "$_SILENT_JAVA_OPTIONS"'

# NVMのパスを通す。
NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# 青木さんのページを参照するための設え
CHECK_URL='http://www.cc.kyoto-su.ac.jp/~atsushi/Programs/SoftwareVersions/index-j.html'
CHECK_SOURCE="curl -s ${CHECK_URL}"

# 各バージョンを確認するコマンド群
MACOS_VERSION_COMMAND="sw_vers"
XCODE_VERSION_COMMAND="xcodebuild -version"
XCODE_COMMAND_LINE_TOOL_VERSION_COMMAND="pkgutil --pkg-info=com.apple.pkg.CLTools_Executables | grep version"
CC_COMMAND="cc --version"
GCC_COMMAND="gcc --version"
CLANG_COMMAND="clang --version"
MAKE_COMMAND="make --version"
SCAN_BUILD_COMMAND="scan-build --help | grep checker-"
JAVA_COMMAND="java --version"
JAVAC_COMMAND="javac --version"
ANT_COMMAND="ant -version"
CLANG_FORMAT_COMMAND="clang-format -version"
PYTHON_COMMAND="python --version"
PYENV_COMMAND="pyenv --version"
NVM_COMMAND="nvm --version"
NODE_COMMAND="node --version"
RUBY_COMMAND="ruby --version"
RBENV_COMMAND="rbenv --version"
SVN_COMMAND="svn --version"
GIT_COMMAND="git --version"

#各バージョンチェックのフラグ
mac_flag=false
c_flag=false
java_flag=false
python_flag=false
js_flag=false
ruby_flag=false
scm_flag=false
help_flag=true;
separeter_flag=false;

#　それぞれの確認結果を表示する関数
print_result()
{
    target_string=$1
    your_version=$2
    aoki_version=$3
    if [ ${your_version} = ${aoki_version} ]
    then
        match_flag='o'
    else
        match_flag='x'
    fi
    printf "%30s" "${target_string}|"
    printf "%22s" "${your_version}|"
    printf "%22s" "${aoki_version}|"
    printf "%8s" "${match_flag}|"
    printf "\n"
}

# MacOSのバージョンチェック
os_checker()
{
    your_version=`${MACOS_VERSION_COMMAND} | grep 'ProductVersion:' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*'`
    aoki_version=`${CHECK_SOURCE} | tac | tac | grep 'ProductVersion:' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*' | head -1`
    print_result 'Mac OS X (macOS)' ${your_version} ${aoki_version}
}

# Xcodeのバージョンチェック
xcode_checker()
{
    your_version=`${XCODE_VERSION_COMMAND} | grep 'Xcode' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*'`
    aoki_version=`${CHECK_SOURCE} | tac | tac | grep 'Xcode [0-9]\+[.]\?' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*' | head -1`
    print_result 'Xcode' ${your_version} ${aoki_version}
}

# Command Line Tools for Xcodeのバージョンチェック
xcode_command_line_tool_checker()
{
    your_version=`${XCODE_COMMAND_LINE_TOOL_VERSION_COMMAND} | grep 'version:' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*[.]\?[0-9]*[.]\?[0-9]*[.]\?[0-9]*'`
    aoki_version=`${CHECK_SOURCE} | tac | tac | grep 'version: [0-9]\+[.]\?' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*[.]\?[0-9]*[.]\?[0-9]*[.]\?[0-9]*' | head -1`
    print_result 'Command Line Tools for Xcode' ${your_version} ${aoki_version}
}

# ccのバージョンチェック
cc_checker()
{
    your_version=`${CC_COMMAND} | grep 'Apple clang version' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*[.]\?[0-9]*' | head -1`
    aoki_version=`${CHECK_SOURCE} | tac | tac | grep 'Apple clang version [0-9]\+[.]\?' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*[.]\?[0-9]*' | head -1`
    print_result 'cc' ${your_version} ${aoki_version}
}

# gccのバージョンチェック
gcc_checker()
{
    your_version=`${GCC_COMMAND} | grep 'Apple clang version' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*[.]\?[0-9]*' | head -1`
    aoki_version=`${CHECK_SOURCE} | tac | tac | grep 'Apple clang version [0-9]\+[.]\?' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*[.]\?[0-9]*' | head -1`
    print_result 'gcc' ${your_version} ${aoki_version}
}

# clangのバージョンチェック
clang_checker()
{
    your_version=`${CLANG_COMMAND} | grep 'Apple clang version' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*[.]\?[0-9]*' | head -1`
    aoki_version=`${CHECK_SOURCE} | tac | tac | grep 'Apple clang version [0-9]\+[.]\?' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*[.]\?[0-9]*' | head -1`
    print_result 'clang' ${your_version} ${aoki_version}
}

# Makeのバージョンチェック
make_checker()
{
    your_version=`${MAKE_COMMAND} | grep 'GNU Make' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*'`
    aoki_version=`${CHECK_SOURCE} | tac | tac | grep 'GNU Make [0-9]\+[.]\?' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*' | head -1`
    print_result 'make' ${your_version} ${aoki_version}
}

# scan-buildのバージョンチェック
scan_build_checker()
{
    your_version=`${SCAN_BUILD_COMMAND} | grep 'ANALYZER BUILD:' | grep -o 'checker-[0-9]\+.[0-9]\+[.]\?[0-9]*'`
    aoki_version=`${CHECK_SOURCE} | tac | tac | grep 'ANALYZER BUILD: checker-[0-9]\+[.]\?' | grep -o 'checker-[0-9]\+.[0-9]\+[.]\?[0-9]*' | head -1`
    print_result 'scan-build' ${your_version} ${aoki_version}
}

# javaのバージョンチェック
java_checker()
{
    your_version=`${JAVA_COMMAND} | grep 'java' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*'| head -1`
    aoki_version=`${CHECK_SOURCE} | tac | tac | grep 'javac [0-9]\+[.]\?' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*' | head -1`
    print_result 'java' ${your_version} ${aoki_version}
}

# javacのバージョンチェック
javac_checker()
{
    your_version=`${JAVAC_COMMAND} | grep 'javac ' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*'| head -1`
    aoki_version=`${CHECK_SOURCE} | tac | tac | grep 'java version \"[0-9]\+[.]\?' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*' | head -1`
    print_result 'javac' ${your_version} ${aoki_version}
}

# Apache Antのバージョンチェック
ant_checker()
{
    your_version=`${ANT_COMMAND} | grep 'Apache Ant(TM) version ' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*'`
    aoki_version=`${CHECK_SOURCE} | tac | tac | grep 'Apache Ant(TM) version [0-9]\+[.]\?' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*' | head -1`
    print_result 'ant' ${your_version} ${aoki_version}
}

# clang-formatのバージョンチェック
clang_format_checker()
{
    your_version=`${CLANG_FORMAT_COMMAND} | grep 'clang-format version' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*'| head -1`
    aoki_version=`${CHECK_SOURCE} | tac | tac | grep 'clang-format version [0-9]\+[.]\?' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*' | head -1`
    print_result 'clang-format' ${your_version} ${aoki_version}
}

# Pythonのバージョンチェック
python_checker()
{
    your_version=`${PYTHON_COMMAND} | grep 'Python' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*'`
    aoki_version=`${CHECK_SOURCE} | tac | tac | grep 'Python [0-9]\+[.]\?' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*' | sort | tail -1`
    print_result 'python' ${your_version} ${aoki_version}
}

# pyenvのバージョンチェック
pyenv_checker()
{
    your_version=`${PYENV_COMMAND} | grep 'pyenv' | grep -o '[0-9]\+[.]\?[0-9]*[0-9a-z.\-]*'`
    aoki_version=`${CHECK_SOURCE} | tac | tac | grep 'pyenv [0-9]\+[.]\?' |  grep -o '[0-9]\+[.]\?[0-9]*[0-9a-z.\-]*' | head -1`
    print_result 'pyenv' ${your_version} ${aoki_version}
}

# NVMのバージョンチェック
nvm_checker()
{
    your_version=`${NVM_COMMAND} | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*'`
    aoki_version=`${CHECK_SOURCE} | tac | tac | grep -C 1 'nvm --version' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*' | tail -1`
    print_result 'nvm' ${your_version} ${aoki_version}
}

# Node.jsのバージョンチェック
node_checker()
{
    your_version=`${NODE_COMMAND} | grep -o 'v[0-9]\+[.]\?[0-9]*[.]\?[0-9]*'`
    aoki_version=`${CHECK_SOURCE} | tac | tac | grep -C 1 'node --version' | grep -o 'v[0-9]\+[.]\?[0-9]*[.]\?[0-9]*' | tail -1`
    print_result 'node' ${your_version} ${aoki_version}
}

# Rubyのバージョンチェック
ruby_checker()
{
    your_version=`${RUBY_COMMAND} | grep 'ruby ' | grep -o '[0-9p.]* (' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9p]*'`
    aoki_version=`${CHECK_SOURCE} | tac | tac | grep 'ruby [0-9]\+[.]\?' | grep -o '[0-9p.]* (' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9p]*' | tail -1`
    print_result 'ruby' ${your_version} ${aoki_version}
}

# rbenvのバージョンチェック
rbenv_checker()
{
    your_version=`${RBENV_COMMAND} | grep 'rbenv' | grep -o '[0-9]\+[.]\?[0-9]*[0-9a-z.\-]*'`
    aoki_version=`${CHECK_SOURCE} | tac | tac | grep 'rbenv [0-9]\+[.]\?' |  grep -o '[0-9]\+[.]\?[0-9]*[0-9a-z.\-]*' | head -1`
    print_result 'rbenv' ${your_version} ${aoki_version}
}

# SVNのバージョンチェック
svn_checker()
{
    your_version=`${SVN_COMMAND} | grep 'svn, version ' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*'| head -1`
    aoki_version=`${CHECK_SOURCE} | tac | tac | grep 'svn, version [0-9]\+[.]\?' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*' | head -1`
    print_result 'svn' ${your_version} ${aoki_version}
}

# Gitのバージョンチェック
git_checker()
{
    your_version=`${GIT_COMMAND} | grep 'git version' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*'| head -1`
    aoki_version=`${CHECK_SOURCE} | tac | tac | grep 'git version [0-9]\+[.]\?' | grep -o '[0-9]\+[.]\?[0-9]*[.]\?[0-9]*' | head -1`
    print_result 'git' ${your_version} ${aoki_version}
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
            js_flag=true; ruby_flag=true; scm_flag=true; separeter_flag=true; help_flag=false;;
        macos)
            mac_flag=true; separeter_flag=true; help_flag=false;;
        c)
            c_flag=true; separeter_flag=true; help_flag=false;;
        ja)
            java_flag=true; separeter_flag=true; help_flag=false;;
        js)
            js_flag=true; separeter_flag=true; help_flag=false;;
        py)
            python_flag=true; separeter_flag=true; help_flag=false;;
        rb)
            ruby_flag=true; separeter_flag=true; help_flag=false;;
        scm)
            scm_flag=true; separeter_flag=true; help_flag=false;;
        help)
            help_flag=true;;
        ?)
            help_flag=true;;
      esac ;;
    ?)
        help_flag=true;;
  esac
done

#各バージョンチェックのフラグ
if "${separeter_flag}"
then
    echo "                       Target|          YourVersion|          AokiVersion| Match?|"
    echo "=============================|=====================|=====================|=======|"
fi
if "${mac_flag}"; then os_checker ;xcode_checker ; xcode_command_line_tool_checker ; fi
if "${c_flag}"; then cc_checker ; gcc_checker ; clang_checker ; make_checker ; scan_build_checker ; clang_format_checker ; fi
if "${java_flag}"; then java_checker ; javac_checker ; ant_checker ; fi
if "${python_flag}" ; then python_checker ; pyenv_checker ;fi
if "${js_flag}"; then nvm_checker ; node_checker ; fi
if "${ruby_flag}"; then ruby_checker ; rbenv_checker ;fi
if "${scm_flag}"; then svn_checker ; git_checker ; fi
if "${help_flag}"; then helper ; fi
if "${separeter_flag}"
then
    echo "=============================|=====================|=====================|=======|"
fi
