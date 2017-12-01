#!/bin/sh

#/***************************************************************************
# * 
# * Copyright (c) 2012 Baidu.com, Inc. All Rights Reserved
# * 
# **************************************************************************/

#/**
# * @file install_patest.sh
# * @author yangguoqi@baidu.com
# * @date 2013/02/28 18:24:48
# * @version $Revision: 1.0 $ 
# * @brief installation script for PATest
# * @history 
# *     2015/05/15 wangweiyang01 updated
# *  
# **/

function help() {
echo "                                  PATest Installation Manual:                     "
echo "[1] -u"
echo "      update to newest version of release"
echo "[2] -i [PHP path] <PATest path>"
echo "       PHP path: Local php install directory,please input absolute path"
echo "       PATest path: Local patest install directory,please input absolute path"
echo "       If no PHP installed under the path specified,  a new one could be installed automatically."
echo "       All you need to do is to enter the PHP version wanted. PHP 5.2, 5.3 and 5.4 are support."
echo "[3] -d"
echo "      uninstall the patest"
echo "[4] -h"
echo "      help manual for script"
echo "[5] -e [PHP path] <PATest path>"
echo "       only set env, you must check out code by yourself "
echo "       PHP path: Local php install directory,please input absolute path"
echo "       PATest path: Local patest install directory,please input absolute path"
exit
}

TOOLS_SERVER="https://svn.baidu.com/opencode/tags/patest" 

PATEST="PATest"
PHP_VER="php-5.2.4"
PHP_SRC="$PHP_VER.tar.gz"

RUNKIT_SRC="runkit-1.0.2.tgz"
RUNKIT_PATH_NAME="runkit-1.0.2"

XDEBUG_SRC="xdebug_branch.tar.gz"
XDEBUG_PATH_NAME="xdebug"

down_load()
{
    download_patest $1
    if [ $? -ne 0 ];then
        echo "Download PATest Failed ..."
        return -1
    fi
}
download_patest()
{
    PATEST_PACK=${PATEST}"_"${VERSION}"_PD_BL"
    #svn co $TOOLS_SERVER/$PATEST_PACK/ $1
    svn co https://svn.baidu.com/opencode/trunk/patest $1
    return $?
}

update()
{
    rm -r download_tmp_path 2>/dev/null
    rm -r ftptmp.txt 2>/dev/null
    mkdir download_tmp_path
    get_newest_version
    PATEST_INSTALL_PATH=$PATEST_HOME
    echo "Starting Update PATest in $PATEST_INSTALL_PATH"
    echo "The Newest PATEST is $VERSION"
    down_load download_tmp_path
    if [ $? -eq 0 ]
    then
        find ./download_tmp_path -name .svn | xargs rm -rf
        if [ -f $PATEST_INSTALL_PATH/version ]; then
            rm -rf $PATEST_INSTALL_PATH/version 2> /dev/null
        fi
        cp -rf download_tmp_path/Framework $PATEST_INSTALL_PATH/
        cp -rf download_tmp_path/Tools $PATEST_INSTALL_PATH/
        cp -rf download_tmp_path/install_patest.sh $PATEST_INSTALL_PATH/
        cp -rf download_tmp_path/version $PATEST_INSTALL_PATH/
        cp -rf download_tmp_path/Bin/patest.sample $PATEST_INSTALL_PATH/Bin/
        ret=0
    else
        ret=$?
    fi
    rm -rf download_tmp_path 2>/dev/null
    return $ret
}
#get the newest version url
get_newest_version()
{
    if [ -f version ]; then
        rm version
    fi
    svn export https://svn.baidu.com/opencode/trunk/patest/version
    #svn co --depth=empty 'https://svn.baidu.com/opencode/trunk/patest/' version_tmp_dir
    #svn up version_tmp_dir/version
    VERSION=`cat version` 2>/dev/null
    rm -rf version
}

