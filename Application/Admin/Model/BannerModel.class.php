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
class BannerModel extends Model{

	#指向正确表
	protected $tableName = 'banner';

	/**
	 * 入库保存
	 * @return mixed
	 */
	public function storeBanner(){
		$result = $this->checkBanFilter();
		$validate = $result['validate'];
		$post = $result['postdata'];
		if( empty( $post['ban_order'] ) ){
			$post['ban_order'] = 0;
		}
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
	 * 更新保存
	 * @return bool
	 */
	public function saveBanner(){
		$result = $this->checkBanFilter();
		$validate = $result['validate'];//验证数据
		$post = $result['postdata'];//编辑后的数据
		$thumbpath = $result['thumbpath'];//旧图路径
		if( $this->validate( $validate )->create( $post ) ){
			$res = $this->save($post);
			if( $res ){
				if( !empty( $thumbpath ) ) @unlink('.' . $thumbpath);
				return $res;
			}else if( $this->save($post) == '0'){
				$this->error = "没有内容更新,请修改或者会到列表页";
			}else{
				$this->error = "修改失败";
			}
		}else{
			$this->error = $this->getError();
		}
	}

	/**
	 * 删除banner
	 * @return mixed
	 */
	public function delBanner(){
		$post = $_POST;
		$arr = $this->field( 'ban_url,ban_w_link' )->find( $post['ban_id'] );
		if( $res = $this->delete( $post['ban_id'] ) ){
			if( !empty( $arr['ban_url'] ) ) @unlink('.' . $arr['ban_url']);
			// if( !empty( $arr['ban_w_link'] ) ) @unlink('.' . $arr['ban_w_link']);
			return $res;
		}else{
			$this->error = "删除失败";
		}
	}

	/**
	 * 检查ban入库与更新
	 * @return array		返回验证数组，处理好的表单数组
	 */
	protected function checkBanFilter() {
		$validate = array(
			array( 'ban_url','require','请上传图片' ),
		);
		$post = $_POST;
		$post['ban_url'] = ( isset( $post['ban_url'] ) || !empty( $post['ban_url'] ) ) ? $post['ban_url'] : '/Public/default.png';
		//有主键的post数据为更新， 无主键的为新增，新增是不会进入此判断
		if( isset( $post[ 'ban_id' ] ) ){
			$tmpstr = $this->getFieldByBanId( $post[ 'ban_id' ],'ban_url' );
			$tmp = pathinfo( $tmpstr );
			$postThumb = pathinfo( $post['ban_url'] );
			//更新的封面图名字不等于默认图片名字，不等于旧的封面图
			if( $tmp['filename'] != 'default' && $tmp['filename'] != $postThumb['filename'] ) $thumbpath = $tmpstr;
		}
		return array( 'validate'=>$validate,'postdata'=>$post,'thumbpath'=>$thumbpath );
	}
}
