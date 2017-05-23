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
class HelpController extends AuthController{

	protected $HelpObj;

	//初始化属性
	public function __construct(){
		parent::__construct();
		$this->HelpObj = D( 'Help' );
	}

	/**
	 * [Helplist 帮助中心文章列表]
	 * 显示审核过的帮助中心文章，暂时修改了数据库，默认是1：通过状态
	 */
	public function Helplist(){
		$cateObj = D( "HelpCate" );
		$this->cates = $cateObj->select();
		$Helps = dataPage( 'Help','art_status=1' );
		$this->list = $Helps['list'];
		$this->page = $Helps['page'];
		$this->display( "Help/articlelist" );
	}


	/**
	 * [addart 添加帮助中心文章]
	 * 增加帮助中心文章页和保存数据的方法
	 */
	public function addart(){
		if( !empty($_POST) ){
			if($this->HelpObj->storeArt()){
				actionLog( '添加帮助中心文章完成','添加帮助中心文章','addart',$_SESSION['auth']['username'] );
				$this->success( '添加成功',U( 'Help/Helplist' ) );
			}else{
				#actionLog( $this->HelpObj->getError(),'添加帮助中心文章','addart',$_SESSION['auth']['username'] );
				$this->error( $this->HelpObj->getError() );
			}
		}else{
			$cateObj = D( "HelpCate" );
			$this->cates = $cateObj->select();
			$this->display( "Help/addart" );
		}
	}

	/**
	 * [editart 编辑帮助中心文章]
	 */
	public function editart(){
		if( !empty( $_POST ) ){
			if($this->HelpObj->saveArt()){
				actionLog( '编辑帮助中心文章完成','编辑帮助中心文章','editart',$_SESSION['auth']['username'] );
				$this->success( '修改成功',U( 'Help/Helplist' ) );
			}else{
				#actionLog( $this->HelpObj->getError(),'编辑帮助中心文章','editart',$_SESSION['auth']['username'] );
				$this->error( $this->HelpObj->getError() );
			}
		}else{
			$cateObj = D( "HelpCate" );
			$this->cates = $cateObj->select();
			$artid = $_GET['art_id'];
			$this->art = $this->HelpObj->find( $artid );
			$this->display( "Help/editart" );
		}

	}

	/**
	 * [delart 删除帮助中心文章]
	 * @return [JSON] [返回提示信息失败或者成功]
	 */
	public function delart(){
		if( !empty( $_POST ) ){
			if( $this->HelpObj->delArt() ){
				actionLog( '删除帮助中心文章完成','删除帮助中心文章','delart',$_SESSION['auth']['username'] );
				$this->ajaxReturn( array( 'code'=>0,'msg'=>'帮助中心文章删除成功' ) );
			}else{
				$this->ajaxReturn( array( 'code'=>1,'msg'=>$this->HelpObj->getError() ) );
			}
		}else{
			#actionLog( '无效操作','删除帮助中心文章','delart',$_SESSION['auth']['username'] );
			$this->ajaxReturn( array( 'code'=>1,'msg'=>'无效操作' ) );
		}
	}
}