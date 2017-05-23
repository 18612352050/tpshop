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
class ArticleController extends AuthController{

	protected $articleObj;

	//初始化属性
	public function __construct(){
		parent::__construct();
		$this->articleObj = D( 'Article' );
	}

	/**
	 * [articlelist 文章列表]
	 * 显示审核过的文章，暂时修改了数据库，默认是1：通过状态
	 */
	public function articlelist(){
		$cateObj = M( "Category" );
		$this->cates = $cateObj->select();
		$articles = dataPage( 'Article','art_status=1' );
		$this->list = $articles['list'];
		$this->page = $articles['page'];
		actionLog( '查看栏目列表','栏目列表','catelist',$_SESSION['auth']['username'] );#行为记录
		$this->display( "Article/articlelist" );
	}


	/**
	 * [addart 添加文章]
	 * 增加文章页和保存数据的方法
	 */
	public function addart(){
		if( !empty($_POST) ){
			if($this->articleObj->storeArt()){
				actionLog( '添加文章完成','添加文章','addart',$_SESSION['auth']['username'] );
				$this->success( '添加成功',U( 'Article/articlelist' ) );
			}else{
				#actionLog( $this->articleObj->getError(),'添加文章','addart',$_SESSION['auth']['username'] );
				$this->error( $this->articleObj->getError() );
			}
		}else{
			$cateObj = M( "Category" );
			$this->cates = $cateObj->select();
			$this->display( "Article/addart" );
		}
	}

	/**
	 * [editart 编辑文章]
	 */
	public function editart(){
		if( !empty( $_POST ) ){
			if($this->articleObj->saveArt()){
				actionLog( '编辑文章完成','编辑文章','editart',$_SESSION['auth']['username'] );
				$this->success( '修改成功',U( 'Article/articlelist' ) );
			}else{
				#actionLog( $this->articleObj->getError(),'编辑文章','editart',$_SESSION['auth']['username'] );
				$this->error( $this->articleObj->getError() );
			}
		}else{
			$cateObj = M( "Category" );
			$this->cates = $cateObj->select();
			$artid = $_GET['art_id'];
			$this->art = $this->articleObj->find( $artid );
			$this->display( "Article/editart" );
		}

	}

	/**
	 * [delart 删除文章]
	 * @return [JSON] [返回提示信息失败或者成功]
	 */
	public function delart(){
		if( !empty( $_POST ) ){
			if( $this->articleObj->delArt() ){
				actionLog( '删除文章完成','删除文章','delart',$_SESSION['auth']['username'] );
				$this->ajaxReturn( array( 'code'=>0,'msg'=>'文章删除成功' ) );
			}else{
				#actionLog( $this->CategoryObj->getError(),'删除文章','delart',$_SESSION['auth']['username'] );
				$this->ajaxReturn( array( 'code'=>1,'msg'=>$this->articleObj->getError() ) );
			}
		}else{
			#actionLog( '无效操作','删除文章','delart',$_SESSION['auth']['username'] );
			$this->ajaxReturn( array( 'code'=>1,'msg'=>'无效操作' ) );
		}
	}

	/**
	 * 上传方法
	 */
	public function uploadFile()
	{
		// 实例化上传类
		$upload = new \Think\Upload();
		// 设置附件上传大小     PHP配置文件限定(upload_max_filesize = 2M)
		$upload->maxSize = 3145728;
		// 设置附件上传类型
		$upload->exts = array('jpg', 'gif', 'png', 'jpeg');
		// 设置附件上传目录
		$upload->savePath = '/Uploads/';
		//文件上传保存的根路径 (必写)
		$upload->rootPath = './Public';
		// 执行上传文件
		$info = $upload->upload();

		$fileName = trim($upload->rootPath, '.') . $info[0]['savepath'] . $info[0]['savename'];

		$res = array('status' => 1, 'datas' => $fileName);

		return $res;
	}

	/**
	 * 添加文章页判断图片格式
	 */
	public function artUpCover(){
		$imageinfo = getimagesize($_FILES['files']['tmp_name'][0]);
		if( $imageinfo[0] > 10 || $imageinfo[1] > 10 ){
			$res = array('status' => 2, 'msg' => '视角文章封面图片格式请保持在：10 x 10 之内【具体网站自行定规格】');
		}else{
			$res = $this->uploadFile();
		}
		$this->ajaxReturn($res);
	}


	/**
     * 编辑页伪删除源图片方法
     */
    public function deleteArtImg()
    {
        #获取图片路径
        if ($_POST['pic'])
        {
			$pathinfo = pathinfo( $_POST['pic'] );//判断封面是否默认图片
			if( $pathinfo['filename'] != 'default' ){
				$data = array('code' => 1);
			}else{
				$data = array('code' => 2);
			}
			$this->ajaxReturn($data);
        }

    }

	/**
     * 添加页删除源图片方法
     */
    public function deleteAddArtImg()
    {
        #获取图片路径
        if ($_POST['pic'])
        {
			$id = $_POST['pic'];
           	@unlink('.' . $id);
           	$data = array('code' => 1);
            $this->ajaxReturn($data);
        }
    }

}