<?php
# +----------------------------------------------------------------
# | Thinker [ Thinkers Ideas also ]
# +----------------------------------------------------------------
# | Copyright (c) 2016 http://www.thinkerpr.com All right reserved
# +----------------------------------------------------------------
# | Author： KwongYanChan <chen.g.e@foxmail.com>
# +----------------------------------------------------------------
use Think\Db;
use Think\Storage;
use OT\File;
/**
 * [dd 打印方法]
 * @param  [type] $arr [变量]
 * @return [type]      [打印结果]
 */
function dd($arr){
    return var_dump( $arr );
}

/**
 * @param string $order
 * @param $table 实例化的表
 * @param $condition 要抽取的条件
 * @param int $page 设置要份多少页
 * @param string $order 设置条件
 * @param string $prefix 表前缀
 * @return array 返回的数组
 */
function dataPage( $table, $condition, $page=15, $order='',$setconfig=array(), $prefix='')
{
    $obj = M($table, $prefix);
    $count = $obj->where( $condition  )->count();
    $show = new \Think\Page( $count, $page );
	if( empty( $setconfig ) ){
		$show->setConfig( 'prev','上一页' );
		$show->setConfig( 'next','下一页' );
	}else{
		$show->setConfig( 'prev',$setconfig['prev'] );
		$show->setConfig( 'next',$setconfig['next'] );
	}

    if( !empty( $order ) ){
        $list = $obj->where( $condition )->limit( $show->firstRow.','.$show->listRows )->order( $order )->select();
    }else{
        $list = $obj->where( $condition )->limit( $show->firstRow.','.$show->listRows )->select();
    }
    $p = $show->show();
    return array( 'list'=>$list, 'page'=>$p );
}

/**
 * 后台通知到货调用短信接口
 * @param $message
 * @param $phone
 * @return mixed
 */
function get_ssl_content( $message,$phone ) {
    $url=  C( 'msgAction' ) . C( 'sendMsgAction' )."account=".C( 'msgUsername' )."&password=".C( 'msgPassword' )."&content=".$message."&sendTime=&removeDuplicate=0&phoneNums=".$phone;
    $ch = curl_init ();
    curl_setopt ( $ch, CURLOPT_URL, $url );
    curl_setopt ( $ch, CURLOPT_RETURNTRANSFER, true );
    curl_setopt ( $ch, CURLOPT_SSL_VERIFYPEER, false );
    curl_setopt ( $ch, CURLOPT_SSL_VERIFYHOST, false );
    $result = curl_exec ( $ch );
    return $result;
}

function sendMail($to, $content){
    //创建对象
    $mail=new \Org\Util\PHPMailer();// liximing2011@gmail.com
    $mail->CharSet = "utf-8";  //设置采用utf8中文编码
    $mail->IsSMTP();  //设置采用SMTP方式发送邮件
	//设置使用ssl加密方式登录鉴权
	if( C('is_ssl')==1 ){
		$mail->SMTPSecure = 'ssl';
	}
	$mail->Host = C('smtp_address');   //设置邮件服务器的地址
	$mail->Port = C('port');   //设置邮件服务器的端口，默认为25  如果是gmail,qq的话是465
	$mail->From = C('e_address');  //设置发件人的邮箱地址
	$mail->FromName = "星客公关"; //设置发件人的姓名
	$mail->SMTPAuth = true; //设置SMTP是否需要密码验证，true表示需要
	$mail->Username = C('e_address');//账号
	$mail->Password = C('e_password');//密码xyneumdflandcafa
	$mail->Subject = C('e_name');//设置邮件的标题
    $mail->AltBody = "textml"; // optional, comment out and test
    $mail->Body = $content;
    $mail->IsHTML(true);            //设置内容是否为html类型
    $mail->addAddress(trim($to), $name='');     //设置收件的地址
    if (!$mail->Send()) {                    //发送邮件
//        echo '发送失败:'.$mail->ErrorInfo;
        return false;
    } else {
//        echo 1;
        return true;
    }
}

/**
*
 * 测试邮箱
 */
function sendMailTest($to){
	//创建对象
	$mail=new \Org\Util\PHPMailer();// liximing2011@gmail.com
//	$mail->SMTPDebug = 1;//是否启用smtp的debug进行调试 开发环境建议开启 生产环境注释掉即可 默认关闭debug调试模式
	$mail->CharSet = "utf-8";  //设置采用utf8中文编码
	$mail->IsSMTP();  //设置采用SMTP方式发送邮件
	//设置使用ssl加密方式登录鉴权
	if( C('is_ssl')==1 ){
		$mail->SMTPSecure = 'ssl';
	}
	$mail->Host = C('smtp_address');   //设置邮件服务器的地址
	$mail->Port = C('port');   //设置邮件服务器的端口，默认为25  如果是gmail,qq的话是465
	$mail->From = C('e_address');  //设置发件人的邮箱地址
	$mail->FromName = "星客公关"; //设置发件人的姓名
	$mail->SMTPAuth = true; //设置SMTP是否需要密码验证，true表示需要
	$mail->Username = C('e_address');//账号
	$mail->Password = C('e_password');//密码xyneumdflandcafa
	$mail->Subject = C('e_name');//设置邮件的标题
	$mail->AltBody = "textml"; // optional, comment out and test
	$mail->Body = '测试成功';
	$mail->IsHTML(true);            //设置内容是否为html类型
	$mail->addAddress( trim($to), $name='' );     //设置收件的地址
	if (!$mail->Send()) {                    //发送邮件
//        echo '发送失败:'.$mail->ErrorInfo;
		return false;
	} else {
//        echo 1;
		return true;
	}
}


