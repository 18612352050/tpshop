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
class CategoryController extends AuthController{

	protected $CategoryObj;

	public function __construct(){
		parent::__construct();
		$this->CategoryObj = D( 'Category' );
	}

	/**
	 * [catelist 栏目列表]
	 */
	public function catelist(){
		$this->cates = $this->tree();
		actionLog( '查看栏目列表','栏目列表','catelist',$_SESSION['auth']['username'] );
		$this->display( "Category/catelist" );
	}

	/**
	 * [addcate 添加栏目]
	 */
	public function addcate(){
		if( !empty($_POST) ){
			if($this->CategoryObj->storeCate()){
				actionLog( '添加新栏目完成','添加栏目','addcate',$_SESSION['auth']['username'] );
				$this->success( '添加成功',U( 'Category/catelist' ) );
			}else{
				#actionLog( $this->CategoryObj->getError(),'添加栏目','addcate',$_SESSION['auth']['username'] );
				$this->error( $this->CategoryObj->getError() );
			}
		}else{
			#$this->cates = $this->tree();
			$this->cates = M( 'category' )->where( 'cate_pid = 0' )->select();
			$this->display( "Category/addcate" );
		}
	}

	/**
	 * [editcate 编辑栏目]
	 */
	public function editcate(){
		if( !empty( $_POST ) ){
			if($this->CategoryObj->saveCate()){
				actionLog( '编辑栏目完成','编辑栏目','editcate',$_SESSION['auth']['username'] );
				$this->success( '修改成功',U( 'Category/catelist' ) );
			}else{
				#actionLog( $this->CategoryObj->getError(),'编辑栏目','editcate',$_SESSION['auth']['username'] );
				$this->error( $this->CategoryObj->getError() );
			}
		}else{
			$this->cates = $this->tree();
			$cateid = $_GET['cate_id'];
			$this->cate = $this->CategoryObj->find( $cateid );
			$this->display( "Category/editcate" );
		}

	}

	/**
	 * [delcate 删除栏目]
	 * @return [JSON] [返回成功与失败]
	 */
	public function delcate(){
		if( !empty( $_POST ) ){
			if( $this->CategoryObj->delCate() ){
				actionLog( '删除栏目完成','删除栏目','delcate',$_SESSION['auth']['username'] );
				$this->ajaxReturn( array( 'code'=>0,'msg'=>'导航删除成功' ) );
			}else{
				#actionLog( $this->CategoryObj->getError(),'删除栏目','delcate',$_SESSION['auth']['username'] );
				$this->ajaxReturn( array( 'code'=>1,'msg'=>$this->CategoryObj->getError() ) );
			}
		}else{
			#actionLog( '无效失败','删除栏目','delcate',$_SESSION['auth']['username'] );
			$this->ajaxReturn( array( 'code'=>1,'msg'=>'无效操作' ) );
		}
	}

	/**
	 * [changeOrder 更改排序]
	 * @return [JSON] [返回成功与失败]
	 */
	public function changeOrder()
    {
    	if( !empty( $_POST ) ){
    		$condition = array( 'cate_id'=>$_POST['cate_id'] );
	        $result = $this->CategoryObj->where( $condition )->setField( 'cate_order',$_POST['cate_order'] );
	        if( $result ){
				actionLog( '排序更新成功','排序','Category/changeOrder',$_SESSION['auth']['username'] );
	            $data = array(
	                'code' => '0',
	                'msg' => '排序更新成功',
	            );
	        }else{
				#actionLog( '排序更新失败','排序','Category/changeOrder',$_SESSION['auth']['username'] );
	            $data = array(
	                'code' => '1',
	                'msg' => '排序更新失败',
	            );
	        }
    	}else{
			#actionLog( '无效失败','排序','Category/changeOrder',$_SESSION['auth']['username'] );
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
		$data = M( "category" )->order( 'cate_id ASC' )->select();
		return $this->getTree( $data,'cate_name','cate_id','cate_pid' );
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