#install the patest
install()
{
    rm -rf download_tmp_path 2>/dev/null
    mkdir download_tmp_path
    if [ $# -eq 0 ]
    then
        get_newest_version
    fi
    echo "Install PATest $VERSION ..."
    down_load download_tmp_path

    if [ $? -eq 0 ]
    then
        find ./download_tmp_path -name .svn | xargs rm -rf  
        mv  download_tmp_path $INSTALL_PATH/$PATEST
        #for common
        INSTALL_PATH=$INSTALL_PATH/$PATEST
        ret=$?
    else
        ret=$?
    fi
    #rm -rf download_tmp_path
    return $ret
}


set_env()
{
    if [ ${1}"e" != "e" ] ; then
        INSTALL_PATH=$1
        PHP_PATH=$2
    fi

    #Always set env
    #### shi,xiaoqiang,版本一致的话，就不用再设置环境
    #    	newest_version=`cat $INSTALL_PATH/version | sed 's/-//g'`
    #	    if [ -f ~/.patest.version ];then    
    #		    cur_version=`cat ~/.patest.version | sed 's/-//g'`
    #    		if [ $cur_version"a" != "a" ];then
    #			    if [  $cur_version"a" == $newest_version"a" ];then
    #				    return
    #			    fi
    #		    fi
    #	    fi
    #	    cp -f $INSTALL_PATH/version ~/.patest.version
    #####################################################

    filename="bash_profile_bak_`date +%s`"
    cp ~/.bash_profile $filename
    echo "Copy .bash_profile To Current Path, Named $filename ..."
    echo "#--------------- patest env -----------------" >> ~/.bash_profile
    echo "export PATEST_HOME=$INSTALL_PATH #patest" >> ~/.bash_profile
    echo "alias patest=$INSTALL_PATH/Bin/patest" >> ~/.bash_profile
    echo "export PATEST_PHP_HOME=$PHP_PATH #patest" >> ~/.bash_profile
    #php_ini_dir=`find $PHP_PATH -name "php.ini"`
    #php_ini_dir=`echo $php_ini_dir | sed 's/ *$//g'|sed 's/^ *//g'`
    #php_ini_dir="$PHP_PATH/lib/php.ini"
    php_ini_dir=`$PHP_PATH/bin/php --info | grep 'Loaded Configuration File => '| head -1|sed 's/Loaded Configuration File => //'`
    if [ ! -f $php_ini_dir ];then
        php_ini_dir=`$PHP_PATH/bin/php --info | grep 'php_ini_dir => '| head -1|sed 's/php_ini_dir => //'`
        if [ ! -f $php_ini_dir ];then
            php_ini_dir=`$PHP_PATH/bin/php --info | grep '_SERVER\["php_ini_dir"\] => '| head -1|sed 's/_SERVER\["php_ini_dir"\] => //'`
            if [ "$php_ini_dir" == "(none)" ]; then
                local default_php_ini_file=$PHP_PATH/lib/php.ini
                if [ -f $default_php_ini_file ]; then
                    echo "The php configration file is none. Try to use default ini file $default_php_ini_file"
                    php_ini_dir=$default_php_ini_file
                fi
            fi
            if [ ! -f $php_ini_dir ];then
                echo "[err] Your php.ini File Not in Regular Path !"
                exit
            fi
        fi
    fi
    php_ini_path=`dirname $php_ini_dir`	
    cp $php_ini_dir $php_ini_path/php.ini_bak
    echo "export php_ini_dir=$php_ini_dir #patest" >> ~/.bash_profile 

    #echo "auto_prepend_file=$INSTALL_PATH/Tools/Coverage/pend/prepend.php" >> $php_ini_dir
    #sed "501 aauto_append_file = $INSTALL_PATH/Tools/Coverage/pend/prepend.php" -i $php_ini_dir
    sed -i "s/^auto_prepend_file/;auto_prepend_file/g" $php_ini_dir
    sed "501 aauto_prepend_file = $INSTALL_PATH/Tools/Coverage/pend/prepend.php" -i $php_ini_dir


    #extension_dir=`cat $php_ini_dir | awk -F"=" '{gsub(/"/,"",$2);if(index($1,"extension_dir")>=1) print $2}'`
    #extension_dir=`cat $php_ini_dir | awk -F"=" '{if(index($0,";")!=1){gsub(/"/,"",$2);if(index($1,"extension_dir")>=1) print $2}}'`
    #extension_dir=`echo $extension_dir | sed 's/ *$//g'|sed 's/^ *//g'`
    extension_dir=`$PHP_PATH/bin/php --info | grep 'extension_dir => '| head -1|sed 's/extension_dir => //' | sed 's/\s*=>.*//'`
    ext_defaut_dir=$PHP_PATH"/lib/php/extensions/no-debug-non-zts-20090626"

    if [ $extension_dir"a" == "a" ] || [ $extension_dir"a" == "./a" ];then
        extension_dir=`$PHP_PATH/bin/php --info | grep '_SERVER\["extension_dir"\] => '| head -1|sed 's/_SERVER\["extension_dir"\] => //'`
        #if [ $extension_dir"a" == "a" ];then
        if [ $extension_dir"a" == "a" ] || [ $extension_dir"a"=="a.\/" ];then
            if [ -d $ext_defaut_dir ];then
                extension_dir=$ext_defaut_dir
            else
                echo "Sorry,can not find php-extension-dir!"
                #unset_env
                exit
            fi
        fi
    fi
    echo "export extension_dir=$extension_dir #patest" >> ~/.bash_profile

    #install runkit
    echo "Checking runkit ..."
    RET=`${PHP_PATH}/bin/php -m | grep runkit`
    if [ ${RET}'a' == 'a' ]; then
        #install_runkit
        fetch_php_version	
        if [ "$CUR_PHP_VERSION" -gt "53" ]; then
            RUNKIT_SRC="pecl-php-runkit.tgz"
            RUNKIT_PATH_NAME="pecl-php-runkit"
        fi
        install_expand "runkit" $RUNKIT_SRC  $RUNKIT_PATH_NAME
    fi

    #install xdebug 
    echo "Checking xdebug ..."
    RET=`${PHP_PATH}/bin/php -m | grep xdebug`
    if [ ${RET}'a' != "a" ]; then
        #install_xdebug
        xdebug_opt=`cat $php_ini_dir | awk -F"=" '{if(index($0,";")!=1){gsub(/"/,"",$2);if(index($2,"xdebug.so")>=1) print $1,$2}}'`
        xdebug_opt=`echo $xdebug_opt | sed 's/ *$//g'|sed 's/^ *//g'`
        xdebug_opt_name=`echo $xdebug_opt | awk -F' ' '{print $1}'`
        xdebug_dir=`echo $xdebug_opt | awk -F' ' '{print $2}'`
        if [ ! -f $xdebug_dir ];then
            xdebug_dir=$extension_dir/xdebug.so
        fi
        xdebug_path=`dirname $xdebug_dir`
        mv $xdebug_dir $xdebug_path/xdebug.so_bak 2>/dev/null
        #sed -i "s/^$xdebug_opt_name.*xdebug.so"'$'"/;$xdebug_opt_name=$xdebug_dir/g" $php_ini_dir
        #sed -i "s/^xdebug\./;xdebug\./g" $php_ini_dir
        has_configed="true"
    fi

    # wangweiyang01:install different xdebug version according to php version
    fetch_php_version	
    if [ "$CUR_PHP_VERSION" -gt "53" ]; then
        # php 5.3 or above
        XDEBUG_SRC="xdebug_2_3.tar.gz"
    fi
    install_expand "xdebug" $XDEBUG_SRC  $XDEBUG_PATH_NAME $has_configed



    # $INSTALL_PATH/Bin/patest.simple $INSTALL_PATH/Bin/patest_
    # touch $INSTALL_PATH/Bin/patest
    echo "#!${PHP_PATH}/bin/php" > $INSTALL_PATH/Bin/patest
    cat $INSTALL_PATH/Bin/patest.sample >> $INSTALL_PATH/Bin/patest
    chmod +x $INSTALL_PATH/Bin/patest

    echo "#################################################"
    echo "#"
    echo "#Next You Must Execute Cmd: source ~/.bash_profile"
    echo "#"
    echo "#################################################"
}

fetch_php_version()
{
    CUR_PHP_VERSION=`${PHP_PATH}/bin/php -r "echo phpversion();"`
    CUR_PHP_VERSION=${CUR_PHP_VERSION//./}
    if [[ $CUR_PHP_VERSION == 53* ]]; then
        CUR_PHP_VERSION="53"
    elif [[ $CUR_PHP_VERSION == 54* ]]; then
        CUR_PHP_VERSION="54"
    else
        CUR_PHP_VERSION="52"
    fi
}

install_expand()
{
    expand_name=$1
    src_pack_name=$2
    src_path_name=$3
    has_configed=$4
    echo "Start Install ${expand_name} ..."
    cd $INSTALL_PATH/Tools/
    tar zxvf ${src_pack_name} 1>/dev/null 2>&1
    if [ $? != 0 ]; then
        echo "Uncompressing ${expand_name} Packet  Fail....[Warning]"
        #exit -1
    else
        echo "Uncompressing  ${expand_name} Packet Finish !"
        EXTEND_DIR=${src_path_name}
        PHP_BIN=$PHP_PATH/bin
        if [ -d ${EXTEND_DIR} ]; then
            cd ${EXTEND_DIR}
            make clean 1>/dev/null 2>&1
            ${PHP_BIN}/phpize 1>/dev/null 2>&1
            if [ $? != 0 ]; then
                echo "PHPize Fail !"
                exit;
            fi
            echo "PHPize For ${expand_name} Finish !"
            ./configure --with-php-config=$PHP_BIN/php-config  1>/dev/null 2>&1
            if [ $? != 0 ]; then
                echo "Configure For ${expand_name}  Fail !"
                exit;
            fi  
            echo "Configure For ${expand_name}  Finish !"
            make -j 4 1>/dev/null 2>&1
            if [ $? != 0 ]; then
                echo "Make For ${expand_name}  Fail !"
                exit;
            fi  
            echo "Make For ${expand_name} Finish !"
            make install 1>/dev/null 2>&1
            if [ $? != 0 ]; then
                echo "Make Install ${expand_name}  Fail !"
                exit;
            fi
            echo "Make Install For ${expand_name} Finish !"

            so_name=${expand_name}".so"
            fetch_php_version	
            if [ "$CUR_PHP_VERSION" -gt "52" ]; then
                mv $PHP_PATH/lib/php/extensions/no-debug-non-zts-20100525/$so_name $extension_dir 2>/dev/null
            else
                mv $PHP_PATH/lib/php/extensions/no-debug-non-zts-20060613/$so_name $extension_dir 2>/dev/null
            fi
            if [ -f ${php_ini_dir} ]; then
                if [ $has_configed"a"  == "a" ];then
                    echo "extension=$so_name" >> $php_ini_dir
                fi
            else
                echo "Your php.ini File Is Not In $php_ini_dir" 
                exit;
            fi
            
            # xdebug must be loaded as a zend extension
            local replace_extension_dir=$extension_dir
            replace_extension_dir=${replace_extension_dir//\//\\/}
            sed -i "s/extension=xdebug.so/zend_extension=$replace_extension_dir\/xdebug.so/g" $php_ini_dir
            # set up default time zone
            sed -i "s/;date.timezone =/date.timezone = PRC/g" $php_ini_dir

            RET=`${PHP_BIN}/php -m | grep ${expand_name}`
            echo "Checking ${expand_name} ..."
            if [ ${RET}"a" == ${expand_name}"a" ]; then
                echo "Install ${expand_name} Finish !"
            else
                echo "Install ${expand_name} Fail, Please Check Local PHP !"
                exit
            fi
        else
            echo "Sorry, Install ${expand_name} Exception ! "
            exit
        fi
    fi
}

unset_env()
{
    echo "Start To Delete PATest Source ..."
    if [ ${PATEST_HOME}"e" == "e" ]; then
        echo "Delete PATest Fail!"
    fi
    rm -rf $PATEST_HOME

    echo "Unset .bash_profile ..."
    #cp ~/.bash_profile ~/.bash_profile.`date +%s`
    sed '/patest/'d ~/.bash_profile >~/.bash_profile.new
    mv ~/.bash_profile.new ~/.bash_profile

    echo "Delete PHP Extendsion ..."
    if [ "${php_ini_dir}a" == "a" ];then
        echo "Your php.ini path is null"
        exit
    fi
    if [ -f $php_ini_dir ];then
        sed '/runkit.so/'d $php_ini_dir > $PATEST_PHP_HOME/lib/php.ini.new
        mv $PATEST_PHP_HOME/lib/php.ini.new $php_ini_dir

        sed '/xdebug.so/'d $php_ini_dir > $PATEST_PHP_HOME/lib/php.ini.new
        mv $PATEST_PHP_HOME/lib/php.ini.new $php_ini_dir
    else
        echo "Your php.ini not found in ${php_ini_dir}"
        exit 
    fi
    #rm -rf $PATEST_PHP_HOME/lib/php/extensions/no-debug-non-zts-20060613/runkit.so
    rm -rf $extension_dir/runkit.so
    echo "Unset Env Finish !"
}

download_php()
{
    echo "Start To Download PHP Source ..."
    wget "$TOOLS_SERVER"/$PHP_SRC 2>/dev/null
    if [ $? -ne 0 ];then
        echo "Download PHP Source Failed !"
        exit
    fi
    echo "Download PHP Source Finish !"
}

install_php()
{
    echo "Do You Need Install PHP ?"
    echo "Please Choose [YES] Or [NO]"
    read bol
    ret=0
    if [ $bol == "yes" -o $bol == "YES" ]; then
        echo "Plese Input PHP Install Path: "
        read path	
        if [ ! -d $path ];then
            echo "Install PHP Path Is Not Exist !"
            exit
        fi
        echo "Please Choose PHP Version [5.4],[5.3] Or [5.2]"
        read phpVersion
        if [ $phpVersion == "5.2" ]; then
            exit
            install_php52 $path
        elif [ $phpVersion == "5.3" ]; then
            install_php53 $path
        elif [ $phpVersion == "5.4" ]; then
            install_php54 $path
        else
            echo "Wrong php version"
            exit
        fi 
        echo "*************** PHP INO ***************"
        echo 
        $PHP_PATH/bin/php -v
        echo 
        echo "***************************************"
        if [ $? -ne 0 ];then
            echo "Test PHP Fail !"
            exit
        fi
        path=$PHP_PATH
        echo "Install PHP Finish !"
    fi 
}

install_php52()
{
    echo "Start to install php 5.2 ..."
    PHP_PATH=$1
    if [ ${PHP_PATH##*/}"x" != "phpx" ];then
        PHP_PATH=$PHP_PATH"/php"
        if [ ! -d $PHP_PATH ];then
            mkdir $PHP_PATH
        fi  
    fi

    : '
    #declare -r TOOLS_PATH=$(cd `dirname $0`;pwd)"/Tools"
    cd $TOOLS_PATH
    svn export https://svn.baidu.com/opencode/trunk/patest/Tools/libiconv-1.13.1.tar.gz --force
    declare -r local TOOLS_PATH=$PHP_PATH
    #install iconv
    mkdir -p ICONV_PATH=$PHP_PATH"/libiconv"
    tar -zxvf libiconv-1.13.1.tar.gz
    cd libiconv-1.13.1
    ./configure --prefix=$ICONV_PATH
    make
    make install
    exit 
    rm -rf libiconv-1.13.1
    rm -rf libiconv-1.13.1.tar.gz
    '

    cd $TOOLS_PATH
    svn export https://svn.baidu.com/opencode/trunk/patest/Tools/php-5.2.17.tar.bz2 --force
    tar jxf php-5.2.17.tar.bz2
    cd php-5.2.17
    chmod 777 configure
    ./configure --prefix=$PHP_PATH --with-config-file-path=$PHP_PATH"/lib" --with-curl --enable-soap --enable-mbstring --enable-sockets #--with-iconv=$ICONV_PATH
    make
    make install
    declare -r PHP_EXTENSION_DIR=$PHP_PATH"/lib/php/extensions/no-debug-non-zts-20090626"
    PHP_EXTENSION_DIR_TEMP=${PHP_EXTENSION_DIR//\//\\/}
    sed -i "s/extension_dir\s*=.*/extension_dir=$PHP_EXTENSION_DIR_TEMP/g" php.ini-dist
    sed -i "s/extension=xdebug.so/zend_extension=xdebug.so/g" php.ini-dist
    cp php.ini-dist $PHP_PATH/lib/php.ini
    rm -rf php-5.2.17
    rm -rf php-5.2.17.tar.bz2

    if [ ! -d $PHP_EXTENSION_DIR ];then
        mkdir -p $PHP_EXTENSION_DIR
    fi
}

install_php53()
{
    echo "Start to install php 5.3 ..."
    PHP_PATH=$1
    if [ ${PHP_PATH##*/}"x" != "phpx" ];then
        PHP_PATH=$PHP_PATH"/php"
        if [ ! -d $PHP_PATH ];then
            mkdir $PHP_PATH
        fi  
    fi

    cd $TOOLS_PATH
    svn export https://svn.baidu.com/opencode/trunk/patest/Tools/php-5.3.10.tar.bz2 --force
    tar jxf php-5.3.10.tar.bz2
    cd php-5.3.10
    chmod 777 configure
    ./configure --prefix=$PHP_PATH --enable-fpm --enable-fastcgi --enable-bcmath --enable-gd-native-ttf --enable-mbstring --enable-shmop --enable-soap --enable-sockets --enable-exif --enable-ftp --enable-sysvsem --enable-pcntl --enable-wddx --enable-zip --with-gd --with-pear --with-curlwrappers --with-iconv --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-jpeg-dir --with-freetype-dir
    make
    make install
    declare -r PHP_EXTENSION_DIR=$PHP_PATH"/lib/php/extensions/no-debug-non-zts-20090626"
    if [ ! -d $PHP_EXTENSION_DIR ]; then
        mkdir -p $PHP_EXTENSION_DIR
    fi
    PHP_EXTENSION_DIR_TEMP=${PHP_EXTENSION_DIR//\//\\/}
    sed -i "s/; extension_dir\s*=.*ext.*/extension_dir=$PHP_EXTENSION_DIR_TEMP/g" php.ini-development
    cp php.ini-development $PHP_PATH/lib/php.ini
    rm -rf php-5.3.10
    rm -rf php-5.3.10.tar.bz2

}

install_php54()
{
    local CUR_PHP_VER="php-5.4.41"
    echo "Start to install php 5.4 ..."
    PHP_PATH=$1
    if [ ${PHP_PATH##*/}"x" != "phpx" ];then
        PHP_PATH=$PHP_PATH"/php"
        if [ ! -d $PHP_PATH ];then
            mkdir $PHP_PATH
        fi  
    fi

    cd $TOOLS_PATH
    svn export https://svn.baidu.com/opencode/trunk/patest/Tools/php-5.4.41.tar.gz --force
    tar zxf php-5.4.41.tar.gz
    cd $CUR_PHP_VER
    chmod 777 configure

    ./configure \
    --prefix=$PHP_PATH \
    --enable-fpm \
    --enable-bcmath \
    --enable-gd-native-ttf \
    --enable-mbstring \
    --enable-shmop \
    --enable-soap \
    --enable-sockets \
    --enable-exif \
    --enable-ftp \
    --enable-sysvsem \
    --enable-pcntl \
    --enable-wddx \
    --enable-zip \
    --with-gd \
    --without-pear \
    --with-iconv \
    --with-mysql=mysqlnd \
    --with-mysqli=mysqlnd \
    --with-pdo-mysql=mysqlnd \
    --with-freetype-dir \

    make
    make install
    declare -r PHP_EXTENSION_DIR=$PHP_PATH"/lib/php/extensions/no-debug-non-zts-20100525"
    if [ ! -d $PHP_EXTENSION_DIR ]; then
        mkdir -p $PHP_EXTENSION_DIR
    fi
    PHP_EXTENSION_DIR_TEMP=${PHP_EXTENSION_DIR//\//\\/}
    sed -i "s/; extension_dir\s*=.*ext.*/extension_dir=$PHP_EXTENSION_DIR_TEMP/g" php.ini-development
    cp php.ini-development $PHP_PATH/lib/php.ini
    rm -rf $CUR_PHP_VER
    rm -rf php-5.4.41.tar.gz

}

if [ $# -eq 0 ]
then
    echo "Please Input Parameter For Script!"
    echo ""
    help

elif [ $# -eq 1 ]
then
    if [ $1 = "-u" ]
    then
        #to update to the newest version of release
        echo "Start Update To Newest Version Of PATest ..."
        update
        if [ $? -eq 0 ]
        then
            echo "Update PATest Finish !"
        else
            echo "Update PATest Fail !"
        fi
    elif [ $1 = "-d" ];then
        echo "Start To Uninstall PATest ..."
        unset_env
        source ~/.bash_profile
    elif [ $1 = "-h" ] ; then
        help
    else
        echo "Argument Error !"
        help
    fi
elif [ $# -eq 2 ]
then
    if [ $1 = "-i" ]
    then
        if [ ! -d $2 -o ! -f "$2/bin/php" ]; then
            echo "Your Input PHP Path Is Not Exist !"
            install_php
        fi
        if [ $path"e" != "e" ]; then
            PHP_PATH=$path
        else
            PHP_PATH=$2
        fi
        echo "Start Install PATest ..."
        cd `dirname $0;`
        INSTALL_PATH=`pwd`
        echo $INSTALL_PATH | grep "./" | grep "home" 2>/dev/null 1>&2
        jud1=$?
        echo $PHP_PATH | grep "./" | grep "home" 2>/dev/null 1>&2
        jud2=$?
        if [ $jud1 -ne 0 -o $jud2 -ne 0 ];then
            echo "Please Input Absolute Path !"
            help
        fi
        mkdir -p $INSTALL_PATH
        echo "Install Path is $INSTALL_PATH"
        install
        if [ $? -eq 0 ]
        then 
            echo "Install PATest Finish !"
            echo "Start To Set Env For PATest ..."
            set_env 
            echo "Set Env Finish !"	
        else
            echo "Install PATest FAIL !"
        fi	
    elif [ $1 = "-e" ]; then
        echo "Start Only Set Env......" 
        cd `dirname $0;`
        patest_path=`pwd`
        set_env  ${patest_path} $2
        echo "Start Only Set Env Success!"

    fi

elif [ $# -eq 3 ]
then
    if [ $1 = "-i" ]
    then
        if [ ! -d $2 -o ! -f "$2/bin/php" ]; then
            echo "Your Input PHP Path Is Not Exist !"
            install_php
        fi
        if [ $path"e" != "e" ]; then
            PHP_PATH=$path
        else
            PHP_PATH=$2
        fi
        echo "Start Install PATest ..."
        INSTALL_PATH=$3
        echo $INSTALL_PATH | grep "./" | grep "home" 2>/dev/null 1>&2
        jud1=$?
        echo $PHP_PATH | grep "./" | grep "home" 2>/dev/null 1>&2
        jud2=$?
        if [ $jud1 -ne 0 -o $jud2 -ne 0 ];then
            echo "Please Input Absolute Path !"
            help
        fi
        mkdir -p $INSTALL_PATH
        echo "Install Path is $INSTALL_PATH"
        install
        if [ $? -eq 0 ]
        then 
            echo "Install PATest Finish !"
            echo "Start To Set Env For PATest ..."
            set_env 
            echo "Set Env Finish !"	
        else
            echo "Install PATest FAIL !"
        fi	
    elif [ $1 = "-e" ] ; then
        echo "Start Only Set Env......" 
        set_env  $3 $2
        echo "Start Only Set Env Success!"
    else
        echo "Argument Error!"
        help
    fi

else
    echo "Argument Error!"
    help
fi

