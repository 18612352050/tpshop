<?php
# +----------------------------------------------------------------
# | Thinker [ Thinkers Ideas also ]
# +----------------------------------------------------------------
# | Copyright (c) 2016 http://www.thinkerpr.com All right reserved
# +----------------------------------------------------------------
# | Author： KwongYanChan <chen.g.e@foxmail.com>
# +----------------------------------------------------------------
namespace Admin\Controller;
// use Think\Controller;
class IndexController extends AuthController {

    public function __construct()
    {
        parent::__construct();
        $this->proConut();

    }
	/**
	 * [index 后台首页]
	 */
    public function index(){
//        dd( $_SESSION );
        $this->display();
    }

    /**
     * [admininfo 主机信息]
     */
    public function admininfo(){
    	$this->display( 'Index/config' );
    }

	/**
	 * 项目统计
	 */
    public function proConut()
    {
        //正常条件
        $condition = array(
            'isdel' =>  0,
        );
        //正常状态的数据
        $pros = M( "project" )->where( $condition )->select();
        //删除条件
        $map = array(
            'isdel' =>  1,
        );
        //回收站数据
        $_SESSION['recoverypro'] = M( "project" )->where( $map )->count();
        $prosum = array();
        $outpro = array();
        foreach( $pros as $vo ){
            $last_service_time = buildLastMonth( $vo['pro_end_time'] );
            if( time() >= intval( $last_service_time ) && time() <= intval( $vo['pro_end_time'] ) ){
                M( "project" )->where( 'pro_id='.$vo['pro_id'] )->setField('pro_status',1);
                $prosum[] = $vo;
            }else if( time() >= intval( $vo['pro_end_time'] ) ){
                $aa = M( "project" )->where( 'pro_id='.$vo['pro_id'] )->setField('pro_status',2);
//                echo M( "project" )->getLastSql();
//                dd( $vo['pro_id'] );
//                var_dump( $aa );
                $outpro[] = $vo;
            }
        }
        $_SESSION['prosum'] = count( $prosum );
        $_SESSION['outpro'] = count( $outpro );

//        if( !empty( $prosum ) ) $this->prosum = count( $prosum );
//        if( !empty( $prosum ) ) $this->outpro = count( $outpro );
    }
}