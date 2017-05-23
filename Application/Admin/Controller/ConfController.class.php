<?php
# +----------------------------------------------------------------
# | Thinker [ Thinkers Ideas also ]
# +----------------------------------------------------------------
# | Copyright (c) 2016 http://www.thinkerpr.com All right reserved
# +----------------------------------------------------------------
# | Author： Yanzhijia <yzj910420@163.com>
# +----------------------------------------------------------------
namespace Admin\Controller;

class ConfController extends AuthController{

    /**
     * 首页
     */
    public function index(){
        $data = M("Conf")->select();
        foreach( $data as $k=>$v ){
            switch( $v['field_type'] ){
                case 'input':
                    $data[$k]['_html'] = '<input type="text" class="lg hd-w1000 hd-h30" name="conf_content[]" value="'.$v['conf_content'] .'" />';
                    break;
                case 'textarea':
                    $data[$k]['_html'] = '<textarea name="conf_content[]" class="lg hd-w1000 hd-h80">'.$v['conf_content'].'</textarea>';
                    break;
            }
        }
        $this->confs = $data;
		actionLog( '查看配置首页','配置列表','Conf/index',$_SESSION['auth']['username'] );#操作记录
        $this->display( "Conf/index" );
    }

    /**
     * 创建配置项
     */
    public function createConf(){
        if( IS_POST ){
            $validate = array(
                array( 'conf_name','require','配置项名字不能为空' ),
                array( 'conf_title','require','配置项标题不能为空' ),
            );
            $post = $_POST;

            if( M( "conf" )->validate( $validate )->create( $post ) ){
                if( $res = M( "conf" )->add($post)){
					actionLog( '添加配置项成功','创建配置项','Conf/createConf',$_SESSION['auth']['username'] );#操作记录
                    $this->success( '添加配置项成功',U( 'Conf/index' ) );
                }else{
                    $this->error( "添加配置项失败" );
                }
            }else{
                $this->error(  M( "conf" )->getError() );
            }
        }else{
            $this->display( "Conf/create" );
        }

    }

    /**
     *  删除方法
     */
    public function destroy( $conf_id ){

        $result = M( "Conf" )->delete( $conf_id );
        if( $result ){
//            $this->putFile();
			actionLog( '配置项删除成功','删除配置项','Conf/destroy',$_SESSION['auth']['username'] );#操作记录
            $data = array(
                'code'=>0,
                'msg'=>'配置项删除成功',
            );
        }else{
            $data = array(
                'code'=>1,
                'msg'=> '配置项删除失败 ',
            );
        }
        $this->putFile();
        $this->ajaxReturn( $data );
    }


    /**
     * 更改配置项方法
     */
    public function changeContent(){
        if( IS_POST ){
            $post = $_POST;
            foreach( $post['conf_id'] as $k=>$v ){
                M( "Conf" )->where( array( 'conf_id'=>$v ) )->setField( 'conf_content',$post['conf_content'][$k] );
            }
            $this->putFile();
			actionLog( '配置更新成功','更改配置项','Conf/changeContent',$_SESSION['auth']['username'] );#操作记录
            $this->success( "配置更新成功",U( 'Conf/index' ) );
        }else{
            $this->error( "配置更新失败" );
        }
    }

    /**
     * 编辑配置项
     */
    public function editConf(){
        if( IS_POST ){
            $validate = array(
                array( 'conf_name','require','配置项名字不能为空' ),
                array( 'conf_title','require','配置项标题不能为空' ),
            );
            $post = $_POST;

            if( M( "conf" )->validate( $validate )->create( $post ) ){
                if( $res = M( "conf" )->save($post)){
                    $this->putFile();
					actionLog( '修改配置项成功','编辑配置项','Conf/editConf',$_SESSION['auth']['username'] );#操作记录
                    $this->success( '修改配置项成功',U( 'Conf/index' ) );
                }else{
                    $this->error( "修改配置项失败" );
                }
            }else{
                $this->error(  M( "conf" )->getError() );
            }
        }else{
            $confid = $_GET['conf_id'];
            $data = M( "conf" )->find( $confid );

            $this->conf = $data;
            $this->display( "Conf/edit" );
        }

    }

    /*
     * 把配置项放到配置文件内
     */
    public function putFile(){
        $conf = M( "conf" )->getField( 'conf_title,conf_content' );
        $path = APP_PATH.'Common/Conf/web.php';
        $str = "<?php return ".var_export( $conf,true ).";";
        file_put_contents( $path,$str );
    }

