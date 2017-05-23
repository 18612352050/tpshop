<?php
# +----------------------------------------------------------------
# | Thinker [ Thinkers Ideas also ]
# +----------------------------------------------------------------
# | Copyright (c) 2016 http://www.thinkerpr.com All right reserved
# +----------------------------------------------------------------
# | Author： KwongYanChan <chen.g.e@foxmail.com>
# +----------------------------------------------------------------
namespace Admin\Model;
use Think\Model;
class HelpCateModel extends Model{

	protected $tableName = 'helpcate';

	/**
	 * 入库验证
	 * @return mixed
	 */
	public function storeCate(){
		$validate = array(
			array( 'cate_pid','require','栏目分级必须选择' ),
            array( 'cate_name','require','栏目名必须填写' ),
		);
		$post = $_POST;
		if( empty( $post['cate_order'] ) ){
			$post['cate_order'] = 0;
		}
		if( $this->validate( $validate )->create( $post ) ){
			if( $res = $this->add($post)){
				return $res;
			}else{
				$this->error = "添加失败";
			}
		}else{
			exit($this->getError());
		}
	}

	/**
	 * 更新验证
	 * @return bool
	 */
	public function saveCate(){
		$validate = array(
			array( 'cate_pid','require','栏目分级必须选择' ),
            array( 'cate_name','require','栏目名必须填写' ),
		);
		$post = $_POST;
		if( $this->validate( $validate )->create( $post ) ){
			$res = $this->save($post);
			if( $res ){
				return $res;
			}else if( $res == '0'){
				$this->error = "没有内容更新,请修改或者会到列表页";
			}else{
				$this->error = "修改失败";
			}
		}else{
			exit($this->getError());
		}
	}

	/**
	 * 删除栏目
	 * @return mixed
	 */
	public function delCate(){
		$post = $_POST;
		if ( !empty( $post['cate_id'] ) ) {
			#首先检查有没有子级栏目
			$cateinfo = M( "Category" )->where( array( 'cate_pid'=> $post['cate_id'] ) )->select();
			if ( !empty( $cateinfo ) ) {
				$this->error = "存在子级栏目，请先删除子级栏目，在删除本栏目";
				return false;
			}
			#再次检查有无文章
			$artinfo = M( "Article" )->where( "cate_id=" .$post['cate_id'] . " OR cate_pid=" .$post['cate_id']  )->select();
			if ( !empty( $artinfo ) ) {
				$this->error = "栏目下存在文章，删除栏目会导致文章不显示，请编辑移动文章后再删除栏目";
				return false;
			}
			#删除
			if( $res = $this->delete( $post['cate_id'] ) ){
				return $res;
			}else{
				$this->error = "删除失败";
			}
		} else {
			$this->error = "参数错误";
		}
	}
}
