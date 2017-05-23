<?php
# +----------------------------------------------------------------
# | Thinker [ Thinkers Ideas also ]
# +----------------------------------------------------------------
# | Copyright (c) 2016 http://www.thinkerpr.com All right reserved
# +----------------------------------------------------------------
# | Author： Yanzhijia <yzj910420@163.com>
# +----------------------------------------------------------------
namespace Admin\Model;

use Think\Model;
class HelpModel extends Model{

	/**
	 * 确定具体表，否则就默认按类名取表名
	 * @var string
	 */
	protected $tableName = 'help';

	/**
	 * 新增普通文章保存
	 * @return mixed
	 */
	public function storeArt(){
		$result = $this->checkFilter();
		$validate = $result['validate'];
		$post = $result['postdata'];
		if( $this->validate( $validate )->create( $post ) ){
			if( $res = $this->add($post)){
				return $res;
			}else{
				$this->error = "添加失败";
			}
		}else{
			$this->error = $this->getError();
		}
	}

	/**
	 * 编辑文章保存
	 * @return bool
	 */
	public function saveArt(){
		$result = $this->checkFilter();
		$validate = $result['validate'];//验证数据
		$post = $result['postdata'];//编辑后的数据
		$thumbpath = $result['thumbpath'];//旧图路径
		if( $this->validate( $validate )->create( $post ) ){
			$res = $this->save($post);
			if( $res ){
				if( !empty( $thumbpath ) ) @unlink('.' . $thumbpath);
				return $res;
			}else if( $res == '0'){
				$this->error = "没有内容更新,请修改或者会到列表页";
			}else{
				$this->error = "修改失败";
			}
		}else{
			$this->error = $this->getError();
		}
	}

	/**
	 * 删除文章
	 * @return mixed
	 */
	public function delArt(){
		$post = $_POST;
		if( $res = $this->delete( $post['art_id'] ) ){
			return $res;
		}else{
			$this->error = "删除失败";
		}
	}

	/**
	 * @return array		返回验证数组，处理好的表单数组
	 */
	protected function checkFilter(){
		$validate = array(
			array( 'cate_id','require','文章所属栏目必须选择' ),
			array( 'art_title','require','文章标题必须填写' ),
		);
		$post = $_POST;
		if( !$post['art_time'] ){
			$post['art_time'] = time();
		}
		$post[ 'cate_pid' ] = M( 'Category' )->getFieldByCateId( $post[ 'cate_id' ],'cate_pid' );//栏目的父级
		return array( 'validate'=>$validate,'postdata'=>$post);
	}
}