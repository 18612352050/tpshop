<?php
# +----------------------------------------------------------------
# | Thinker [ Thinkers Ideas also ]
# +----------------------------------------------------------------
# | Copyright (c) 2016 http://www.thinkerpr.com All right reserved
# +----------------------------------------------------------------
# | Author： KwongYanChan <chen.g.e@foxmail.com>
# +----------------------------------------------------------------
namespace Admin\Model;
use Think\Model;
class AdminModel extends Model{


    /**
     * 新增用户
     */
    public function storeUser(){
        //判断用户名是否空， 用户名是否存在数据库，密码是否空，前后密码是否一致
        if( empty( $_POST['username'] ) ) {
            $this->error = "用户名不能为空";
            return false;
        }
        $condition = array( 'username'=> $_POST['username']);
        $adminUser = $this->where( $condition )->find();
        if( $adminUser ){
            $this->error = "用户名已存在";
            return false;
        }
        if( empty( $_POST['password'] ) || empty( $_POST['password_c'] ) ){
            $this->error = "密码不能为空";
            return false;
        }else if( $_POST['password'] != $_POST['password_c'] ){
            $this->error = "两次密码不一致";
            return false;
        }

        //增加数据库字段，并且卸掉确认密码字段
        $post = $_POST;
        $group_id = $_POST['group_id'];
        $post['password'] = md5( $post['password'] );
        $post['createtime'] = time();
        $post['operator'] = $_SESSION['auth']['username'];
        unset( $post['password_c'] );



        //增加到数据库
        if( $res = $this->add( $post ) ){
            $group['uid'] = $res;
            $group['group_id'] = $group_id;
            M( 'auth_group_access' )->add( $group );
            return $res;
        }else{
            $this->error = "添加失败";
        }
    }

    /**
 * 重置密码
 */
    public function saveUser(){
        //判断用户名是否空， 用户名是否存在数据库，密码是否空，前后密码是否一致
        if( empty( $_POST['password'] ) || empty( $_POST['password_c'] ) ){
            $this->error = "密码不能为空";
            return false;
        }else if( $_POST['password'] != $_POST['password_c'] ){
            $this->error = "两次密码不一致";
            return false;
        }

        //增加数据库字段，并且卸掉确认密码字段
        $post = $_POST;
        $post['password'] = md5( $post['password'] );
        $post['change_pwd_time'] = time();
        $post['change_operator'] = $_SESSION['username'];
        unset( $post['password_c'] );

        //增加到数据库
        if( $res = $this->save( $post ) ){
            return $res;
        }else{
            $this->error = "添加失败";
        }
    }


    /**
     * 编辑用户，选择用户组
     */
    public function editUser(){
        //判断用户组有没有选择
        if( empty( $_POST['group_id'] ) ){
            $this->error = "所属用户组没有选择";
            return false;
        }
        $post['uid'] = $_POST['id'];
        $post['group_id'] = $_POST['group_id'];
        $accessInfo = M( 'auth_group_access' )->where( 'uid='.$post['uid'] )->find();
        if( $accessInfo ){
            $res = M( 'auth_group_access' )->where( 'uid='.$post['uid'] )->save( $post );
            if( $res ){
                return $res;
            }else{
                $this->error = "更新失败";
            }
        }else{
            if( $res = M( 'auth_group_access' )->add( $post ) ){
                return $res;
            }else{
                $this->error = "添加失败";
            }
        }

    }

    /**
     * 删除管理员角色。顺带删除权限
     */
    public function delAdmin(){
        $post = $_POST;
        if( $res = $this->delete( $post['id'] ) ){
            M( "auth_group_access" )->where( array( 'uid'=>$post['id'] ) )->delete();
            return $res;
        }else{
            $this->error = "删除失败";
        }
    }
}