	/**
	 * 日志列表
	 */
	public function loglist()
	{
		$condition = "1=1";//初始化
		//渲染
		$log = dataPage( 'Log',$condition,15,'log_time DESC' );
		foreach( $log['list'] as &$vo ) {
			$vo['log_desc'] = (array)json_decode( $vo['log_desc'] );
		}
		$this->list = $log['list'];
		$this->page = $log['page'];
		$this->display( "Conf/loglist" );
	}
    /**
     * 邮箱设置
     */
    public function mail(){
        if( IS_POST ){
            $validate = array(
                array( 'type','require','邮件发送方式不能为空' ),
                array( 'smtp_address','require','smtp地址不能为空' ),
                array( 'port','require','端口不能为空' ),
                array( 'e_address','require','邮箱地址不能为空' ),
                array( 'e_password','require','邮箱密码不能为空' ),
                array( 'e_name','require','发送者姓名不能为空' ),
            );
            $post = $_POST;
            //组装放入到mail.php配置文件的数据
            $data = array();
            $data['type'] = 'SMTP';
            $data['smtp_address'] = $post['smtp_address'];
            $data['is_ssl'] = $post['is_ssl'];
            $data['port'] = $post['port'];
            $data['e_address'] = $post['e_address'];
            $data['e_password'] = $post['e_password'];
            $data['e_name'] = $post['e_name'];
            $mail = M('Mail');
            $check = $mail->find(1);
            if(isset($check['id'])){
                $res = $mail->save( $post );
                if( $res ){
                    actionLog( '修改邮件配置项成功','创建配置项','Conf/mail',$_SESSION['auth']['username'] );#操作记录
                    $this->putMail( $data );
                    $this->success( '添加配置项成功',U( 'Conf/mail' ) );
                }else{
                    $this->error( "添加配置项失败" );
                }
            }else{
                if( $mail->validate( $validate )->create( $post ) ){
                    $res=$mail->add();
                    if( $res ){
                        actionLog( '修改邮件配置项成功','创建配置项','Conf/mail',$_SESSION['auth']['username'] );#操作记录
                        $this->putMail( $data );
                        $this->success( '添加配置项成功',U( 'Conf/mail' ) );
                    }else{
                        $this->error( "添加配置项失败" );
                    }
                }else{
                    $this->error(  $mail->getError() );
                }

            }
        }else{
            $data = M("Mail")->find(1);
            $this->conf = $data;
            $this->display( "Conf/mail" );
        }
    }

    /*
     * 把邮箱配置项放到配置文件内
     */
    public function putMail( $conf ){
        $path = APP_PATH.'Common/Conf/mail.php';
        $str = "<?php return ".var_export( $conf,true ).";";
        file_put_contents( $path,$str );
    }
    public function sendMailTest(){
        if( IS_POST ){
            $to = I('post.sendto');
            if( sendMailTest($to) ){
                $data = array(
                    'code'=>0,
                    'msg'=>'邮件测试成功！',
                );
            }else{
                $data = array(
                    'code'=>1,
                    'msg'=>'邮件测试失败！',
                );
            }
            $this->ajaxReturn($data);
        }

    }
    //提醒模板管理
    public function notice(){
        $notice = M('notice');
        $condition['obje'] = 0;
        $sys = $notice->where( $condition )->group('key_id')->select();
        $condition['obje'] = 1;
        $user = $notice->where( $condition )->group('key_id')->select();
        $this->sys = $sys;
        $this->user = $user;
        $this->display('Conf/notice');
    }
    public  function noticeEdit(){
        $notice = M('notice');
        if( IS_POST ){
            $post = $_POST;
            $res = $notice->save( $post );
            if( $res ){
                actionLog( '修改提醒模板成功','修改模板','Conf/noticeEdit',$_SESSION['auth']['username'] );#操作记录
                $this->success( '修改提醒模板成功',U( 'Conf/notice' ) );
            }else{
                $this->error( "修改提醒模板失败" );
            }
        }else{
            $condition['key_id'] = I('get.key_id');
            $condition['style'] = I('get.style');
            $condition['obje'] = I('get.obje');
            $field = $notice->where( $condition )->find();
            $this->field = $field;
            $this->display('Conf/noticeEdit');
//            echo '<pre>';
//            var_dump($field);die;
        }
    }
}