function buildLastMonth( $date ){
    if( date( "n",$date ) == 1 ){
        $last_month = 12;
        $year = date( 'Y',$date ) - 1;
    }else{
        $last_month = date( 'n',$date ) - 1;
        $year = date( 'Y',$date );
    }
    $last_service_time = "$year-$last_month-".date( 'd H:i:s',$date );
    return strtotime( $last_service_time );
}


/**
 * 格式化字节大小
 * @param  number $size      字节数
 * @param  string $delimiter 数字和单位分隔符
 * @return string            格式化后的带单位的大小
 */
function format_bytes($size, $delimiter = '') {
    $units = array(' B', ' KB', ' MB', ' GB', ' TB', ' PB');
    for ($i = 0; $size >= 1024 && $i < 5; $i++) $size /= 1024;
    return round($size, 2) . $delimiter . $units[$i];
}

/**
 * 用于检查当前库中是否有传入的制定表
 * db_get_tables：自定义函数
 * @param $table
 * @return bool
 */
function db_is_valid_table_name( $table )
{
	return in_array( $table,db_get_tables() );
}

/**
 * 返回不含表前缀的数组
 * @return array|null
 */
function db_get_tables()
{
	static $tables = null;
	if( null === $tables ){
		$db_prefix = C( 'DB_PREFIX' );#取得表前缀
		$db = Db::getInstance();
		$tables = array();
		foreach( $db->getTables() as $t )
		{
			#检测前缀定位，全等于0
			if( strpos( $t,$db_prefix ) === 0 )
			{
				$t = substr( $t,strlen( $db_prefix ) );#截取出没有前缀的表名
				$tables[] = strtolower( $t );#压入数组中
			}
		}
	}
	return $tables;
}

/**
 * 返回数据表的SQL
 */
function db_get_insert_sqls( $table )
{
	static $db = null;
	if ( null === $db ) {
		$db = Db::getInstance();
	}
	$db_prefix = C( 'DB_PREFIX' );#获取后续
	$export_sqls = array();
	$export_sqls[] = "DROP TABLE IF EXISTS $db_prefix$table";#如果数据库中表存在，就删除改表
	switch ( C( 'DB_TYPE' ) ) {
		case 'mysql' :
			if ( !( $d = $db->query( "SHOW CREATE TABLE $db_prefix$table" ) ) ) {
				$this->error("'SHOW CREATE TABLE $table' Error!");
			}
			$table_create_sql = $d[0]['create table'];
			$export_sqls[] = $table_create_sql;#压入导出用的数组
			$data_rows = $db->query( "SELECT * FROM {$db_prefix}{$table}" );
			$data_values = array();
			#遍历给抽出来的数据外围再加一层单引号，比如：抽出来遍历的值得是字符串：'admin',最后加引用回写的结果变成：''admin''，最后生成一组value(...) 压入数组
			foreach( $data_rows as &$v ) {
				foreach( $v as &$vv ) {
					$vv = "'" . mysql_escape_string($vv) . "'";#读取字段，地址引用，改变了数组的中vv的值，也就是同时改变了 数组中v的值
				}
				$data_values[] = '(' . join(',',$v) . ')';
			}
			#组合
			if ( count( $data_values ) > 0 ) {
				#如果数据上面有组合数据，那么就再拼凑一组字符串进行压入数组要导出的数组中
				$export_sqls[] = "INSERT INTO `$db_prefix$table` VALUES \n" . join( ",\n",$data_values );
			}
			break;
	}
	return join(";\n",$export_sqls) . ";";

}

/**
 * 强制下载
 * @param $filename
 * @param $content
 */
function force_download_content( $filename,$content )
{
	header( "Pragma:public" );
	header( "Expires:0" );
	header( "Cache-Control:must-revalidate,post-check=0,pre-check=0" );
	header( "Content-Type:application/force-download" );
	header( "Content-Transfer-Encoding:binary" );
	header( "Content-Disposition:attachment;filename=$filename" );
	echo $content;
	exit();
}


/**
 * 行为记录
 * @param string $type
 * @param string $msg		信息描述，空为默认描述为维护人员调试
 * @param string $func		操作的控制器方法中文名称
 * @param string $func		操作的控制器方法
 * @param $operator			操作人员
 */
function actionLog( $msg='',$funcName,$func,$operator,$type = 'mysql' ) {
	$logObj = M( "Log" );#实例化日志表
	$info = array();#定义日志信息数据
	switch ( $type ) {
		case 'mysql':
			#写入数据库 保存操作记录
			$info['msg'] 		= 	empty( $msg ) ? $funcName : $msg;										#获取信息
			$info['func_name'] 	= 	$funcName;																#获取操作的控制器方法
			$info['func'] 		= 	$func;																    #获取操作的控制器方法
			$info['operator'] 	= 	$operator;																#获取操作人员
			$info['ip'] 		= 	!empty( $_SERVER['REMOTE_ADDR'] ) ? $_SERVER['REMOTE_ADDR'] : '未知' ;	#获取用户ip
			$info['time']		=	time();																	#操作时间
			$log['log_desc'] 	= 	json_encode( $info );	#操作信息转换成json字符串
			$log['log_time'] 	= 	time();					#入库时间，可能跟操作时间有延误
			$logObj->add( $log );							#写入数据库
			break;
		case 'file':
			#文件日志打印，后期可扩展，用于可在不影响线上项目情况下通过打印记录到文件中， 方便维护人员进行查看
			break;
	}
}
