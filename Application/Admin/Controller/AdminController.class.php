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
class AdminController extends AuthController{

    protected $AdminObj;

    //初始化属性
    public function __construct(){
        parent::__construct();
        $this->AdminObj = D( 'Admin' );
    }

    /**
     * 管理员列表
     * 不显示超级管理员， 只显示其他管理员角色
     */
    public function adminlist(){
        $_SESSION['back_page'] = CONTROLLER_NAME . '/' . ACTION_NAME;
//        $condition['username'] = array( 'neq','admin' );//不等于超级管理员
        //1、admin表 2、auth_group 3、auth_group_access
        $admins = M( "Admin" )->select();
        $access = M( "auth_group_access" )->select();
        $newAccess = array();
        if( !empty( $access ) ){
            foreach( $admins as $va ){
                $va['group_id'] = M( "auth_group_access" )->getFieldByUid( $va['id'],'group_id' );
                $va['group_title'] = M( "auth_group" )->getFieldById( $va['group_id'],'title' );
                $newAccess[] = $va;
            }
        }else{
            foreach( $admins as $va ){
                $va['group_id'] = '';
                $va['group_title'] = '';
                $newAccess[] = $va;
            }
        }
        $this->admins = $newAccess;
		actionLog( '查看管理员列表','管理员列表','adminlist',$_SESSION['auth']['username'] );
        $this->display( "Admin/adminlist" );
    }

    /**
     * 添加管理员
     * 用于添加管理员角色
     */
    public function addadmin(){
        if( IS_POST ){
            $data = $this->AdminObj->storeUser();
            if( $data ){
				actionLog( '添加管理员成功','添加管理员','addadmin',$_SESSION['auth']['username'] );
                $this->success( '添加成功',U($_SESSION['back_page']) );
            }else{
				#actionLog( $this->AdminObj->getError(),'添加管理员','addadmin',$_SESSION['auth']['username'] );
                $this->error( $this->AdminObj->getError() );
            }
        }else{
            $this->groups = M( 'auth_group' )->field( 'id,title' )->select();
            $this->display( "Admin/addadmin" );
        }

    }

    /**
     * 编辑管理员信息
     */
    public function editadmin()
    {
        if( IS_POST ){
            $data = $this->AdminObj->editUser();
            if( $data ){
				actionLog( '管理员设置用户组成功','设置管理员用户组','editadmin',$_SESSION['auth']['username'] );
                $this->success( '管理员设置用户组成功',U($_SESSION['back_page']) );
            }else{
				#actionLog( $this->AdminObj->getError(),'设置管理员用户组','editadmin',$_SESSION['auth']['username'] );
                $this->error( $this->AdminObj->getError() );
            }
        }else{
            $id = isset($_GET['id']) ? $_GET['id'] : '' ;
            if( $id ){
                $this->info = $this->AdminObj->find( $id );
            }else{
                $this->info = '';
            }
            $this->group_id = isset($_GET['group_id']) ? $_GET['group_id'] : '' ;
            $this->groups = M( 'auth_group' )->field( 'id,title' )->select();
            $this->display( "Admin/editadmin" );
        }
    }

    /**
     * 删除管理员，顺带删除用户对应的分组
     */
    public function deladmin(){
        if( IS_AJAX ){
            $data = $this->AdminObj->delAdmin();
            if( $data ){
				actionLog( '删除成功','删除管理员','deladmin',$_SESSION['auth']['username'] );
                $this->ajaxReturn( array( 'code'=>0,'msg'=>'删除成功' ) );
            }else{
				#actionLog( $this->AdminObj->getError(),'设置管理员用户组','deladmin',$_SESSION['auth']['username'] );
                $this->ajaxReturn( array( 'code'=>1,'msg'=>$this->AdminObj-getError() ) );
            }
        }else{
			#actionLog( '无效失败','删除管理员','deladmin',$_SESSION['auth']['username'] );
            $this->ajaxReturn( array( 'code'=>1,'msg'=>'无效失败' ) );
        }
    }


    /**
     * 添加权限组
     * 给管理员归入特定的权限组中
     */
    public function addadmingroup(){
        if( IS_POST ){
            $post = $_POST;
            if( M('auth_group_access')->create( $post ) ){
                if( M('auth_group_access')->add( $post ) ){
					actionLog( '添加权限组成功','添加权限组','addadmingroup',$_SESSION['auth']['username'] );
                    $this->success('添加成功',U( $_SESSION['back_page'] ));
                }else{
					#actionLog( '操作失败','添加权限组','addadmingroup',$_SESSION['auth']['username'] );
                    $this->success('操作失败');
                }
            }
        }else{
            $adminid = $_GET['admin_id'];
            $this->adminUser = M( "Admin" )->field( "id,username" )->find( $adminid );
            $this->ruleGroup = M( "auth_group" )->select();
            $this->display( "Admin/addadmingroup" );
        }

    }

    /**
     * 删减权限组
     * 超级管理员或者跟超级管理员一样权限的管理员角色可以删减其他管理员角色权限
     */
    public function cutadmingroup(){
        if( IS_POST ){
            $post = $_POST;
            $condition = array( 'uid'=>$post['uid'],'group_id'=>$post['group_id'] );
            if( M('auth_group_access')->where( $condition )->delete( ) ){
				actionLog( '删减权限成功','删减权限组','cutadmingroup',$_SESSION['auth']['username'] );
                $this->success('删减权限成功',U( $_SESSION['back_page']));
            }else{
				#actionLog( '删减权限操作失败','删减权限组','cutadmingroup',$_SESSION['auth']['username'] );
                $this->success('删减权限操作失败');
            }
        }else{
            $adminid = $_GET['admin_id'];
            $this->adminUser = M( "Admin" )->field( "id,username" )->find( $adminid );
            $data =  M( "auth_group_access" )->where( array( 'uid'=>$adminid ) )->select();
            $rule = array();
            foreach( $data as $vo ){
                $rule[] = $vo['group_id'];
            }
            $groups = array();
            $ruleGroup = M( "auth_group" )->select();
            foreach( $rule as $vo ){
                foreach( $ruleGroup as $vr ){
                    if( $vo == $vr['id'] ){
                        $groups[] = $vr;
                    }
                }
            }
            $this->ruleGroup = $groups;
            $this->display( "Admin/cutadmingroup" );
        }

    }


}