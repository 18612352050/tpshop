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
class NavsController extends AuthController{
	protected $navObj;

	#初始化属性
	public function __construct(){
		parent::__construct();
		$this->navObj = D( 'Navs' );
	}

	/**
	 * [navlist 导航首页]
	 */
	public function navlist(){
		$this->navs = $this->tree();
		actionLog( '查看导航列表','导航列表','navlist',$_SESSION['auth']['username'] );
		$this->display( 'Navs/navlist' );
	}

	/**
	 * [addnav 添加导航]
	 */
	public function addnav(){
		if( !empty( $_POST ) ){
			if($this->navObj->storeNav()){
				actionLog( '成功增加导航','添加导航','addnav',$_SESSION['auth']['username'] );
				$this->success( '添加成功',U( 'Navs/navlist' ) );
			}else{
				$this->error( $this->getError() );
			}
		}else{
			$this->navs = $this->tree();
			$this->display( 'Navs/addnav' );
		}

	}

	/**
	 * [editnav 编辑导航]
	 */
	public function editnav(){
		if( !empty( $_POST ) ){
			if($this->navObj->saveNav()){
				actionLog( '编辑导航信息','编辑导航','editnav',$_SESSION['auth']['username'] );
				$this->success( '修改成功',U( 'Navs/navlist' ) );
			}else{
				$this->error( $this->getError() );
			}
		}else{
			$navid = $_GET['nav_id'];
			$this->nav = $this->navObj->find( $navid );
			$this->navs = $this->navObj->where( array( "nav_pid"=>"0" ) )->select();
			$this->display( 'Navs/editnav' );
		}

	}

	/**
	 * [delnav 删除导航]
	 * @return [JSON] [description]
	 */
	public function delnav(){
		if( !empty( $_POST ) ){
			if( $this->navObj->delNav() ){
				actionLog( '删除导航成功','删除导航','delnav',$_SESSION['auth']['username'] );
				$this->ajaxReturn( array( 'code'=>0,'msg'=>'导航删除成功' ) );
			}else{
				$this->ajaxReturn( array( 'code'=>1,'msg'=>$this->navObj->getError() ) );
			}
		}else{
			$this->ajaxReturn( array( 'code'=>1,'msg'=>'无效失败' ) );
		}
	}

	/**
	 * [changeOrder 更改排序]
	 * @return [JSON] [description]
	 */
	public function changeOrder()
    {
    	if( !empty( $_POST ) ){
    		$condition = array( 'nav_id'=>$_POST['nav_id'] );
	        $result = $this->navObj->where( $condition )->setField( 'nav_order',$_POST['nav_order'] );
	        if( $result ){
				actionLog( '排序更新成功','排序','Navs/changeOrder',$_SESSION['auth']['username'] );
	            $data = array(
	                'code' => '0',
	                'msg' => '排序更新成功',
	            );
	        }else{
	            $data = array(
	                'code' => '1',
	                'msg' => '排序更新失败',
	            );
	        }
    	}else{
    		$data = array(
	                'code' => '1',
	                'msg' => '无效失败',
	            );
    	}
        $this->ajaxReturn($data);
    }


	/**
	 * 获取树形，返回分类级
	 * @return array
	 */
	public function tree( ){
		$data = M( "navs" )->order( 'nav_id ASC' )->select();
		return $this->getTree( $data,'nav_name','nav_id','nav_pid' );
	}
	/**
	 * @param $data                 需要分类的数据
	 * @param $cateName             需要分类的字段
	 * @param string $cateId        id字段
	 * @param string $catePid       父级ID
	 * @param string $pid           初始化父级ID
	 * @return array                返回数组
	 */
	protected function getTree($data,$cateName,$cateId = 'id',$catePid = 'pid',$pid = '0'){
		$arr = array();
		foreach( $data as $k=>$v ){
			if( $v[$catePid] == $pid ){
				$data[$k]['_'.$cateName] = $data[$k][$cateName];
				$arr[] = $data[$k];
				foreach( $data as $m=>$n ){
					if( $n[$catePid] == $v[$cateId] ){
						$data[$m]['_'.$cateName] = '&nbsp;&nbsp;&nbsp;|-- '.$data[$m][$cateName];
						$arr[] = $data[$m];
					}
				}
			}
		}
		return $arr;
	}

}