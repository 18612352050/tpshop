<?php
# +----------------------------------------------------------------
# | Thinker [ Thinkers Ideas also ]
# +----------------------------------------------------------------
# | Copyright (c) 2016 http://www.thinkerpr.com All right reserved
# +----------------------------------------------------------------
# | Author： KwongYanChan <chen.g.e@foxmail.com>
# +----------------------------------------------------------------
namespace Admin\Controller;
use Think\Controller;
class LoginController extends Controller{

    /**
     * 用于对象实例化
     * @var
     */
	protected $loginObj;

    /**
     * 构造函数初始化模型引用
     */
	public function _initialize(){
		$this->loginObj = D( 'Login' );
	}

    /**
     * 登录方法
     */
	public function login(){
		if( !empty( $_POST ) ){
            if(!($this->check_code($_POST['code']))) $this->error('验证码错误');

			if( $this->loginObj->logincheck() ){
				actionLog( '登录成功','登录','login',$_POST['username'] );
				$this->redirect( "Index/index" );
			}else{
				$this->error($this->loginObj->getError());
			}
		}else{
			$this->display( "Login/login" );
		}
	}

    /**
     * 登出系统
     */
	public function logOut(){
		actionLog( '退出登录','退出登录','logOut',$_SESSION['auth']['username'] );
		session_unset();
		session_destroy();
		$this->redirect( "Login/login" );
	}

    /**
     * 更改密码
     */
	public function changePwd(){
		if( !empty($_POST) ){
			if ($this->loginObj->changePwd()) {
				actionLog( '更改密码成功','更改密码','changePwd',$_SESSION['auth']['username'] );
                $this->success('修改成功,请重新登录','Login/logOut' );
            } else {
                $this->error($this->loginObj->getError());
            }
		}else{
			$this->display( "Login/changePwd" );
		}
	}

    /**
     * 验证码
     */
    public function code() {
        $Verify = new \Think\Verify();
        $Verify->length = 3;
        $Verify->entry();
    }

    // 检测输入的验证码是否正确，$code为用户输入的验证码字符串
    private function  check_code($code, $id = ''){
        $verify = new \Think\Verify();
        return $verify->check($code, $id);
    }
}