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
class LinksModel extends Model{

	protected $tableName = "links";


	public function storeLink(){
		$validate = array(
            array( 'link_name','require','友情连接名需要填写' ),
            array( 'link_url','require','友情连接地址需要填写' ),
		);
		$post = $_POST;
		if( empty( $post['nav_order'] ) ){
			$post['nav_order'] = 0;
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


	public function saveLink(){
		$validate = array(
            array( 'link_name','require','友情连接名需要填写' ),
            array( 'link_url','require','友情连接地址需要填写' ),
		);
		$post = $_POST;
		if( $this->validate( $validate )->create( $post ) ){
			if( $res = $this->save($post)){
				return $res;
			}else{
				$this->error = "修改失败";
			}
		}else{
			exit($this->getError());
		}
	}


	public function delLink(){
		$post = $_POST;
		if( $res = $this->delete( $post['link_id'] ) ){
			return $res;
		}else{
			$this->error = "删除失败";
		}
	}
}