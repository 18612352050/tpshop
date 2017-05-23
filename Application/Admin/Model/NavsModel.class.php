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
class NavsModel extends Model{

	protected $tableName = 'navs';


	/**
	 * 保存到数据库
	 * @return mixed
	 */
	public function storeNav(){
		$validate = array(
			array( 'nav_pid','require','请选择导航分级' ),
            array( 'nav_name','require','导航名必须填写' ),
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

	/**
	 * 更新数据库
	 * @return bool
	 */
	public function saveNav(){
		$validate = array(
			array( 'nav_pid','require','请选择导航分级' ),
            array( 'nav_name','require','导航名必须填写' ),
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

	/**
	 * 删除导航
	 * @return mixed
	 */
	public function delNav(){
		$post = $_POST;
		if( $res = $this->delete( $post['nav_id'] ) ){
			return $res;
		}else{
			$this->error = "删除失败";
		}
	}
}