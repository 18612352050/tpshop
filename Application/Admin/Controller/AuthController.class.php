<?php
# +----------------------------------------------------------------
# | Thinker [ Thinkers Ideas also ]
# +----------------------------------------------------------------
# | Copyright (c) 2016 http://www.thinkerpr.com All right reserved
# +----------------------------------------------------------------
# | Author： Yanzhijia <yzj910420@163.com>
# +----------------------------------------------------------------
namespace Admin\Controller;
use Think\Controller;
use Think\Auth;
class AuthController extends Controller{

    /**
     * 权限判断入口
     */
    protected function _initialize() {
        $sess_auth = session('auth');
        if(!$sess_auth){
            $this->redirect('Login/login');
        }
        if($sess_auth['username'] == 'admin'){
            return true;
        }

        $auth = new Auth();
        if(!$auth->check(MODULE_NAME.'/'.CONTROLLER_NAME.'/'.ACTION_NAME,$sess_auth['uid'])){
            $this->error('没有权限,请联系管理员','',60);
        }

    }
}
