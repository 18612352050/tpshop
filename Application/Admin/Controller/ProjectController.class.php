<?php
# +----------------------------------------------------------------
# | Thinker [ Thinkers Ideas also ]
# +----------------------------------------------------------------
# | Copyright (c) 2016 http://www.thinkerpr.com All right reserved
# +----------------------------------------------------------------
# | Author： KwongYanChan <chen.g.e@foxmail.com>
# +----------------------------------------------------------------
namespace Admin\Controller;

use Admin\Controller\AuthController;

class ProjectController extends AuthController{

    /**
     * 初始化一下当天通知的数据
     * ProjectController constructor.
     */
    public function __construct()
    {
        parent::__construct();
        $condition = array( 'email_notice'=>1,'phone_notice'=>1,'_logic'=>'OR' );
        $pros = M( "project" )->where( $condition )->where( "isdel=0" )->select();
        if($pros){
            $this->ischeck( $pros );
        }
    }

    /**
     * 每天被点击栏目时候 都会释放一次通知
     * @param $data
     */
    protected function ischeck( $data )
    {
        foreach( $data as $vo ){
            if( $vo['pro_end_time'] < time() ){
                M( "project" )->where( 'pro_id='.$vo['pro_id'] )->setField('pro_status',2);
            }
            M( "project" )->where( 'pro_id='.$vo['pro_id'] )->setField('phone_notice',0);
            M( "project" )->where( 'pro_id='.$vo['pro_id'] )->setField('email_notice',0);
        }
    }
    /*
     * 项目列表
     */
    public function prolist()
    {
        $condition = array(
            'isdel' =>  0,
        );
        $this->pros = M( "project" )->where( $condition )->select();
		actionLog( '查看运行项目','项目列表','prolist',$_SESSION['auth']['username'] );
        $this->display( "Project/projectlist" );
    }

    /**
     * 添加项目
     */
    public function addpro()
    {
        if( IS_POST ){
            $validate = array(
                array( 'pro_name','require','项目名不能为空' ),
                array( 'pro_service_cash','require','续费费用不能为空' ),
                array( 'pro_domain','require','项目域名不能为空' ),
                array( 'pro_cname','require','项目联系人名字不能为空' ),
                array( 'pro_phone','require','项目联系人手机不能为空' ),
                array( 'pro_email','require','项目联系人邮箱不能为空' ),
                array( 'pro_service_time','require','项目上线时间不能为空' ),
                array( 'pro_end_time','require','项目维护结束时间不能为空' ),
            );
            $post['pro_name'] = htmlspecialchars( $_POST['pro_name'] );
            $post['pro_service_cash'] = $_POST['pro_service_cash'];
            $post['pro_domain'] = htmlspecialchars( $_POST['pro_domain'] );
            $post['pro_cname'] = htmlspecialchars( $_POST['pro_cname'] );
            $post['pro_phone'] = htmlspecialchars( $_POST['pro_phone'] );
            $post['pro_email'] = htmlspecialchars($_POST['pro_email'] );
            $post['pro_service_time'] = strtotime( $_POST['pro_service_time'] );
            $post['pro_end_time'] = strtotime( $_POST['pro_end_time'] );

            if( M( "project" )->validate( $validate )->create( $post ) ){
                if( $res = M( "project" )->add($post)){
					actionLog( '添加项目完成','添加项目','addpro',$_SESSION['auth']['username'] );
                    $this->success( '添加成功',U( 'Project/prolist' ) );
                }else{
                    $this->error( "添加失败" );
                }
            }else{
                $this->error( M( "project" )->getError() );
            }
        }else{
            $this->display( "Project/addproject" );
        }

    }

