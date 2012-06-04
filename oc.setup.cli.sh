#!/bin/bash

PRJ_DIR=$(pwd);
frame_ver=(0.7 0.8);
frame_dir=(0.7.2.0 0.8.0.0);
pla_ver=(0.3 0.4);
pla_dir=(0.3.2.0 0.4.0.0);

echo "开始在 $PRJ_DIR 下安装蜂巢";

echo "  1.安装 oc.loader";
git clone git@github.com:OpenComb/oc.loader.git $PRJ_DIR

echo "  2.安装VFS";
mkdir -p $PRJ_DIR/vfs
git clone git@github.com:JeCat/framework-vfs.git $PRJ_DIR/vfs

echo "  3.安装framework";
cd $PRJ_DIR
mkdir -p $PRJ_DIR/framework
for (( i = 0; i < ${#frame_ver[@]}; i++ )); do
    mkdir -p $PRJ_DIR/framework/${frame_dir[$i]}
    git clone git@github.com:JeCat/framework.git $PRJ_DIR/framework/${frame_dir[$i]}
    cd $PRJ_DIR/framework/${frame_dir[$i]}
    git checkout ${frame_ver[$i]}
done

echo "  4.安装platform";
cd $PRJ_DIR
mkdir -p $PRJ_DIR/platform
for (( i = 0; i < ${#pla_ver[@]}; i++ )); do
    mkdir -p $PRJ_DIR/platform/${pla_dir[$i]}
    git clone git@github.com:OpenComb/oc.release.git $PRJ_DIR/platform/${pla_dir[$i]}
    cd $PRJ_DIR/platform/${pla_dir[$i]}
    git checkout ${pla_ver[$i]}
done

echo "  4.安装extensions";
cd $PRJ_DIR
mkdir -p $PRJ_DIR/extensions/coresystem/0.1
git clone git@github.com:OpenComb/extensions-coresystem.git $PRJ_DIR/extensions/coresystem/0.1

echo "  5.安装配置目录";
mkdir -p $PRJ_DIR/services/default/data
mkdir -p $PRJ_DIR/services/default/setting/service/db/default

echo "<?php return array (
  'default' => 
  array (
    'domains' => 
    array (
      0 => '*',
    ),
  ),
);" >> $PRJ_DIR/services/settings.php;

echo "<?php
return array (
  'config' => 'default',
) ;" >> $PRJ_DIR/services/default/setting/service/db/items.php;

read -p "    请输入数据库地址，回车默认是[127.0.0.1]: " dbserver
if [ "$dbserver" == "" ]; then
    dbserver="127.0.0.1"
fi
read -p "    请输入数据库名称，回车默认是[oc]: " dbname
if [ "$dbname" == "" ]; then
    dbname="oc"
fi
read -p "    请输入数据库用户名，回车默认是[root]: " dbuser
if [ "$dbuser" == "" ]; then
    dbuser="root"
fi
read -p "    请输入数据库密码，回车默认是[1]: " dbpassword
if [ "$dbpassword" == "" ]; then
    dbpassword="1"
fi
read -p "    请输入数据库表前缀，回车默认是[oc_]: " dbtableprefix
if [ "$dbtableprefix" == "" ]; then
    dbtableprefix="oc_"
fi

echo "<?php
return array (
  'dsn' => 'mysql:host=$dbserver;dbname=$dbname',
  'username' => '$dbuser',
  'password' => '$dbpassword',
  'options' => 
  array (
    1002 => 'SET NAMES \'utf8\'',
    'table_prefix' => '$dbtableprefix' ,
  ),
) ;" >> $PRJ_DIR/services/default/setting/service/db/default/items.php;
