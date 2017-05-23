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
class LinksController extends AuthController{

	protected $linksObj;

	public function __construct(){
		parent::__construct();
		$this->linksObj = D( 'Links' );
	}

	/**
	 * [linklist 友情连接列表]
	 */
	public function linklist(){
		$this->links = $this->linksObj->order( 'link_order asc' )->select();
		actionLog( '查看友情连接列表','友情连接列表','linklist',$_SESSION['auth']['username'] );#行为记录
		$this->display( "Links/linklist" );
	}

	/**
	 * [addlink 添加友情连接]
	 */
	public function addlink(){
		if( !empty( $_POST ) ){
			if($this->linksObj->storeLink()){
				actionLog( '添加友情连接完成','添加友情连接','addlink',$_SESSION['auth']['username'] );
				$this->success( '添加成功',U( 'Links/linklist' ) );
			}else{
				$this->error( $this->linksObj->getError() );
			}
		}else{

			$this->display( "Links/addlink" );
		}

	}

	/**
	 * [editlink 编辑友情连接]
	 */
	public function editlink(){
		if( !empty( $_POST ) ){
			if($this->linksObj->saveLink()){
				actionLog( '编辑友情连接完成','编辑友情连接','editlink',$_SESSION['auth']['username'] );
				$this->success( '修改成功',U( 'Links/linklist' ) );
			}else{
				$this->error( $this->linksObj->getError() );
			}
		}else{
			$linkid = $_GET['link_id'];
			$this->link = $this->linksObj->find( $linkid );
			$this->display( "Links/editlink" );
		}

	}

	/**
	 * [dellink 删除]
	 */
	public function dellink(){
		if( !empty( $_POST ) ){
			if( $this->linksObj->delLink() ){
				actionLog( '删除友情连接完成','删除友情连接','dellink',$_SESSION['auth']['username'] );
				$this->ajaxReturn( array( 'code'=>0,'msg'=>'友情链接删除成功' ) );
			}else{
				$this->ajaxReturn( array( 'code'=>1,'msg'=>$this->linksObj->getError() ) );
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
    		$condition = array( 'link_id'=>$_POST['link_id'] );
	        $result = $this->linksObj->where( $condition )->setField( 'link_order',$_POST['link_order'] );
	        if( $result ){
				actionLog( '排序更新成功','排序','Links/changeOrder',$_SESSION['auth']['username'] );
	            $data = array(
	                'code' => '0',
	                'msg' => '分类排序更新成功',
	            );
	        }else{
	            $data = array(
	                'code' => '1',
	                'msg' => '分类排序更新失败',
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
}