    /**
     * 编辑项目
     */
    public function editpro()
    {
        if( IS_POST ){
            $validate = array(
                array( 'pro_name','require','项目名不能为空' ),
                array( 'pro_service_cash','require','续费费用不能为空' ),
                array( 'pro_domain','require','项目域名不能为空' ),
                array( 'pro_cname','require','项目联系人名字不能为空' ),
                array( 'pro_phone','require','项目联系人手机不能为空' ),
                array( 'pro_email','require','项目联系人邮箱不能为空' ),
                array( 'pro_service_time','require','项目上线时间不能为空' ),
                array( 'pro_end_time','require','项目维护结束时间不能为空' ),
            );
            $post['pro_id'] = $_POST['pro_id'];
            $post['pro_name'] = htmlspecialchars( $_POST['pro_name'] );
            $post['pro_service_cash'] = $_POST['pro_service_cash'];
            $post['pro_domain'] = htmlspecialchars( $_POST['pro_domain'] );
            $post['pro_cname'] = htmlspecialchars( $_POST['pro_cname'] );
            $post['pro_phone'] = htmlspecialchars( $_POST['pro_phone'] );
            $post['pro_email'] = htmlspecialchars($_POST['pro_email'] );
            $post['pro_service_time'] = strtotime( $_POST['pro_service_time'] );
            $post['pro_end_time'] = strtotime( $_POST['pro_end_time'] );

            $last_service_time = buildLastMonth( $post['pro_end_time'] );
            if( time() >= intval( $last_service_time ) && time() <= intval( $post['pro_end_time'] ) ){
                $post['pro_status'] = 1;
            }else if( time() >= intval( $post['pro_end_time'] ) ){
                $post['pro_status'] = 2;
            }else{
                $post['pro_status'] = 0;
            }

            if( M( "project" )->validate( $validate )->create( $post ) ){
                if( $res = M( "project" )->save($post)){
					actionLog( '修改项目信息完成','编辑项目','editpro',$_SESSION['auth']['username'] );
                    $this->success( '修改成功',U( 'Project/prolist' ) );
                }else if( $res == 0 ){
                    $this->error( "没有更新内容" );
                }else{
                    $this->error( "修改失败" );
                }
            }else{
                $this->error( M( "project" )->getError() );
            }
        }else{
            $pro_id = $_GET['pro_id'];
            $this->pro = M( "project" )->where( array( 'pro_id'=>$pro_id ) )->find();

            $this->display( "Project/editproject" );
        }

    }

    /**
     * 删除项目 ，进入回收站
     */
    public function delpro()
    {
        if( !empty( $_POST['pro_id'] ) ){
            $condition = array( 'pro_id'=>$_POST['pro_id'] );
            if( $res = M( "project" )->where( $condition )->setField( 'isdel',1 ) ){
				actionLog( '删除项目完成','删除项目','delpro',$_SESSION['auth']['username'] );
                $this->ajaxReturn( array( 'code'=>0,'msg'=>'此记录进入回收站' ) );
            }else{
                $this->ajaxReturn( array( 'code'=>1,'msg'=>'操作失败' ) );
            }
        }else{
            $this->ajaxReturn( array( 'code'=>1,'msg'=>'无效操作' ) );
        }
    }

    /**
     *  即将过期的项目
     */
    public function lastpro()
    {
        $condition = array(
            'isdel' =>  0,
        );
        $pros = M( "project" )->where( $condition )->select();
        $prosum = array();
        foreach( $pros as $vo ){
            $last_service_time = buildLastMonth( $vo['pro_end_time'] );
            if( time() >= intval( $last_service_time ) && time() <= intval( $vo['pro_end_time'] ) ){
                $prosum[] = $vo;
            }
        }

        $this->pros = $prosum;
		actionLog( '即将过期的项目列表','即将过期的项目','lastpro',$_SESSION['auth']['username'] );
        $this->display( "Project/lastpro" );
    }
    /**
     *  过期的项目
     */
    public function outpro()
    {
        $condition = array(
            'isdel' =>  0,
        );
        $pros = M( "project" )->where( $condition )->select();
        $outpro = array();
        foreach( $pros as $vo ){
            if( time() >= intval( $vo['pro_end_time'] ) ){
                $outpro[] = $vo;
            }
        }
        $this->pros = $outpro;
		actionLog( '过期的项目列表','过期的项目','outpro',$_SESSION['auth']['username'] );
        $this->display( "Project/outpro" );
    }

    /**
     * 项目回收站
     */
    public function recyclepro()
    {
        $condition = array(
            'isdel' => 1,
        );
        $this->pros = M( "project" )->where( $condition )->select();
		actionLog( '项目回收站','项目回收站','recyclepro',$_SESSION['auth']['username'] );
        $this->display( "Project/recyclepro" );
    }

    /**
     * 恢复项目
     */
    public function recoverypro()
    {
        if( !empty( $_POST['pro_id'] ) ){
            $condition = array( 'pro_id'=>$_POST['pro_id'] );
            if( $res = M( "project" )->where( $condition )->setField( 'isdel',0 ) ){
				actionLog( '项目记录已恢复','恢复项目','recoverypro',$_SESSION['auth']['username'] );
                $this->ajaxReturn( array( 'code'=>0,'msg'=>'项目记录已恢复' ) );
            }else{
                $this->ajaxReturn( array( 'code'=>1,'msg'=>'操作失败' ) );
            }
        }else{
            $this->ajaxReturn( array( 'code'=>1,'msg'=>'无效操作' ) );
        }
    }



