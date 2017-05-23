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
class LoginModel extends Model{

	protected $tableName = 'admin';

	public function logincheck(){
		if( !empty( $_POST['username'] ) ){
			$condition = array( 'username'=> $_POST['username']);
			$adminUser = $this->where( $condition )->find();
			if( !$adminUser ){
				$this->error = "用户不存在";
				return false;
			}

			if( $adminUser['password'] !== md5( $_POST['password'] ) ){
				$this->error = '密码输入错误';
				return false;
			}
			$data['id'] = $adminUser['id'];
			$data['login_time'] = time();
			$data['login_ip'] = $_SERVER['REMOTE_ADDR'];
			$this->save( $data );
			$_SESSION['auth']['uid'] = $adminUser['id'];
			$_SESSION['auth']['username'] = $adminUser['username'];
			return true;
		}
	}

	/**
     * 修改密码方法
     * @author leidi
     * @return bool
     */
    public function changePwd()
    {
        // 引入框架的自动验证功能
        $this->validate =
            array(
                array('password', 'required', '密码不能为空', 3, 3),
                array('password', 'confirm:password_c', '两次密码不一致', 3, 3),
                array('old_password', 'required', '原密码不能为空', 3, 3),
            );
        //旧密码的判断
        $oldPassword = $this->where("id='{$_POST['id']}'")->find();
        if (md5($_POST['old_password']) !== $oldPassword['password']) {
            $this->error = '原密码输入错误';
            return false;
        }
        // $this->data=$_POST
        if ($this->create()) {
            //更新需要主键值
            $_POST['id'] = $_POST['id'];
            $_POST['password'] = md5($_POST['password']);
            unset($_POST['old_password']);
            unset($_POST['password_c']);
            $this->save($_POST);
            return true;
        }
    }
}