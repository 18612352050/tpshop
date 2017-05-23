<?php
# +----------------------------------------------------------------
# | Thinker [ Thinkers Ideas also ]
# +----------------------------------------------------------------
# | Copyright (c) 2016 http://www.thinkerpr.com All right reserved
# +----------------------------------------------------------------
# | Author： KwongYanChan <chen.g.e@foxmail.com>
# +----------------------------------------------------------------
namespace Admin\Controller;
//use Think\Controller;
class GroupController extends AuthController{

	/**
	 * 权限列表
	 */
    public function grouplist(){
        $authGroup = M('auth_group')->select();
        $this->groups = $authGroup;
		actionLog( '查看权限组列表','权限组列表','grouplist',$_SESSION['auth']['username'] );#行为记录
        $this->display( "Group/grouplist" );
    }


	/**
	 * 权限管理--【添加权限】功能
	 */
    public function addrule(){
        if( IS_AJAX ){
            $validate = array(
                array( 'name','require','控/方不能为空' ),
                array( 'title','require','名称不能为空' ),
            );
            $post = $_POST;
            $post['create_time'] = time();
            if( M('auth_rule')->validate( $validate )->create( $post ) ){
                if( M('auth_rule')->add() ){
					actionLog( '添加权限成功','添加权限','Group/addrule',$_SESSION['auth']['username'] );#行为记录
                    $this->ajaxReturn( array( 'code'=>0,'msg'=>'添加权限成功' ) );
                }else{
                    $this->ajaxReturn( array( 'code'=>1,'msg'=>'添加权限失败' ) );
                }
            }
        }else{
			$this->parentRules = M( "auth_rule" )->where( array( 'rule_pid'=>'0' ) )->select();
			$this->rules = $this->tree();
            $this->display( "Group/addrule" );
        }
    }

	/**
	 * 权限管理--【修改】功能
	 */
	public function editRule(){
		if( IS_POST ){
			$validate = array(
				array( 'id','require','没有更新条件' ),
                array( 'title','require','用户组名字不能为空' ),
                array( 'name','require','请选择权限' ),
            );
			if( $_POST['old_rule_pid'] == '0' ) $this->error( '顶级分类不能更，请更改它子菜单' );
			$post['id'] = $_POST['id'];
			$post['title'] = $_POST['title'];
			$post['name'] = $_POST['name'];
			$post['rule_pid'] = $_POST['rule_pid'];
//			dd(M( "auth_rule" )->validate( $validate )->create( $post ));exit;
			if( M( "auth_rule" )->validate( $validate )->create( $post ) ){
				if( M( "auth_rule" )->save( $post ) ){
					actionLog( '更新权限信息成功','修改权限','Group/editRule',$_SESSION['auth']['username'] );#行为记录
					$this->success( '更新成功',U( 'Group/addrule' ) );
				}else{
					$this->error( '网络错误' );
				}
			}else{
				$this->error( $this->getError() );
			}
		}else{
			if( !isset( $_GET['rule_id'] ) ) $this->error( "没有此权限信息" );
			$this->ruleinfo = M( "auth_rule" )->find( $_GET['rule_id'] );
			$this->parentRules = M( "auth_rule" )->where( array( 'rule_pid'=>'0') )->order( "id ASC" )->select();
			$this->display();
		}

	}

	/**
	 * 权限管理--【删除】功能
	 */
    public function delRule(){
        if( !empty( $_POST['id'] ) ){
			#判断是否有下级子菜单权限
			$data = M( 'auth_rule' )->where( array( 'rule_pid'=>$_POST['id'] ) )->select();
			#有下级菜单就返回给用户信息
			if( !empty( $data ) ) $this->ajaxReturn( array( 'code'=>1,'msg'=>'请先删除该权限下的子权限，才能删除此权限' ) );
			#检查结果
            $res = M( 'auth_rule' )->delete( $_POST['id'] );
            if( $res ){
				actionLog( '权限删除成功','删除权限','Group/delRule',$_SESSION['auth']['username'] );#行为记录
                $this->ajaxReturn( array( 'code'=>0,'msg'=>'权限删除成功' ) );
            }else{
                $this->ajaxReturn( array( 'code'=>1,'msg'=>'权限删除失败' ) );
            }
        }else{
            $this->ajaxReturn( array( 'code'=>1,'msg'=>'无效失败' ) );
        }
    }



    /**
     * 获取权限列表数据异步返回
     */
    public function getListGroup() {
        $id = I('get.group_id');
        $list = M('auth_group')->find($id);
        $tmp = explode(',',$list['rules']);
        foreach($tmp as $t){
            $rule = M('auth_rule')->find($t);
            $groupRule[] = $rule;
        }
        $this->assign('rule',$groupRule);
        $this->display( "Group/getlistgroup" );
    }



    /**
     * 用户权限组---添加用户组
     */
    public function addRuleGroup(){
        if( IS_POST ){
            if( empty( $_POST['title'] ) ) $this->error( '用户组不能为空' );

            $data['title'] = $_POST['title'];
            $data['addtime'] = time();
            if( M('auth_group')->create( $data ) ){
                if( M('auth_group')->add( $data ) ){
					actionLog( '添加成功','添加用户组','Group/addRuleGroup',$_SESSION['auth']['username'] );#行为记录
                    $this->success('添加成功',U( 'Group/grouplist' ));
                }else{
                    $this->success('操作失败');
                }
            }
        }else{
            $this->display( 'Group/addrulegroup' );
        }
    }