    /**
     * 发送短信通知
     */
    public function sendPhoneMsg()
    {
        if( isset( $_POST['pro_id'] ) ){
            $info = M( "project" )->find( $_POST['pro_id'] );//取出单条数据

            // 配置验证码内容
			#旧内容，旧短信接口使用的，后期如果要舍弃就直接删除吧，现在保留一下
            #$message=urlencode(iconv('utf-8','gb2312','【星客网络】友情提示!尊敬的客户您好！您的网站：'.$info['pro_name'].',域名:('.$info['pro_domain'].')所在的服务器将于'.date( "Y年m月d日",$info['pro_end_time'] ).'到期,续费金额￥'.$info['pro_service_cash'].'元，为避免给您的网站造成不良影响，请您及时联系我司客服进行维护续期,客服热线：010-5773-6822。退订回T。'));
            #新内容
			$message='【星客网络】友情提示!尊敬的客户您好！您的网站：'.$info['pro_name'].',域名:('.$info['pro_domain'].')所在的服务器将于'.date( "Y年m月d日",$info['pro_end_time'] ).'到期,续费金额￥'.$info['pro_service_cash'].'元，为避免给您的网站造成不良影响，请您及时联系我司客服进行维护续期,客服热线：010-5773-6822。退订回T';

			$str = get_ssl_content( $message,$info['pro_phone'] );//调用方法文件中的方法
			$strinfo = explode( ';',$str );
			$data = array();
			foreach( $strinfo as $vo ) {
				$tmp = explode( '=',$vo );
				$data[$tmp[0]] = $tmp[1];
			}
            switch( $data['message'] ){
                case '0':
                    M( "project" )->where( 'pro_id='.$info['pro_id'] )->setField('phone_notice_num',$info['phone_notice_num'] + 1);
                    M( "project" )->where( 'pro_id='.$info['pro_id'] )->setField('isphone_notice_time',time());
                    M( "project" )->where( 'pro_id='.$info['pro_id'] )->setField('phone_notice',1);
					actionLog( '通知成功','短信通知','sendPhoneMsg',$_SESSION['auth']['username'] );
                    $this->ajaxReturn( array( 'code'=>0,'msg'=>'通知成功！' ) );
                    break;
                case '1':
                    $this->ajaxReturn( array( 'code'=>1,'msg'=>'系统暂停发送短信' ) );
                    break;
                case '2':
                    $this->ajaxReturn( array( 'code'=>2,'msg'=>'用户名或密码错误' ) );
                    break;
                case '3':
                    $this->ajaxReturn( array( 'code'=>3,'msg'=>'没有分配通道组' ) );
                    break;
                case '4':
                    $this->ajaxReturn( array( 'code'=>4,'msg'=>'必要属性为空或填写不合法' ) );
                    break;
                case '5':
                    $this->ajaxReturn( array( 'code'=>5,'msg'=>'余额不足' ) );
                    break;
                case '6':
                    $this->ajaxReturn( array( 'code'=>6,'msg'=>'短信包含敏感词' ) );
                    break;
                case '7':
                    $this->ajaxReturn( array( 'code'=>7,'msg'=>'没有权限' ) );
                    break;
				case '8':
                    $this->ajaxReturn( array( 'code'=>8,'msg'=>'推送地址为空' ) );
                    break;
				case '9':
                    $this->ajaxReturn( array( 'code'=>9,'msg'=>'系统错误' ) );
                    break;
                default:
                    $this->ajaxReturn( array( 'code'=>99,'msg'=>'未知错误' ) );
                    break;
            }
        }else{
            $this->ajaxReturn( array( 'code'=>1,'msg'=>'无通知用户可取,请回列表确认或联系管理员' ) );
        }
    }

    /**
     * 发送邮件通知
     */
    public function sendEmailMsg()
    {
        if( isset( $_POST['pro_id'] ) ) {
            $info = M("project")->find($_POST['pro_id']);//取出单条数据
            $message='【星客网络-友情提示】尊敬的客户您好！您的网站：'.$info['pro_name'].',域名:('.$info['pro_domain'].')所在的服务器将于'.date( "Y年m月d日",$info['pro_end_time'] ).'到期,续费金额￥'.$info['pro_service_cash'].'元，为避免给您的网站造成不良影响，请您及时联系我司客服进行维护续期,客服热线：010-5773-6822';

            if( sendMail( $info['pro_email'],$message ) ){
                M( "project" )->where( 'pro_id='.$info['pro_id'] )->setField('email_notice_num',$info['email_notice_num'] + 1);
                M( "project" )->where( 'pro_id='.$info['pro_id'] )->setField('isemail_notice_time',time());
                M( "project" )->where( 'pro_id='.$info['pro_id'] )->setField('email_notice',1);
				actionLog( '通知成功','邮件通知','sendEmailMsg',$_SESSION['auth']['username'] );
                $this->ajaxReturn( array( 'code'=>0,'msg'=>'通知成功！' ) );
            }else{
                $this->ajaxReturn( array( 'code'=>1,'msg'=>'操作失败！' ) );
            }
        }
    }





}