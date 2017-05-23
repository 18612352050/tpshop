<?php
# +----------------------------------------------------------------
# | Thinker [ Thinkers Ideas also ]
# +----------------------------------------------------------------
# | Copyright (c) 2016 http://www.thinkerpr.com All right reserved
# +----------------------------------------------------------------
# | Author： KwongYanChan <chen.g.e@foxmail.com>
# +----------------------------------------------------------------
namespace Admin\Controller;

use Think\Db;
use OT\Database;

class DataBaseController extends AuthController{

	/**
	 * 数据库列表
	 */
	public function export(){

		$title = '';
		$list = array();
		$db = Db::getInstance();//连接数据库
		$list = $db->query( 'SHOW TABLE STATUS FROM '.C( 'DB_NAME' ) );//查询库返回所有表结构数据
		$list = array_map('array_change_key_case', $list);//将所有键转换成小写
		#过滤非本项目前缀的表
		#如果前缀匹配就返回整形0，如果返回是空，就不全等于整形，所以过滤掉其他表
		foreach( $list as $k=>$v ){
			if( stripos( $v['name'],strtolower( C( 'DB_PREFIX' ) ) ) !== 0 ){
				unset( $list[$k] );
			}
		}
		$this->title = "数据备份";
		$this->list = $list;
		actionLog( '查看数据库列表','数据库列表','export',$_SESSION['auth']['username'] );#行为记录
		$this->display( 'DataBase/export' );
	}

	/**
	 * 备份单表
	 * @param null $table
	 */
	public function exportsql( $table = null ) {
		if( $table ){
			if( stripos( $table,C( 'DB_PREFIX' ) ) == 0 ){
				#含前缀的表，去除表前缀
				$table = str_replace( C( 'DB_PREFIX' ),"",$table );
			}
			#db_is_valid_table_name：自定义函数，判断表是否存在
			if( !db_is_valid_table_name( $table ) ){
				$this->error( "不存在表:" . ' ' . $table);
			}
			actionLog( '下载单表完成','备份单表','exportsql',$_SESSION['auth']['username'] );#行为记录
			#保存单表
			#db_get_insert_sqls：自定义函数
			#force_download_content：自定义函数,强制下载
			force_download_content( date( 'Ymd' ) . '_' . C( 'DB_PREFIX' ) . $table . '.sql',db_get_insert_sqls( $table ) );
		}else{
			$this->error( '未指定需备份的表' );
		}
	}

	/**
     * 备份数据库
     * @param  String  $tables 表名
     * @param  Integer $id     表ID
     * @param  Integer $start  起始行数
     */
	public function backupSql( $tables = null, $id = null, $start = null ) {
		actionLog( '备份完成','备份数据库','backupSql',$_SESSION['auth']['username'] );#行为记录
		if ( IS_POST && !empty($tables) && is_array($tables) ) {
			$tables = $_POST['tables'];
			#读取必要的配分配置
			$config = array(
				'path'		=>	C( 'DB_PATH' ),#路径
				'part'		=>	C( 'DB_PART' ),#压缩分卷大小
				'compress'	=>	C( 'DB_COMPRESS' ),#是否启用压缩设置
				'level'		=>	C( 'DB_LEVEL' ),#压缩级别
			);
			#检查目录是否存在
			if ( !is_dir( $config['path'] ) ) {
				mkdir( $config['path'],0777,true );
			}
			#检查是否有任务运行
			$lock = "{$config['path']}backup.lock";
			if ( is_file( $lock ) ) {
				$this->error('检测到有一个备份任务正在执行，请稍后再试！');
			} else {
				#创建lock文件
				file_put_contents($lock, NOW_TIME);
			}
			#检查文件是否可以写，保存到缓存
			is_writable( $config['path'] ) || $this->error('检测到有一个备份任务正在执行，请稍后再试！');
			session( 'backup_config',$config );
			#生成备份文件信息
			$file = array(
				'name'		=>	date('Ymd-His'),
				'part'		=>	1,
			);
			session('backup_file', $file);
			#缓存要备份的表
            session('backup_tables', $tables);
			#创建备份文件
			$Database = new Database( $file,$config );
			if ( false !== $Database->create() ) {
				$tab = array( 'id'=>0,'start'=>0 );
				$this->success( '初始化成功！','',array( 'tables'=>$tables,'tab'=>$tab ) );
			} else {
				$this->error( '初始化失败，备份文件创造失败！',0,0 );
			}
		}elseif( IS_GET && is_numeric( $id ) && is_numeric( $start ) ) {
			$tables = session('backup_tables');
            #备份指定表
            $Database = new Database(session('backup_file'), session('backup_config'));
            $start  = $Database->backup($tables[$id], $start);
			#出错
            if (false === $start) {
                $this->error('备份出错！',0,0);

            } elseif (0 === $start) { #下一个表
                if(isset($tables[++$id])){
                    $tab = array('id' => $id, 'start' => 0);
                    $this->success('备份完成！', '', array('tab' => $tab));
                } else { #备份完成，清空缓存
                    unlink( session('backup_config.path') . 'backup.lock' );
                    session('backup_tables', null);
                    session('backup_file', null);
                    session('backup_config', null);
                    $this->success('备份完成！',1,1);
                }
            } else {
                $tab  = array('id' => $id, 'start' => $start[0]);
                $rate = floor(100 * ($start[0] / $start[1]));
                $this->success("正在备份...({$rate}%)", '', array('tab' => $tab));
            }
		}else{
			$this->error('参数错误！');
		}
	}

