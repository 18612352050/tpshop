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
class BannerController extends AuthController{

	protected $bannerObj;

	public function __construct(){
		parent::__construct();
		$this->bannerObj = D( 'banner' );
	}

	/**
	 * [bannerlist banner列表]
	 * @return [type] [description]
	 */
	public function bannerlist(){
		$navObj = M( 'navs' );
		$this->navs = $navObj->select();
		$this->banners = $this->bannerObj->order( 'ban_order asc' )->select();
		actionLog( '查看banner列表','banner列表','bannerlist',$_SESSION['auth']['username'] );
		$this->display( 'Banner/bannerlist' );
	}

	/**
	 * [addbanner 添加banner]
	 * @return [type] [description]
	 */
	public function addbanner(){
		if( !empty($_POST) ){
			if($this->bannerObj->storeBanner()){
				actionLog( '添加新Banner','添加banner','addbanner',$_SESSION['auth']['username'] );
				$this->success( '添加成功',U( 'Banner/bannerlist' ) );
			}else{
				#actionLog( $this->bannerObj->getError(),'添加banner','addbanner',$_SESSION['auth']['username'] );
				$this->error( $this->bannerObj->getError() );
			}
		}else{
			// $navObj = M( 'navs' );
			// $cateObj = M( 'category' );
			// $this->cate = $cateObj->select();
			// $this->navs = $navObj->select();
			$this->display( 'Banner/addbanner' );
		}

	}

	/**
	 * [editbanner 编辑banner]
	 * @return [type] [description]
	 */
	public function editbanner(){
		if( !empty( $_POST ) ){
			if($this->bannerObj->saveBanner()){
				actionLog( '编辑Banner完成','修改banner','editbanner',$_SESSION['auth']['username'] );
				$this->success( '添加成功',U( 'Banner/bannerlist' ) );
			}else{
				#actionLog( $this->bannerObj->getError(),'修改banner','editbanner',$_SESSION['auth']['username'] );
				$this->error( $this->bannerObj->getError() );
			}
		}else{
			// $navObj = M( 'navs' );
			// $this->navs = $navObj->select();
			$banid = $_GET['ban_id'];
			$this->banners = $this->bannerObj->find( $banid );
			$this->display( 'Banner/editbanner' );
		}

	}

	/**
	 * [delbanner 删除banner]
	 * @return [JSON] [description]
	 */
	public function delbanner(){
		if( !empty( $_POST ) ){
			if( $this->bannerObj->delBanner() ){
				actionLog( '删除Banner完成','删除banner','delbanner',$_SESSION['auth']['username'] );
				$this->ajaxReturn( array( 'code'=>0,'msg'=>'Banner删除成功' ) );
			}else{
				#actionLog( $this->bannerObj->getError(),'删除banner','delbanner',$_SESSION['auth']['username'] );
				$this->ajaxReturn( array( 'code'=>1,'msg'=>$this->bannerObj->getError() ) );
			}
		}else{
			#actionLog( '无效失败','修改banner','delbanner',$_SESSION['auth']['username'] );
			$this->ajaxReturn( array( 'code'=>1,'msg'=>'无效失败' ) );
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
	 * ·
	 * 添加banner判断图片格式
	 */
	public function webUpBan(){
		$imageinfo = getimagesize($_FILES['files']['tmp_name'][0]);
		if( $imageinfo[0] > 10 || $imageinfo[1] > 10 ){
			$res = array('status' => 2, 'msg' => 'banner格式请保持在：10 x 10 等比之内[测试数据，请更改数值]');
		}else{
			$res = $this->uploadFile();
		}
		$this->ajaxReturn($res);
	}

    /**
     * 编辑页伪删除源图片方法
     */
    public function deleteBanImg()
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
    public function deleteAddBanImg()
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

    /**
	 * [changeOrder 更改排序]
	 * @return [JSON] [description]
	 */
	public function changeOrder()
    {
    	if( !empty( $_POST ) ){
    		$condition = array( 'ban_id'=>$_POST['ban_id'] );
	        $result = $this->bannerObj->where( $condition )->setField( 'ban_order',$_POST['ban_order'] );
	        if( $result ){
				actionLog( '排序更新成功','排序','Banner/changeOrder',$_SESSION['auth']['username'] );
	            $data = array(
	                'code' => '0',
	                'msg' => '排序更新成功',
	            );
	        }else{
				#actionLog( '排序更新失败','排序','Banner/changeOrder',$_SESSION['auth']['username'] );
	            $data = array(
	                'code' => '1',
	                'msg' => '排序更新失败',
	            );
	        }
    	}else{
			#actionLog( '无效失败','排序','Banner/changeOrder',$_SESSION['auth']['username'] );
    		$data = array(
	                'code' => '1',
	                'msg' => '无效失败',
	            );
    	}
        $this->ajaxReturn($data);
    }
}
