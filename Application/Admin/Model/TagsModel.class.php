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
class TagsModel extends Model{

	protected $tableName = 'Tags';


	/**
	 * 保存到数据库
	 * @return mixed
	 */
	public function storeTag(){
		$validate = array(
			array( 'tag_pid','require','请选择导航分级' ),
            array( 'tag_name','require','导航名必须填写' ),
		);
		$post = $_POST;
		if( empty( $post['tag_order'] ) ){
			$post['tag_order'] = 0;
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
	public function saveTag(){
		$validate = array(
			array( 'tag_pid','require','请选择导航分级' ),
            array( 'tag_name','require','导航名必须填写' ),
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
	public function delTag(){
		$post = $_POST;
		if( $res = $this->delete( $post['tag_id'] ) ){
			return $res;
		}else{
			$this->error = "删除失败";
		}
	}
}