	/**
	 * 还原列表
	 */
	public function import() {
		actionLog( '查看还原列表','还原列表','import',$_SESSION['auth']['username'] );#行为记录
		#检查目录是否存在
		$path = C('DB_PATH');
		if ( !is_dir( $path ) ) {
			mkdir( $path,0777,true );
		}
		$glob = new \FilesystemIterator( $path,\FilesystemIterator::KEY_AS_FILENAME );#传入路径与方法
		$list = array();

		foreach( $glob as $name=>$file ) {
			#是否匹配文件名
			if ( preg_match( '/^\d{8,8}-\d{6,6}-\d+\.sql(?:\.gz)?$/',$name ) ) {
				$name = sscanf( $name,'%4s%2s%2s-%2s%2s%2s-%d' );#分成数组
				#组合日期，与时间
				$date = "{$name[0]}-{$name[1]}-{$name[2]}";
				$time = "{$name[3]}:{$name[4]}:{$name[5]}";
				#分卷
				$part = $name[6];
				if ( isset( $list["{$date} {$time}"] ) ) {
					$info = $list["{$date} {$time}"];
					$info['part'] = max( $info['part'],$part );
					$info['size'] = $info['size'] + $file->getSize();
				} else {
					$info['part'] = $part;
					$info['size'] = $file->getSize();
				}

				$extension = strtoupper( pathinfo( $file->getFilename(),PATHINFO_EXTENSION ) );#获取后缀名,压缩包的后缀名

				$info['compress'] = ( $extension === 'SQL' ) ? '-' : $extension;
				$info['time']     = strtotime("{$date} {$time}");#时间戳

				$list["{$date} {$time}"] = $info;
			}
		}
		$this->data_list = $list;
		$this->display();
	}

	/**
	 * 还原数据库
	 * @param int $time    保存的备份名：按时间记录
	 * @param null $part   备份的分卷
	 * @param null $start  数据开始的行数
	 */
	public function restoreSql( $time = 0, $part = null, $start = null )
	{
		#读取必要的配分配置
		$config = array(
			'path'     => realpath(C('DB_PATH')) . DIRECTORY_SEPARATOR,#具体地址，绝对路径
			#'path'		=>	C( 'DB_PATH' ),#路径
			'part'		=>	C( 'DB_PART' ),#压缩分卷大小
			'compress'	=>	C( 'DB_COMPRESS' ),#是否启用压缩设置
			'level'		=>	C( 'DB_LEVEL' ),#压缩级别
		);

//		dd( $config['path'] );
		#初始化备份的压缩包
		if ( is_numeric( $time ) && is_null( $part ) && is_null( $start ) ) {

			$name = date( "Ymd-His",$time) . '-*.sql*';#获得备份基础名
			$path  = realpath(C('DB_PATH')) . DIRECTORY_SEPARATOR . $name;#具体文件地址，绝对路径
			#$path = C( 'DB_PATH' ) . $name;#备份文件路径
			$files = glob( $path );#获取正确备份名字，数组
			$list = array();
			foreach( $files as $name ) {
				$basename 	= basename( $name );#获取备份名
				$match 		= sscanf( $basename,'%4s%2s%2s-%2s%2s%2s-%d' );#拆分成数组
				$gz 		= preg_match( '/^\d{8,8}-\d{6,6}-\d+\.sql.gz$/',$basename );#判断是否配备备份名
				$list[$match[6]] = array($match[6],$name,$gz);#分卷做键名，对应压入一个数组
			}
			ksort($list);#键名排序
			#检查文件正确性

			$last = end( $list );#指向最后一个单元
			if ( count( $list ) === $last[0] ) {
				session( 'backup_list',$list );#压入缓存
				$this->restoreSql( 0,1,0 );
			} else {
				$this->error('备份文件可能已经损坏，请检查！');
			}
		} elseif ( is_numeric($part) && is_numeric($start) ) {

			$list = session( 'backup_list' );#读取缓存
			$db = new Database( $list[$part],$config );#实例化
			$start = $db->import( $start );#开始还原

			#还原失败就报错
			if ( false === $start ) {
				$this->error( '还原数据出错！' );
			} elseif ( 0 === $start ) {#返回值相等， 就进入下一卷
				#检查是否有下一分卷存在
				if( isset( $list[++$part] ) ) {
					$this->restoreSql(0,$part,0);#继续还原
				} else {
					session('backup_list', null);#清空缓存
					actionLog( '还原数据库','还原数据库','restoreSql',$_SESSION['auth']['username'] );#行为记录
                    $this->success('还原完成！');
				}
			} else {
				$data = array( 'part'=>$part,'start'=>$start[0] );
				if ( $start[1] ) {
					$this->restoreSql(0,$part, $start[0]);
				} else {
					$data['gz'] = 1;
                    $this->restoreSql(0,$part, $start[0]);
				}
			}
		} else {
			$this->error('参数错误！');
		}
	}



	/**
	 * 删除备份方法
	 */
	public function delsql( $time = 0 )
	{
		if ( IS_POST && $time ) {
			#组合需要删除的备份名
			$name = date( "Ymd-His",$time ) . '-*.sql*';
			#组合路径
			$path = C( 'DB_PATH' ) . $name;
			#删除
			array_map( "unlink",glob( $path ) );
			#如果还存在，表示目录权限问题
			if ( count( glob( $path ) ) ) {
				actionLog( '备份文件删除失败，请检查权限','删除备份','delsql',$_SESSION['auth']['username'] );#行为记录
				$this->ajaxReturn( array( 'code'=>1,'msg'=>'备份文件删除失败，请检查权限！') );
			} else {
				$this->ajaxReturn(array( 'code'=>0,'msg'=>'备份文件删除成功！'));
			}
		} else {
			$this->ajaxReturn( array( 'code'=>1,'msg'=>'参数错误') );
		}
	}
}