	/**
	 * 用户权限组列表---【设置】功能
	 */
	public function setGroup(){
		if( IS_POST ){
			$validate = array(
				array( 'id','require','没有更新条件' ),
                array( 'title','require','用户组名字不能为空' ),
                array( 'rules','require','请选择权限' ),
            );

			$post['id'] = $_POST['group_id'];
			$post['title'] = $_POST['title'];
			$post['rules'] = trim( implode( ',',$_POST['rule_id'] ) );
			$post['edittime'] = time();
			if( M( "auth_group" )->validate( $validate )->create( $post ) ){
				if( M( "auth_group" )->save( $post ) ){
					actionLog( '设置成功','设置权限','Group/setGroup',$_SESSION['auth']['username'] );#行为记录
					$this->success( '更新成功',U( 'Group/grouplist' ) );
				}else{
					$this->error( '网络错误' );
				}
			}else{
				$this->error( $this->getError() );
			}
		}else{
			if( !isset( $_GET['group_id'] ) ) $this->error( "没有用户组信息" );
			$groupinfo = M( "auth_group" )->find( $_GET['group_id'] );
			$groupinfo['rules'] = explode( ',',$groupinfo['rules'] );
			$this->groupinfo = $groupinfo;
			$this->parentRules = M( "auth_rule" )->where( array( 'rule_pid'=>'0') )->order( "id ASC" )->select();
			$this->rules = M( "auth_rule" )->where( array( 'rule_pid'=>array( 'neq','0' )) )->order( "id ASC" )->select();
			$this->display( 'Group/setgroup' );
		}

	}

	/**
	 * 用户权限组列表---【修改】功能
	 */
	public function editGroup(){
		if( IS_POST ){
			$validate = array(
				array( 'id','require','没有更新条件' ),
                array( 'title','require','用户组名字不能为空' ),
            );
			$post['id'] = $_POST['group_id'];
			$post['title'] = $_POST['title'];
			$post['edittime'] = time();
			if( M( "auth_group" )->validate( $validate )->create( $post ) ){
				if( M( "auth_group" )->save( $post ) ){
					actionLog( '更新成功','修改权限','Group/editGroup',$_SESSION['auth']['username'] );#行为记录
					$this->success( '更新成功',U( 'Group/grouplist' ) );
				}else{
					$this->error( '网络错误' );
				}
			}else{
				$this->error( $this->getError() );
			}
		}else{
			if( !isset( $_GET['group_id'] ) ) $this->error( "没有用户组信息" );
			$this->groupinfo = M( "auth_group" )->find( $_GET['group_id'] );
			$this->display();
		}
	}

	/**
	 * 用户权限组列表---【删除】功能
	 * 异步处理，同时删除拥有这个用户组的用户
	 */
    public function delGroup(){
        if( !empty( $_POST['id'] ) ){
            $res = M( 'auth_group' )->delete( $_POST['id'] );
            if( $res ){
                M( 'auth_group_access' )->where( array( 'group_id'=>$_POST['id'] ) )->delete();
				actionLog( '权限组删除成功','删除权限组','Group/delGroup',$_SESSION['auth']['username'] );#行为记录
                $this->ajaxReturn( array( 'code'=>0,'msg'=>'权限删除成功' ) );
            }else{
                $this->ajaxReturn( array( 'code'=>1,'msg'=>'权限删除失败' ) );
            }
        }else{
            $this->ajaxReturn( array( 'code'=>1,'msg'=>'无效失败' ) );
        }
    }


	/**
	 * 获取树形，返回分类级
	 * @return array
	 */
	public function tree( ){
		$data = M( "auth_rule" )->order( 'rule_order ASC' )->select();
		return $this->getTree( $data,'title','id','rule_pid' );
	}
	/**
	 * @param $data                 需要分类的数据
	 * @param $cateName             需要分类的字段
	 * @param string $cateId        id字段
	 * @param string $catePid       父级ID
	 * @param string $pid           初始化父级ID
	 * @return array                返回数组
	 */
	protected function getTree($data,$cateName,$cateId = 'id',$catePid = 'pid',$pid = '0'){
		$arr = array();
		foreach( $data as $k=>$v ){
			if( $v[$catePid] == $pid ){
				$data[$k]['_'.$cateName] = $data[$k][$cateName];
				$arr[] = $data[$k];
				foreach( $data as $m=>$n ){
					if( $n[$catePid] == $v[$cateId] ){
						$data[$m]['_'.$cateName] = '&nbsp;&nbsp;&nbsp;|-- '.$data[$m][$cateName];
						$arr[] = $data[$m];
					}
				}
			}
		}
		return $arr;
	}


	/**
     * [changeOrder 更改排序]
     * 更改权限组排序
     * @return [JSON] [description]
     */
    public function changeOrder()
    {
        if( !empty( $_POST ) ){
            $condition = array( 'id'=>$_POST['id'] );
            $result = M('auth_rule')->where( $condition )->setField( 'rule_order',$_POST['rule_order'] );
            if( $result ){
				actionLog( '排序更新成功','更改排序','Group/changeOrder',$_SESSION['auth']['username'] );#行为记录
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