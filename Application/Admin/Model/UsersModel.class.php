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
class UsersModel extends Model{

    /**
     * 抽取战区机关的用户
     * @return mixed
     */
    public function troop_1(){
        $condition = array( 'troop'=>1,'status'=>0 );
        return $this->where($condition)->order( "create_time DESC" )->select();
    }

    /**
     * 抽取军以下部队的用户
     * @return mixed
     */
    public function troop_2(){
        $condition = array( 'troop'=>2,'status'=>0 );
        return $this->where($condition)->order( "create_time DESC" )->select();
    }


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
        $post['password'] = md5( $post['password'] );
        $post['create_time'] = time();
        $post['operator'] = $_SESSION['username'];
        unset( $post['password_c'] );

        //增加到数据库
        if( $res = $this->add( $post ) ){
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
}