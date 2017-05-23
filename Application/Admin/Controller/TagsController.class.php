<?php
# +----------------------------------------------------------------
# | Thinker [ Thinkers Ideas also ]
# +----------------------------------------------------------------
# | Copyright (c) 2016 http://www.thinkerpr.com All right reserved
# +----------------------------------------------------------------
# | Author： Yanzhijia <yzj910420@163.com>
# +----------------------------------------------------------------
namespace Admin\Controller;

// use Think\Controller;
class TagsController extends AuthController{
	protected $tagObj;

	#初始化属性
	public function __construct(){
		parent::__construct();
		$this->tagObj = D( 'Tags' );
	}

	/**
	 * [taglist 标签首页]
	 */
	public function taglist(){
		$this->tags = $this->tagObj->order('tag_order asc')->select();
		actionLog( '查看标签列表','标签列表','taglist',$_SESSION['auth']['username'] );
		$this->display( 'Tags/taglist' );
	}

	/**
	 * [addtag 添加标签]
	 */
	public function addtag(){
		if( !empty( $_POST ) ){
			if($this->tagObj->storeTag()){
				actionLog( '成功增加标签','添加标签','addtag',$_SESSION['auth']['username'] );
				$this->success( '添加成功',U( 'Tags/taglist' ) );
			}else{
				$this->error( $this->getError() );
			}
		}else{
			$this->display( 'Tags/addtag' );
		}

	}

	/**
	 * [edittag 编辑标签]
	 */
	public function edittag(){
		if( !empty( $_POST ) ){
			if($this->tagObj->saveTag()){
				actionLog( '编辑标签信息','编辑标签','edittag',$_SESSION['auth']['username'] );
				$this->success( '修改成功',U( 'Tags/taglist' ) );
			}else{
				$this->error( $this->getError() );
			}
		}else{
			$tagid = $_GET['tag_id'];
			$this->tag = $this->tagObj->find( $tagid );
			$this->display( 'Tags/edittag' );
		}

	}

	/**
	 * [delTag 删除标签]
	 * @return [JSON] [description]
	 */
	public function deltag(){
		if( !empty( $_POST ) ){
			if( $this->tagObj->delTag() ){
				actionLog( '删除标签成功','删除标签','deltag',$_SESSION['auth']['username'] );
				$this->ajaxReturn( array( 'code'=>0,'msg'=>'标签删除成功' ) );
			}else{
				$this->ajaxReturn( array( 'code'=>1,'msg'=>$this->tagObj->getError() ) );
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
    		$condition = array( 'tag_id'=>$_POST['tag_id'] );
	        $result = $this->tagObj->where( $condition )->setField( 'tag_order',$_POST['tag_order'] );
	        if( $result ){
				actionLog( '排序更新成功','排序','Tags/changeOrder',$_SESSION['auth']['username'] );
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
}