<?php
# +----------------------------------------------------------------
# | Thinker [ Thinkers Ideas also ]
# +----------------------------------------------------------------
# | Copyright (c) 2016 http://www.thinkerpr.com All right reserved
# +----------------------------------------------------------------
# | Author： KwongYanChan <chen.g.e@foxmail.com>
# +----------------------------------------------------------------
namespace Admin\Controller;
//use Think\Controller;
class UsersController extends AuthController{

    protected $usersObj;

    public function __construct(){
        parent::__construct();
        $this->usersObj = D( 'Users' );
    }


    /**
     * 战区空军机关用户列表
     */
    public function userslist_1(){
        $_SESSION['back_page'] = CONTROLLER_NAME . '/' . ACTION_NAME;
        $this->users = $this->usersObj->troop_1();
        $this->display( "Users/userslist_1" );
    }

    /**
     * 军以下部队用户列表
     */
    public function userslist_2(){
        $_SESSION['back_page'] = CONTROLLER_NAME . '/' . ACTION_NAME;
        $this->users = $this->usersObj->troop_2();
        $this->display( "Users/userslist_2" );
    }


    /**
     * 添加用户
     */
    public function adduser(){
        if( IS_POST ){
            $data = $this->usersObj->storeUser();
            if( $data ){
                $this->success( '添加成功',U($_SESSION['back_page']) );
            }else{
                $this->error( $this->usersObj->getError() );
            }
        }else{
            $this->display( "Users/adduser" );
        }

    }

    /**
     * 编辑用户
     */
    public function edituser(){
        if( IS_POST ){
            $data = $this->usersObj->saveUser();
            if( $data ){
                $this->success( '重置密码成功',U($_SESSION['back_page']) );
            }else{
                $this->error( $this->usersObj->getError() );
            }
        }else{
            $user_id = $_GET['user_id'];
            $this->users =  $this->usersObj->find( $user_id );
            $this->display( "Users/edituser" );
        }

    }

    /**
     * 删除用户
     */
    public function deluser(){
        if( IS_POST ){
            $condition = array( 'user_id'=>$_POST['user_id'] );
            $res = $this->usersObj->where( $condition )->setField( 'status',3 );
            if( $res ){
                $this->ajaxReturn( array( 'code'=>0,'msg'=>'用户删除成功' ) );
            }else{
                $this->ajaxReturn( array( 'code'=>1,'msg'=>'删除失败' ) );
            }
        }else{
            $this->ajaxReturn( array( 'code'=>1,'msg'=>'无效失败' ) );
        }
    }

    /**
     * 封禁用户登录
     */
    public function forbiduser(){
        $this->display( "Users/forbiduser" );
    }

    /**
     * 解决封禁
     */
    public function unbanuser(){
        $this->display( "Users/unbanuser" );
    }

}