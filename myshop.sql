/*
Navicat MySQL Data Transfer

Source Server         : 127.0.0.1
Source Server Version : 50553
Source Host           : localhost:3306
Source Database       : myshop

Target Server Type    : MYSQL
Target Server Version : 50553
File Encoding         : 65001

Date: 2017-05-23 09:37:15
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for cms_admin
-- ----------------------------
DROP TABLE IF EXISTS `cms_admin`;
CREATE TABLE `cms_admin` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '表主键',
  `username` varchar(50) DEFAULT NULL COMMENT '用户名',
  `password` varchar(50) DEFAULT NULL COMMENT '密码',
  `createtime` int(11) DEFAULT NULL COMMENT '创建时间',
  `changetime` int(11) DEFAULT NULL COMMENT '更改密码时间',
  `operator` varchar(50) DEFAULT NULL COMMENT '操作人',
  `login_time` int(11) DEFAULT NULL,
  `login_ip` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='后台管理员表';

-- ----------------------------
-- Records of cms_admin
-- ----------------------------
INSERT INTO `cms_admin` VALUES ('1', 'admin', 'd4b8c8a925f5bdc966de28cfcdfb81ea', '0', '0', '', '1495446661', '127.0.0.1');
INSERT INTO `cms_admin` VALUES ('3', 'pubadmin', 'e10adc3949ba59abbe56e057f20f883e', '1479795739', null, 'admin', '1479798335', '127.0.0.1');

-- ----------------------------
-- Table structure for cms_article
-- ----------------------------
DROP TABLE IF EXISTS `cms_article`;
CREATE TABLE `cms_article` (
  `art_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '文章表主键',
  `art_title` varchar(100) DEFAULT NULL COMMENT '文章标题',
  `art_keywords` varchar(100) DEFAULT NULL COMMENT '文章标签/关键词',
  `art_description` varchar(255) DEFAULT NULL COMMENT '文章描述',
  `art_thumb` varchar(255) DEFAULT NULL COMMENT '缩略图',
  `art_content` text COMMENT '文章内容',
  `art_time` int(11) DEFAULT NULL COMMENT '时间',
  `art_editor` varchar(50) DEFAULT NULL COMMENT '作者',
  `art_view` int(11) DEFAULT '0' COMMENT '查看次数',
  `cate_id` int(11) DEFAULT NULL,
  `cate_pid` int(11) DEFAULT '0' COMMENT '文章栏目属于的父栏目',
  `art_status` tinyint(4) DEFAULT '1' COMMENT '0：未审核，1：审核',
  `art_audit_time` int(10) DEFAULT NULL COMMENT '审核时间',
  `art_auditor` varchar(50) DEFAULT NULL COMMENT '审核人',
  PRIMARY KEY (`art_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='文章';

-- ----------------------------
-- Records of cms_article
-- ----------------------------
INSERT INTO `cms_article` VALUES ('1', '1231', '', '', '/Public/default.png', null, '1479802671', '', '0', '1', '0', '1', null, null);

-- ----------------------------
-- Table structure for cms_auth_group
-- ----------------------------
DROP TABLE IF EXISTS `cms_auth_group`;
CREATE TABLE `cms_auth_group` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` char(100) NOT NULL DEFAULT '' COMMENT '用户组中文名称',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '为1正常，为0禁用',
  `rules` varchar(255) NOT NULL DEFAULT '' COMMENT '用户组拥有的规则id，多个规则","隔开',
  `addtime` int(10) DEFAULT NULL COMMENT '添加时间',
  `edittime` int(10) DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='用户组表';

-- ----------------------------
-- Records of cms_auth_group
-- ----------------------------
INSERT INTO `cms_auth_group` VALUES ('1', '后台管理员', '1', '11,12', '1479786374', '1479798059');

-- ----------------------------
-- Table structure for cms_auth_group_access
-- ----------------------------
DROP TABLE IF EXISTS `cms_auth_group_access`;
CREATE TABLE `cms_auth_group_access` (
  `uid` mediumint(8) unsigned NOT NULL COMMENT '后台用户id',
  `group_id` mediumint(8) unsigned NOT NULL COMMENT '规则组【用户组】 id',
  UNIQUE KEY `uid_group_id` (`uid`,`group_id`),
  KEY `uid` (`uid`),
  KEY `group_id` (`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='用户组明细表';

-- ----------------------------
-- Records of cms_auth_group_access
-- ----------------------------
INSERT INTO `cms_auth_group_access` VALUES ('3', '1');

-- ----------------------------
-- Table structure for cms_auth_rule
-- ----------------------------
DROP TABLE IF EXISTS `cms_auth_rule`;
CREATE TABLE `cms_auth_rule` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT COMMENT '规则表主键',
  `name` char(80) NOT NULL DEFAULT '' COMMENT '规则唯一标识',
  `title` char(20) NOT NULL DEFAULT '' COMMENT '规则中文名称',
  `type` tinyint(1) NOT NULL DEFAULT '1',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '为1正常，为0禁用',
  `condition` char(100) NOT NULL DEFAULT '' COMMENT '规则表达式，为空表示存在就验证，不为空表示按照条件验证',
  `rule_type_id` tinyint(4) NOT NULL DEFAULT '0' COMMENT '【此字段不用】0：后台常规节点，1：内容管理节点，2：前台用户节点，3：问答节点，4：系统设置节点',
  `rule_pid` tinyint(4) DEFAULT NULL COMMENT '分级',
  `rule_order` int(10) DEFAULT '0' COMMENT '规则排序',
  `create_time` int(10) DEFAULT NULL COMMENT '规则创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=81 DEFAULT CHARSET=utf8 COMMENT='规则表';

-- ----------------------------
-- Records of cms_auth_rule
-- ----------------------------
INSERT INTO `cms_auth_rule` VALUES ('1', 'Index', '后台首页管理', '1', '1', '', '0', '0', '1', '1479785132');
INSERT INTO `cms_auth_rule` VALUES ('80', 'Admin/Index/test', 'test', '1', '1', '', '0', '1', '0', '1479808658');
INSERT INTO `cms_auth_rule` VALUES ('3', 'Navs', '导航管理', '1', '1', '', '0', '0', '3', '1479785259');
INSERT INTO `cms_auth_rule` VALUES ('4', 'Banner', 'Banner管理', '1', '1', '', '0', '0', '4', '1479785269');
INSERT INTO `cms_auth_rule` VALUES ('5', 'Category', '栏目管理', '1', '1', '', '0', '0', '5', '1479785281');
INSERT INTO `cms_auth_rule` VALUES ('6', 'Article', '文章管理', '1', '1', '', '0', '0', '6', '1479785297');
INSERT INTO `cms_auth_rule` VALUES ('7', 'Links', '友情连接管理', '1', '1', '', '0', '0', '7', '1479785349');
INSERT INTO `cms_auth_rule` VALUES ('8', 'Conf', '网站配置', '1', '1', '', '0', '0', '8', '1479785365');
INSERT INTO `cms_auth_rule` VALUES ('9', 'Auth', '权限管理', '1', '1', '', '0', '0', '9', '1479785460');
INSERT INTO `cms_auth_rule` VALUES ('10', 'Database', '数据管理', '1', '1', '', '0', '0', '10', '1479785479');
INSERT INTO `cms_auth_rule` VALUES ('11', 'Admin/Index/index', '后台首页【建议默认】', '1', '1', '', '0', '1', '0', '1479785797');
INSERT INTO `cms_auth_rule` VALUES ('12', 'Admin/Index/admininfo', '主机信息【建议默认】', '1', '1', '', '0', '1', '0', '1479785828');
INSERT INTO `cms_auth_rule` VALUES ('15', 'Admin/Navs/navlist', '导航列表', '1', '1', '', '0', '3', '0', '1479786057');
INSERT INTO `cms_auth_rule` VALUES ('16', 'Admin/Navs/addnav', '添加导航', '1', '1', '', '0', '3', '0', '1479786131');
INSERT INTO `cms_auth_rule` VALUES ('17', 'Admin/Navs/editnav', '编辑导航', '1', '1', '', '0', '3', '0', '1479786153');
INSERT INTO `cms_auth_rule` VALUES ('18', 'Admin/Navs/delnav', '删除导航【异步】', '1', '1', '', '0', '3', '0', '1479786189');
INSERT INTO `cms_auth_rule` VALUES ('19', 'Admin/Navs/changeOrder', '更改排序【异步】', '1', '1', '', '0', '3', '0', '1479786305');
INSERT INTO `cms_auth_rule` VALUES ('20', 'Admin/Banner/bannerlist', 'banner列表', '1', '1', '', '0', '4', '1', '1479786526');
INSERT INTO `cms_auth_rule` VALUES ('21', 'Admin/Banner/addbanner', '添加Banner', '1', '1', '', '0', '4', '2', '1479786589');
INSERT INTO `cms_auth_rule` VALUES ('22', 'Admin/Banner/editbanner', '编辑banner', '1', '1', '', '0', '4', '3', '1479786616');
INSERT INTO `cms_auth_rule` VALUES ('23', 'Admin/Banner/delbanner', '删除banner【异步】', '1', '1', '', '0', '4', '4', '1479786700');
INSERT INTO `cms_auth_rule` VALUES ('24', 'Admin/Banner/webUpBan', 'webUpBan【必选】', '1', '1', '', '0', '4', '7', '1479786812');
INSERT INTO `cms_auth_rule` VALUES ('25', 'Admin/Banner/deleteBanImg', '编辑页伪删除源图片【必选】', '1', '1', '', '0', '4', '8', '1479786959');
INSERT INTO `cms_auth_rule` VALUES ('26', 'Admin/Banner/deleteAddBanImg', '添加页删除源图片【必选】', '1', '1', '', '0', '4', '9', '1479787046');
INSERT INTO `cms_auth_rule` VALUES ('27', 'Admin/Banner/changeOrder', '更改排序【异步】', '1', '1', '', '0', '4', '5', '1479787110');
INSERT INTO `cms_auth_rule` VALUES ('28', 'Admin/Banner/uploadFile', 'Banner上传方法【必选】', '1', '1', '', '0', '4', '6', '1479787170');
INSERT INTO `cms_auth_rule` VALUES ('29', 'Admin/Category/catelist', '栏目列表', '1', '1', '', '0', '5', '1', '1479792830');
INSERT INTO `cms_auth_rule` VALUES ('30', 'Admin/Category/addcate', '添加栏目', '1', '1', '', '0', '5', '0', '1479792917');
INSERT INTO `cms_auth_rule` VALUES ('31', 'Admin/Category/editcate', '编辑栏目', '1', '1', '', '0', '5', '0', '1479792938');
INSERT INTO `cms_auth_rule` VALUES ('32', 'Admin/Category/delcate', '删除栏目【异步】', '1', '1', '', '0', '5', '0', '1479792976');
INSERT INTO `cms_auth_rule` VALUES ('33', 'Admin/Category/changeOrder', ' 更改排序【异步】', '1', '1', '', '0', '5', '0', '1479793089');
INSERT INTO `cms_auth_rule` VALUES ('34', 'Admin/Article/articlelist', '文章列表', '1', '1', '', '0', '6', '0', '1479793339');
INSERT INTO `cms_auth_rule` VALUES ('35', 'Admin/Article/addart', '添加文章', '1', '1', '', '0', '6', '0', '1479793442');
INSERT INTO `cms_auth_rule` VALUES ('36', 'Admin/Article/editart', '编辑文章', '1', '1', '', '0', '6', '0', '1479793467');
INSERT INTO `cms_auth_rule` VALUES ('37', 'Admin/Article/delart', '删除文章【异步】', '1', '1', '', '0', '6', '0', '1479793550');
INSERT INTO `cms_auth_rule` VALUES ('38', 'Admin/Article/artUpCover', '上传封面图【必选】', '1', '1', '', '0', '6', '0', '1479793772');
INSERT INTO `cms_auth_rule` VALUES ('39', 'Admin/Article/deleteArtImg', '编辑页伪删除源图片【必选】', '1', '1', '', '0', '6', '0', '1479793824');
INSERT INTO `cms_auth_rule` VALUES ('40', 'Admin/Article/deleteAddArtImg', '添加页删除源图片【必选】', '1', '1', '', '0', '6', '0', '1479793854');
INSERT INTO `cms_auth_rule` VALUES ('41', 'Admin/Article/uploadFile', '上传方法', '1', '1', '', '0', '6', '0', '1479793878');
INSERT INTO `cms_auth_rule` VALUES ('42', 'Admin/Links/linklist', '友情连接列表', '1', '1', '', '0', '7', '0', '1479794721');
INSERT INTO `cms_auth_rule` VALUES ('43', 'Admin/Links/addlink', '添加友情连接', '1', '1', '', '0', '7', '0', '1479794745');
INSERT INTO `cms_auth_rule` VALUES ('44', 'Admin/Links/editlink', '编辑友情连接', '1', '1', '', '0', '7', '0', '1479794790');
INSERT INTO `cms_auth_rule` VALUES ('45', 'Admin/Links/dellink', '删除友情连接【异步】', '1', '1', '', '0', '7', '0', '1479794823');
INSERT INTO `cms_auth_rule` VALUES ('46', 'Admin/Links/changeOrder', '更改排序【异步】', '1', '1', '', '0', '7', '0', '1479794895');
INSERT INTO `cms_auth_rule` VALUES ('47', 'Admin/Conf/index', '配置项列表', '1', '1', '', '0', '8', '0', '1479794945');
INSERT INTO `cms_auth_rule` VALUES ('48', 'Admin/Conf/createConf', '创建配置项', '1', '1', '', '0', '8', '0', '1479794967');
INSERT INTO `cms_auth_rule` VALUES ('49', 'Admin/Conf/destroy', '删除配置项【异步】', '1', '1', '', '0', '8', '0', '1479795032');
INSERT INTO `cms_auth_rule` VALUES ('50', 'Admin/Conf/editConf', '编辑配置项', '1', '1', '', '0', '8', '0', '1479795056');
INSERT INTO `cms_auth_rule` VALUES ('51', 'Admin/Conf/changeContent', '保存配置项', '1', '1', '', '0', '8', '0', '1479795202');
INSERT INTO `cms_auth_rule` VALUES ('52', 'Admin/Conf/putFile', '配置项写入文件【捆绑必须】', '1', '1', '', '0', '8', '0', '1479795248');
INSERT INTO `cms_auth_rule` VALUES ('53', 'Admin/Conf/loglist', '操作记录列表', '1', '1', '', '0', '8', '0', '1479795289');
INSERT INTO `cms_auth_rule` VALUES ('54', 'Admin/Admin/adminlist', '管理员列表', '1', '1', '', '0', '9', '0', '1479795337');
INSERT INTO `cms_auth_rule` VALUES ('55', 'Admin/Admin/addadmin', '添加管理员', '1', '1', '', '0', '9', '0', '1479795431');
INSERT INTO `cms_auth_rule` VALUES ('56', 'Admin/Admin/editadmin', '修改管理员信息', '1', '1', '', '0', '9', '0', '1479795601');
INSERT INTO `cms_auth_rule` VALUES ('57', 'Admin/Admin/deladmin', '删除管理员【异步】', '1', '1', '', '0', '9', '0', '1479795655');
INSERT INTO `cms_auth_rule` VALUES ('58', 'Admin/Group/grouplist', '用户组列表', '1', '1', '', '0', '9', '0', '1479795804');
INSERT INTO `cms_auth_rule` VALUES ('59', 'Admin/Group/addRuleGroup', '添加用户组', '1', '1', '', '0', '9', '0', '1479795935');
INSERT INTO `cms_auth_rule` VALUES ('60', 'Admin/Group/setGroup', '用户权限组列表【设置】', '1', '1', '', '0', '9', '0', '1479795989');
INSERT INTO `cms_auth_rule` VALUES ('61', 'Admin/Group/editGroup', '用户权限组列表【修改】', '1', '1', '', '0', '9', '0', '1479796055');
INSERT INTO `cms_auth_rule` VALUES ('62', 'Admin/Group/delGroup', '用户权限组列表【删除】', '1', '1', '', '0', '9', '0', '1479796081');
INSERT INTO `cms_auth_rule` VALUES ('63', 'Admin/Group/addrule', '权限管理【添加权限】', '1', '1', '', '0', '9', '0', '1479796183');
INSERT INTO `cms_auth_rule` VALUES ('64', 'Admin/Group/editRule', '权限管理【修改】', '1', '1', '', '0', '9', '0', '1479796212');
INSERT INTO `cms_auth_rule` VALUES ('65', 'Admin/Group/delRule', '权限管理【删除】', '1', '1', '', '0', '9', '0', '1479796278');
INSERT INTO `cms_auth_rule` VALUES ('66', 'Admin/Group/getListGroup', '获取权限列表数据【捆绑必选】', '1', '1', '', '0', '9', '0', '1479796340');
INSERT INTO `cms_auth_rule` VALUES ('67', 'Admin/Group/tree', '获取数据树形【捆绑必选】', '1', '1', '', '0', '9', '0', '1479796384');
INSERT INTO `cms_auth_rule` VALUES ('68', 'Admin/Group/getTree', '返回二级数据【捆绑必选】', '1', '1', '', '0', '9', '0', '1479796419');
INSERT INTO `cms_auth_rule` VALUES ('69', 'Admin/Group/changeOrder', '更改权限组排序【异步】', '1', '1', '', '0', '9', '0', '1479796446');
INSERT INTO `cms_auth_rule` VALUES ('70', 'Admin/DataBase/export', '数据库表列表', '1', '1', '', '0', '10', '0', '1479796521');
INSERT INTO `cms_auth_rule` VALUES ('71', 'Admin/DataBase/exportsql', '备份单表', '1', '1', '', '0', '10', '0', '1479796593');
INSERT INTO `cms_auth_rule` VALUES ('72', 'Admin/DataBase/backupSql', '备份数据库', '1', '1', '', '0', '10', '0', '1479796624');
INSERT INTO `cms_auth_rule` VALUES ('73', 'Admin/DataBase/import', '还原列表', '1', '1', '', '0', '10', '0', '1479796678');
INSERT INTO `cms_auth_rule` VALUES ('74', 'Admin/DataBase/restoreSql', '还原数据库', '1', '1', '', '0', '10', '0', '1479796775');
INSERT INTO `cms_auth_rule` VALUES ('75', 'Admin/DataBase/delsql', '删除备份', '1', '1', '', '0', '10', '0', '1479796842');
INSERT INTO `cms_auth_rule` VALUES ('76', 'Admin/Navs/tree', '获取树形数据【捆绑必选】', '1', '1', '', '0', '3', '0', '1479797596');
INSERT INTO `cms_auth_rule` VALUES ('77', 'Admin/Navs/getTree', '返回二级数据【捆绑必选】', '1', '1', '', '0', '3', '0', '1479797621');
INSERT INTO `cms_auth_rule` VALUES ('78', 'Admin/Category/tree', '获取树形数据【捆绑必选】', '1', '1', '', '0', '5', '0', '1479797826');
INSERT INTO `cms_auth_rule` VALUES ('79', 'Admin/Category/getTree', '返回二级数据【捆绑必选】', '1', '1', '', '0', '5', '0', '1479797862');

-- ----------------------------
-- Table structure for cms_banner
-- ----------------------------
DROP TABLE IF EXISTS `cms_banner`;
CREATE TABLE `cms_banner` (
  `ban_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `ban_url` varchar(255) DEFAULT NULL COMMENT '图片内部地址',
  `ban_w_link` varchar(255) DEFAULT NULL COMMENT '图片外部地址',
  `ban_status` tinyint(4) DEFAULT '0' COMMENT ' 图片状态，0：正常，1：删除',
  `ban_order` int(10) DEFAULT NULL COMMENT '排序，用于读出图片的顺序',
  `cate_id` int(10) DEFAULT NULL COMMENT 'banner属于哪个分类栏目',
  `nav_id` int(10) DEFAULT NULL COMMENT 'banner 属于哪个导航，如：首页',
  `ban_rec_link` varchar(255) DEFAULT NULL COMMENT '点击图片 跳转链接',
  `ban_title` varchar(50) DEFAULT NULL COMMENT 'banner标题',
  PRIMARY KEY (`ban_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='banner图管理';

-- ----------------------------
-- Records of cms_banner
-- ----------------------------
INSERT INTO `cms_banner` VALUES ('1', '/Public/Uploads/2016-11-22/5833fbcccdd3a.png', null, '0', '0', null, null, 'http://', '测试banner');

-- ----------------------------
-- Table structure for cms_category
-- ----------------------------
DROP TABLE IF EXISTS `cms_category`;
CREATE TABLE `cms_category` (
  `cate_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '栏目id主键',
  `cate_name` varchar(50) DEFAULT NULL COMMENT '栏目名称',
  `cate_title` varchar(255) DEFAULT NULL COMMENT '栏目标题',
  `cate_keywords` varchar(255) DEFAULT NULL COMMENT '栏目关键词',
  `cate_description` varchar(255) DEFAULT NULL COMMENT '栏目描述',
  `cate_view` int(10) DEFAULT NULL COMMENT '点击次数',
  `cate_order` tinyint(4) DEFAULT NULL COMMENT '栏目排序',
  `cate_pid` int(10) DEFAULT NULL COMMENT '估计标识',
  PRIMARY KEY (`cate_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='分类栏目';

-- ----------------------------
-- Records of cms_category
-- ----------------------------
INSERT INTO `cms_category` VALUES ('1', '顶级栏目1', null, '', '', null, '0', '0');
INSERT INTO `cms_category` VALUES ('2', '二级栏目1', null, '', '', null, '0', '1');

-- ----------------------------
-- Table structure for cms_conf
-- ----------------------------
DROP TABLE IF EXISTS `cms_conf`;
CREATE TABLE `cms_conf` (
  `conf_id` int(10) NOT NULL AUTO_INCREMENT COMMENT '系统配置id',
  `conf_title` varchar(100) DEFAULT NULL COMMENT '网站英文配置字段',
  `conf_name` varchar(50) DEFAULT NULL COMMENT '网站英文配置字段中文名',
  `field_type` varchar(30) DEFAULT NULL COMMENT '类型',
  `field_value` tinyint(4) DEFAULT NULL COMMENT '类型值',
  `conf_content` varchar(255) DEFAULT NULL COMMENT 'conf_title对应内容',
  PRIMARY KEY (`conf_id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COMMENT='网站配置';

-- ----------------------------
-- Records of cms_conf
-- ----------------------------
INSERT INTO `cms_conf` VALUES ('1', 'web_title', '网站标题', 'input', null, 'thinker_shop');
INSERT INTO `cms_conf` VALUES ('2', 'web_keywords', '网站关键词', 'input', null, 'thinker');
INSERT INTO `cms_conf` VALUES ('3', 'web_description', '网站描述', 'textarea', null, 'thinker,商城建设');
INSERT INTO `cms_conf` VALUES ('4', 'ordinary_order_time', '普通订单到期时间', 'input', null, '45');
INSERT INTO `cms_conf` VALUES ('5', 'group_order_time', '团购订单到期时间', 'input', null, '45');
INSERT INTO `cms_conf` VALUES ('6', 'panic_order_time', '抢购订单到期时间', 'input', null, '45');
INSERT INTO `cms_conf` VALUES ('7', 'icp', 'icp备案号', 'input', null, null);
INSERT INTO `cms_conf` VALUES ('8', 'icp_web', 'icp备案网址', 'input', null, null);
INSERT INTO `cms_conf` VALUES ('9', 'phone', '联系电话', 'input', null, null);
INSERT INTO `cms_conf` VALUES ('10', 'address', '联系地址', 'input', null, null);

-- ----------------------------
-- Table structure for cms_help
-- ----------------------------
DROP TABLE IF EXISTS `cms_help`;
CREATE TABLE `cms_help` (
  `art_id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '文章表主键',
  `art_title` varchar(100) DEFAULT NULL COMMENT '文章标题',
  `art_keywords` varchar(100) DEFAULT NULL COMMENT '文章标签/关键词',
  `art_description` varchar(255) DEFAULT NULL COMMENT '文章描述',
  `art_thumb` varchar(255) DEFAULT NULL COMMENT '缩略图',
  `art_content` text COMMENT '文章内容',
  `art_time` int(11) DEFAULT NULL COMMENT '时间',
  `art_editor` varchar(50) DEFAULT NULL COMMENT '作者',
  `art_view` int(11) DEFAULT '0' COMMENT '查看次数',
  `cate_id` int(11) DEFAULT NULL,
  `cate_pid` int(11) DEFAULT '0' COMMENT '文章栏目属于的父栏目',
  `art_status` tinyint(4) DEFAULT '1' COMMENT '0：未审核，1：审核',
  `art_audit_time` int(10) DEFAULT NULL COMMENT '审核时间',
  `art_auditor` varchar(50) DEFAULT NULL COMMENT '审核人',
  PRIMARY KEY (`art_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='文章';

-- ----------------------------
-- Records of cms_help
-- ----------------------------
INSERT INTO `cms_help` VALUES ('1', '1231', '', '', '/Public/default.png', null, '1479802671', '', '0', '1', '0', '1', null, null);
INSERT INTO `cms_help` VALUES ('2', '购物注册', '等等等', '事实上', null, '<p>顶顶顶顶顶顶顶顶顶多</p>', '1486958079', '星客', '0', '3', null, '1', null, null);

-- ----------------------------
-- Table structure for cms_helpcate
-- ----------------------------
DROP TABLE IF EXISTS `cms_helpcate`;
CREATE TABLE `cms_helpcate` (
  `cate_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '栏目id主键',
  `cate_name` varchar(50) DEFAULT NULL COMMENT '栏目名称',
  `cate_title` varchar(255) DEFAULT NULL COMMENT '栏目标题',
  `cate_keywords` varchar(255) DEFAULT NULL COMMENT '栏目关键词',
  `cate_description` varchar(255) DEFAULT NULL COMMENT '栏目描述',
  `cate_view` int(10) DEFAULT NULL COMMENT '点击次数',
  `cate_order` tinyint(4) DEFAULT NULL COMMENT '栏目排序',
  `cate_pid` int(10) DEFAULT NULL COMMENT '估计标识',
  PRIMARY KEY (`cate_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='分类栏目';

-- ----------------------------
-- Records of cms_helpcate
-- ----------------------------
INSERT INTO `cms_helpcate` VALUES ('1', '顶级栏目1', null, '', '', null, '0', '0');
INSERT INTO `cms_helpcate` VALUES ('2', '二级栏目1', null, '', '', null, '0', '1');
INSERT INTO `cms_helpcate` VALUES ('3', '帮助中心', null, '订单', '事实上', null, '0', '1');

-- ----------------------------
-- Table structure for cms_links
-- ----------------------------
DROP TABLE IF EXISTS `cms_links`;
CREATE TABLE `cms_links` (
  `link_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `link_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '名称',
  `link_title` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '标题',
  `link_url` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT '连接',
  `link_order` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  PRIMARY KEY (`link_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='友情链接';

-- ----------------------------
-- Records of cms_links
-- ----------------------------
INSERT INTO `cms_links` VALUES ('1', '友情连接1', '', 'http://', '0');

-- ----------------------------
-- Table structure for cms_log
-- ----------------------------
DROP TABLE IF EXISTS `cms_log`;
CREATE TABLE `cms_log` (
  `log_id` int(10) NOT NULL AUTO_INCREMENT COMMENT '日志id',
  `log_desc` text COMMENT '日志描述，JSON字符串存入',
  `log_time` int(10) DEFAULT NULL COMMENT '日志入库时间',
  PRIMARY KEY (`log_id`)
) ENGINE=MyISAM AUTO_INCREMENT=224 DEFAULT CHARSET=utf8 COMMENT='操作日志记录';

-- ----------------------------
-- Records of cms_log
-- ----------------------------
INSERT INTO `cms_log` VALUES ('1', '{\"msg\":\"\\u9000\\u51fa\\u767b\\u5f55\",\"func_name\":\"\\u9000\\u51fa\\u767b\\u5f55\",\"func\":\"logOut\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479799998}', '1479799998');
INSERT INTO `cms_log` VALUES ('2', '{\"msg\":\"\\u767b\\u5f55\\u6210\\u529f\",\"func_name\":\"\\u767b\\u5f55\",\"func\":\"login\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479800052}', '1479800052');
INSERT INTO `cms_log` VALUES ('3', '{\"msg\":\"\\u67e5\\u770b\\u5bfc\\u822a\\u5217\\u8868\",\"func_name\":\"\\u5bfc\\u822a\\u5217\\u8868\",\"func\":\"navlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479800765}', '1479800765');
INSERT INTO `cms_log` VALUES ('4', '{\"msg\":\"\\u6210\\u529f\\u589e\\u52a0\\u5bfc\\u822a\",\"func_name\":\"\\u6dfb\\u52a0\\u5bfc\\u822a\",\"func\":\"addnav\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479800798}', '1479800798');
INSERT INTO `cms_log` VALUES ('5', '{\"msg\":\"\\u67e5\\u770b\\u5bfc\\u822a\\u5217\\u8868\",\"func_name\":\"\\u5bfc\\u822a\\u5217\\u8868\",\"func\":\"navlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479800801}', '1479800801');
INSERT INTO `cms_log` VALUES ('6', '{\"msg\":\"\\u67e5\\u770b\\u5bfc\\u822a\\u5217\\u8868\",\"func_name\":\"\\u5bfc\\u822a\\u5217\\u8868\",\"func\":\"navlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479801259}', '1479801259');
INSERT INTO `cms_log` VALUES ('7', '{\"msg\":\"\\u67e5\\u770bbanner\\u5217\\u8868\",\"func_name\":\"banner\\u5217\\u8868\",\"func\":\"bannerlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479801609}', '1479801609');
INSERT INTO `cms_log` VALUES ('8', '{\"msg\":\"\\u6dfb\\u52a0\\u65b0Banner\",\"func_name\":\"\\u6dfb\\u52a0banner\",\"func\":\"addbanner\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479801830}', '1479801830');
INSERT INTO `cms_log` VALUES ('9', '{\"msg\":\"\\u67e5\\u770bbanner\\u5217\\u8868\",\"func_name\":\"banner\\u5217\\u8868\",\"func\":\"bannerlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479801831}', '1479801831');
INSERT INTO `cms_log` VALUES ('10', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479802281}', '1479802281');
INSERT INTO `cms_log` VALUES ('11', '{\"msg\":\"\\u6dfb\\u52a0\\u65b0\\u680f\\u76ee\\u5b8c\\u6210\",\"func_name\":\"\\u6dfb\\u52a0\\u680f\\u76ee\",\"func\":\"addcate\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479802292}', '1479802292');
INSERT INTO `cms_log` VALUES ('12', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479802293}', '1479802293');
INSERT INTO `cms_log` VALUES ('13', '{\"msg\":\"\\u6dfb\\u52a0\\u65b0\\u680f\\u76ee\\u5b8c\\u6210\",\"func_name\":\"\\u6dfb\\u52a0\\u680f\\u76ee\",\"func\":\"addcate\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479802302}', '1479802302');
INSERT INTO `cms_log` VALUES ('14', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479802303}', '1479802303');
INSERT INTO `cms_log` VALUES ('15', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479802420}', '1479802420');
INSERT INTO `cms_log` VALUES ('16', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479802580}', '1479802580');
INSERT INTO `cms_log` VALUES ('17', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479802581}', '1479802581');
INSERT INTO `cms_log` VALUES ('18', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479802654}', '1479802654');
INSERT INTO `cms_log` VALUES ('19', '{\"msg\":\"\\u6dfb\\u52a0\\u6587\\u7ae0\\u5b8c\\u6210\",\"func_name\":\"\\u6dfb\\u52a0\\u6587\\u7ae0\",\"func\":\"addart\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479802671}', '1479802671');
INSERT INTO `cms_log` VALUES ('20', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479802672}', '1479802672');
INSERT INTO `cms_log` VALUES ('21', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479802677}', '1479802677');
INSERT INTO `cms_log` VALUES ('22', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479802793}', '1479802793');
INSERT INTO `cms_log` VALUES ('23', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479804357}', '1479804357');
INSERT INTO `cms_log` VALUES ('24', '{\"msg\":\"\\u6dfb\\u52a0\\u914d\\u7f6e\\u9879\\u6210\\u529f\",\"func_name\":\"\\u521b\\u5efa\\u914d\\u7f6e\\u9879\",\"func\":\"Conf\\/createConf\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479804507}', '1479804507');
INSERT INTO `cms_log` VALUES ('25', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479804508}', '1479804508');
INSERT INTO `cms_log` VALUES ('26', '{\"msg\":\"\\u6dfb\\u52a0\\u914d\\u7f6e\\u9879\\u6210\\u529f\",\"func_name\":\"\\u521b\\u5efa\\u914d\\u7f6e\\u9879\",\"func\":\"Conf\\/createConf\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479804531}', '1479804531');
INSERT INTO `cms_log` VALUES ('27', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479804532}', '1479804532');
INSERT INTO `cms_log` VALUES ('28', '{\"msg\":\"\\u6dfb\\u52a0\\u914d\\u7f6e\\u9879\\u6210\\u529f\",\"func_name\":\"\\u521b\\u5efa\\u914d\\u7f6e\\u9879\",\"func\":\"Conf\\/createConf\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479804550}', '1479804550');
INSERT INTO `cms_log` VALUES ('29', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479804551}', '1479804551');
INSERT INTO `cms_log` VALUES ('30', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479804790}', '1479804790');
INSERT INTO `cms_log` VALUES ('31', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479804805}', '1479804805');
INSERT INTO `cms_log` VALUES ('32', '{\"msg\":\"\\u67e5\\u770b\\u53cb\\u60c5\\u8fde\\u63a5\\u5217\\u8868\",\"func_name\":\"\\u53cb\\u60c5\\u8fde\\u63a5\\u5217\\u8868\",\"func\":\"linklist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479804820}', '1479804820');
INSERT INTO `cms_log` VALUES ('33', '{\"msg\":\"\\u6dfb\\u52a0\\u53cb\\u60c5\\u8fde\\u63a5\\u5b8c\\u6210\",\"func_name\":\"\\u6dfb\\u52a0\\u53cb\\u60c5\\u8fde\\u63a5\",\"func\":\"addlink\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479804828}', '1479804828');
INSERT INTO `cms_log` VALUES ('34', '{\"msg\":\"\\u67e5\\u770b\\u53cb\\u60c5\\u8fde\\u63a5\\u5217\\u8868\",\"func_name\":\"\\u53cb\\u60c5\\u8fde\\u63a5\\u5217\\u8868\",\"func\":\"linklist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479804829}', '1479804829');
INSERT INTO `cms_log` VALUES ('35', '{\"msg\":\"\\u67e5\\u770b\\u53cb\\u60c5\\u8fde\\u63a5\\u5217\\u8868\",\"func_name\":\"\\u53cb\\u60c5\\u8fde\\u63a5\\u5217\\u8868\",\"func\":\"linklist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479804936}', '1479804936');
INSERT INTO `cms_log` VALUES ('36', '{\"msg\":\"\\u67e5\\u770b\\u7ba1\\u7406\\u5458\\u5217\\u8868\",\"func_name\":\"\\u7ba1\\u7406\\u5458\\u5217\\u8868\",\"func\":\"adminlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479806071}', '1479806071');
INSERT INTO `cms_log` VALUES ('37', '{\"msg\":\"\\u67e5\\u770b\\u7ba1\\u7406\\u5458\\u5217\\u8868\",\"func_name\":\"\\u7ba1\\u7406\\u5458\\u5217\\u8868\",\"func\":\"adminlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479806765}', '1479806765');
INSERT INTO `cms_log` VALUES ('38', '{\"msg\":\"\\u67e5\\u770b\\u7ba1\\u7406\\u5458\\u5217\\u8868\",\"func_name\":\"\\u7ba1\\u7406\\u5458\\u5217\\u8868\",\"func\":\"adminlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479806864}', '1479806864');
INSERT INTO `cms_log` VALUES ('39', '{\"msg\":\"\\u67e5\\u770b\\u6743\\u9650\\u7ec4\\u5217\\u8868\",\"func_name\":\"\\u6743\\u9650\\u7ec4\\u5217\\u8868\",\"func\":\"grouplist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479806866}', '1479806866');
INSERT INTO `cms_log` VALUES ('40', '{\"msg\":\"\\u67e5\\u770b\\u6743\\u9650\\u7ec4\\u5217\\u8868\",\"func_name\":\"\\u6743\\u9650\\u7ec4\\u5217\\u8868\",\"func\":\"grouplist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479807760}', '1479807760');
INSERT INTO `cms_log` VALUES ('41', '{\"msg\":\"\\u6dfb\\u52a0\\u6743\\u9650\\u6210\\u529f\",\"func_name\":\"\\u6dfb\\u52a0\\u6743\\u9650\",\"func\":\"Group\\/addrule\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479808658}', '1479808658');
INSERT INTO `cms_log` VALUES ('42', '{\"msg\":\"\\u67e5\\u770b\\u6570\\u636e\\u5e93\\u5217\\u8868\",\"func_name\":\"\\u6570\\u636e\\u5e93\\u5217\\u8868\",\"func\":\"export\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479809523}', '1479809523');
INSERT INTO `cms_log` VALUES ('43', '{\"msg\":\"\\u67e5\\u770b\\u8fd8\\u539f\\u5217\\u8868\",\"func_name\":\"\\u8fd8\\u539f\\u5217\\u8868\",\"func\":\"import\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479809705}', '1479809705');
INSERT INTO `cms_log` VALUES ('44', '{\"msg\":\"\\u67e5\\u770b\\u6570\\u636e\\u5e93\\u5217\\u8868\",\"func_name\":\"\\u6570\\u636e\\u5e93\\u5217\\u8868\",\"func\":\"export\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479809707}', '1479809707');
INSERT INTO `cms_log` VALUES ('45', '{\"msg\":\"\\u5907\\u4efd\\u5b8c\\u6210\",\"func_name\":\"\\u5907\\u4efd\\u6570\\u636e\\u5e93\",\"func\":\"backupSql\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479809710}', '1479809710');
INSERT INTO `cms_log` VALUES ('46', '{\"msg\":\"\\u5907\\u4efd\\u5b8c\\u6210\",\"func_name\":\"\\u5907\\u4efd\\u6570\\u636e\\u5e93\",\"func\":\"backupSql\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479809711}', '1479809711');
INSERT INTO `cms_log` VALUES ('47', '{\"msg\":\"\\u5907\\u4efd\\u5b8c\\u6210\",\"func_name\":\"\\u5907\\u4efd\\u6570\\u636e\\u5e93\",\"func\":\"backupSql\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479809711}', '1479809711');
INSERT INTO `cms_log` VALUES ('48', '{\"msg\":\"\\u5907\\u4efd\\u5b8c\\u6210\",\"func_name\":\"\\u5907\\u4efd\\u6570\\u636e\\u5e93\",\"func\":\"backupSql\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479809711}', '1479809711');
INSERT INTO `cms_log` VALUES ('49', '{\"msg\":\"\\u5907\\u4efd\\u5b8c\\u6210\",\"func_name\":\"\\u5907\\u4efd\\u6570\\u636e\\u5e93\",\"func\":\"backupSql\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479809711}', '1479809711');
INSERT INTO `cms_log` VALUES ('50', '{\"msg\":\"\\u5907\\u4efd\\u5b8c\\u6210\",\"func_name\":\"\\u5907\\u4efd\\u6570\\u636e\\u5e93\",\"func\":\"backupSql\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479809711}', '1479809711');
INSERT INTO `cms_log` VALUES ('51', '{\"msg\":\"\\u5907\\u4efd\\u5b8c\\u6210\",\"func_name\":\"\\u5907\\u4efd\\u6570\\u636e\\u5e93\",\"func\":\"backupSql\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479809711}', '1479809711');
INSERT INTO `cms_log` VALUES ('52', '{\"msg\":\"\\u5907\\u4efd\\u5b8c\\u6210\",\"func_name\":\"\\u5907\\u4efd\\u6570\\u636e\\u5e93\",\"func\":\"backupSql\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479809711}', '1479809711');
INSERT INTO `cms_log` VALUES ('53', '{\"msg\":\"\\u5907\\u4efd\\u5b8c\\u6210\",\"func_name\":\"\\u5907\\u4efd\\u6570\\u636e\\u5e93\",\"func\":\"backupSql\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479809711}', '1479809711');
INSERT INTO `cms_log` VALUES ('54', '{\"msg\":\"\\u5907\\u4efd\\u5b8c\\u6210\",\"func_name\":\"\\u5907\\u4efd\\u6570\\u636e\\u5e93\",\"func\":\"backupSql\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479809711}', '1479809711');
INSERT INTO `cms_log` VALUES ('55', '{\"msg\":\"\\u5907\\u4efd\\u5b8c\\u6210\",\"func_name\":\"\\u5907\\u4efd\\u6570\\u636e\\u5e93\",\"func\":\"backupSql\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479809711}', '1479809711');
INSERT INTO `cms_log` VALUES ('56', '{\"msg\":\"\\u5907\\u4efd\\u5b8c\\u6210\",\"func_name\":\"\\u5907\\u4efd\\u6570\\u636e\\u5e93\",\"func\":\"backupSql\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479809711}', '1479809711');
INSERT INTO `cms_log` VALUES ('57', '{\"msg\":\"\\u5907\\u4efd\\u5b8c\\u6210\",\"func_name\":\"\\u5907\\u4efd\\u6570\\u636e\\u5e93\",\"func\":\"backupSql\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479809712}', '1479809712');
INSERT INTO `cms_log` VALUES ('58', '{\"msg\":\"\\u5907\\u4efd\\u5b8c\\u6210\",\"func_name\":\"\\u5907\\u4efd\\u6570\\u636e\\u5e93\",\"func\":\"backupSql\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479809712}', '1479809712');
INSERT INTO `cms_log` VALUES ('59', '{\"msg\":\"\\u67e5\\u770b\\u8fd8\\u539f\\u5217\\u8868\",\"func_name\":\"\\u8fd8\\u539f\\u5217\\u8868\",\"func\":\"import\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479809713}', '1479809713');
INSERT INTO `cms_log` VALUES ('60', '{\"msg\":\"\\u767b\\u5f55\\u6210\\u529f\",\"func_name\":\"\\u767b\\u5f55\",\"func\":\"login\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479887895}', '1479887895');
INSERT INTO `cms_log` VALUES ('61', '{\"msg\":\"\\u67e5\\u770b\\u7ba1\\u7406\\u5458\\u5217\\u8868\",\"func_name\":\"\\u7ba1\\u7406\\u5458\\u5217\\u8868\",\"func\":\"adminlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479887903}', '1479887903');
INSERT INTO `cms_log` VALUES ('62', '{\"msg\":\"\\u67e5\\u770b\\u7ba1\\u7406\\u5458\\u5217\\u8868\",\"func_name\":\"\\u7ba1\\u7406\\u5458\\u5217\\u8868\",\"func\":\"adminlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479888046}', '1479888046');
INSERT INTO `cms_log` VALUES ('63', '{\"msg\":\"\\u67e5\\u770b\\u7ba1\\u7406\\u5458\\u5217\\u8868\",\"func_name\":\"\\u7ba1\\u7406\\u5458\\u5217\\u8868\",\"func\":\"adminlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479889312}', '1479889312');
INSERT INTO `cms_log` VALUES ('64', '{\"msg\":\"\\u67e5\\u770b\\u6743\\u9650\\u7ec4\\u5217\\u8868\",\"func_name\":\"\\u6743\\u9650\\u7ec4\\u5217\\u8868\",\"func\":\"grouplist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1479889395}', '1479889395');
INSERT INTO `cms_log` VALUES ('65', '{\"msg\":\"\\u767b\\u5f55\\u6210\\u529f\",\"func_name\":\"\\u767b\\u5f55\",\"func\":\"login\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486953249}', '1486953249');
INSERT INTO `cms_log` VALUES ('66', '{\"msg\":\"\\u67e5\\u770b\\u5bfc\\u822a\\u5217\\u8868\",\"func_name\":\"\\u5bfc\\u822a\\u5217\\u8868\",\"func\":\"navlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486953252}', '1486953252');
INSERT INTO `cms_log` VALUES ('67', '{\"msg\":\"\\u67e5\\u770bbanner\\u5217\\u8868\",\"func_name\":\"banner\\u5217\\u8868\",\"func\":\"bannerlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486953262}', '1486953262');
INSERT INTO `cms_log` VALUES ('68', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486953273}', '1486953273');
INSERT INTO `cms_log` VALUES ('69', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486953275}', '1486953275');
INSERT INTO `cms_log` VALUES ('70', '{\"msg\":\"\\u67e5\\u770bbanner\\u5217\\u8868\",\"func_name\":\"banner\\u5217\\u8868\",\"func\":\"bannerlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486953848}', '1486953848');
INSERT INTO `cms_log` VALUES ('71', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486953849}', '1486953849');
INSERT INTO `cms_log` VALUES ('72', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486953853}', '1486953853');
INSERT INTO `cms_log` VALUES ('73', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486956036}', '1486956036');
INSERT INTO `cms_log` VALUES ('74', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486956037}', '1486956037');
INSERT INTO `cms_log` VALUES ('75', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486956117}', '1486956117');
INSERT INTO `cms_log` VALUES ('76', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486956165}', '1486956165');
INSERT INTO `cms_log` VALUES ('77', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486956471}', '1486956471');
INSERT INTO `cms_log` VALUES ('78', '{\"msg\":\"\\u67e5\\u770b\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957186}', '1486957186');
INSERT INTO `cms_log` VALUES ('79', '{\"msg\":\"\\u67e5\\u770b\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957232}', '1486957232');
INSERT INTO `cms_log` VALUES ('80', '{\"msg\":\"\\u67e5\\u770b\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957256}', '1486957256');
INSERT INTO `cms_log` VALUES ('81', '{\"msg\":\"\\u6dfb\\u52a0\\u65b0\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5b8c\\u6210\",\"func_name\":\"\\u6dfb\\u52a0\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\",\"func\":\"addcate\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957274}', '1486957274');
INSERT INTO `cms_log` VALUES ('82', '{\"msg\":\"\\u67e5\\u770b\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957275}', '1486957275');
INSERT INTO `cms_log` VALUES ('83', '{\"msg\":\"\\u67e5\\u770b\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957276}', '1486957276');
INSERT INTO `cms_log` VALUES ('84', '{\"msg\":\"\\u67e5\\u770b\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957279}', '1486957279');
INSERT INTO `cms_log` VALUES ('85', '{\"msg\":\"\\u67e5\\u770b\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957385}', '1486957385');
INSERT INTO `cms_log` VALUES ('86', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957836}', '1486957836');
INSERT INTO `cms_log` VALUES ('87', '{\"msg\":\"\\u67e5\\u770b\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957837}', '1486957837');
INSERT INTO `cms_log` VALUES ('88', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957841}', '1486957841');
INSERT INTO `cms_log` VALUES ('89', '{\"msg\":\"\\u67e5\\u770b\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957845}', '1486957845');
INSERT INTO `cms_log` VALUES ('90', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957848}', '1486957848');
INSERT INTO `cms_log` VALUES ('91', '{\"msg\":\"\\u67e5\\u770b\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957849}', '1486957849');
INSERT INTO `cms_log` VALUES ('92', '{\"msg\":\"\\u67e5\\u770b\\u8fd0\\u884c\\u9879\\u76ee\",\"func_name\":\"\\u9879\\u76ee\\u5217\\u8868\",\"func\":\"prolist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957862}', '1486957862');
INSERT INTO `cms_log` VALUES ('93', '{\"msg\":\"\\u5373\\u5c06\\u8fc7\\u671f\\u7684\\u9879\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u5373\\u5c06\\u8fc7\\u671f\\u7684\\u9879\\u76ee\",\"func\":\"lastpro\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957869}', '1486957869');
INSERT INTO `cms_log` VALUES ('94', '{\"msg\":\"\\u5373\\u5c06\\u8fc7\\u671f\\u7684\\u9879\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u5373\\u5c06\\u8fc7\\u671f\\u7684\\u9879\\u76ee\",\"func\":\"lastpro\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957870}', '1486957870');
INSERT INTO `cms_log` VALUES ('95', '{\"msg\":\"\\u67e5\\u770b\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957872}', '1486957872');
INSERT INTO `cms_log` VALUES ('96', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957874}', '1486957874');
INSERT INTO `cms_log` VALUES ('97', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957875}', '1486957875');
INSERT INTO `cms_log` VALUES ('98', '{\"msg\":\"\\u67e5\\u770b\\u7ba1\\u7406\\u5458\\u5217\\u8868\",\"func_name\":\"\\u7ba1\\u7406\\u5458\\u5217\\u8868\",\"func\":\"adminlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957877}', '1486957877');
INSERT INTO `cms_log` VALUES ('99', '{\"msg\":\"\\u67e5\\u770b\\u6743\\u9650\\u7ec4\\u5217\\u8868\",\"func_name\":\"\\u6743\\u9650\\u7ec4\\u5217\\u8868\",\"func\":\"grouplist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957878}', '1486957878');
INSERT INTO `cms_log` VALUES ('100', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957889}', '1486957889');
INSERT INTO `cms_log` VALUES ('101', '{\"msg\":\"\\u67e5\\u770bbanner\\u5217\\u8868\",\"func_name\":\"banner\\u5217\\u8868\",\"func\":\"bannerlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957890}', '1486957890');
INSERT INTO `cms_log` VALUES ('102', '{\"msg\":\"\\u67e5\\u770b\\u5bfc\\u822a\\u5217\\u8868\",\"func_name\":\"\\u5bfc\\u822a\\u5217\\u8868\",\"func\":\"navlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957890}', '1486957890');
INSERT INTO `cms_log` VALUES ('103', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957891}', '1486957891');
INSERT INTO `cms_log` VALUES ('104', '{\"msg\":\"\\u67e5\\u770b\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957892}', '1486957892');
INSERT INTO `cms_log` VALUES ('105', '{\"msg\":\"\\u67e5\\u770b\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957902}', '1486957902');
INSERT INTO `cms_log` VALUES ('106', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957903}', '1486957903');
INSERT INTO `cms_log` VALUES ('107', '{\"msg\":\"\\u67e5\\u770b\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957904}', '1486957904');
INSERT INTO `cms_log` VALUES ('108', '{\"msg\":\"\\u67e5\\u770b\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957910}', '1486957910');
INSERT INTO `cms_log` VALUES ('109', '{\"msg\":\"\\u67e5\\u770b\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957920}', '1486957920');
INSERT INTO `cms_log` VALUES ('110', '{\"msg\":\"\\u67e5\\u770b\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957929}', '1486957929');
INSERT INTO `cms_log` VALUES ('111', '{\"msg\":\"\\u67e5\\u770b\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486957941}', '1486957941');
INSERT INTO `cms_log` VALUES ('112', '{\"msg\":\"\\u6dfb\\u52a0\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u6587\\u7ae0\\u5b8c\\u6210\",\"func_name\":\"\\u6dfb\\u52a0\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u6587\\u7ae0\",\"func\":\"addart\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486958079}', '1486958079');
INSERT INTO `cms_log` VALUES ('113', '{\"msg\":\"\\u67e5\\u770b\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486958139}', '1486958139');
INSERT INTO `cms_log` VALUES ('114', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486958141}', '1486958141');
INSERT INTO `cms_log` VALUES ('115', '{\"msg\":\"\\u67e5\\u770b\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486958142}', '1486958142');
INSERT INTO `cms_log` VALUES ('116', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486958334}', '1486958334');
INSERT INTO `cms_log` VALUES ('117', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486958334}', '1486958334');
INSERT INTO `cms_log` VALUES ('118', '{\"msg\":\"\\u67e5\\u770b\\u5bfc\\u822a\\u5217\\u8868\",\"func_name\":\"\\u5bfc\\u822a\\u5217\\u8868\",\"func\":\"navlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486958338}', '1486958338');
INSERT INTO `cms_log` VALUES ('119', '{\"msg\":\"\\u67e5\\u770bbanner\\u5217\\u8868\",\"func_name\":\"banner\\u5217\\u8868\",\"func\":\"bannerlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486958353}', '1486958353');
INSERT INTO `cms_log` VALUES ('120', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486958354}', '1486958354');
INSERT INTO `cms_log` VALUES ('121', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486958355}', '1486958355');
INSERT INTO `cms_log` VALUES ('122', '{\"msg\":\"\\u67e5\\u770b\\u5bfc\\u822a\\u5217\\u8868\",\"func_name\":\"\\u5bfc\\u822a\\u5217\\u8868\",\"func\":\"navlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486958355}', '1486958355');
INSERT INTO `cms_log` VALUES ('123', '{\"msg\":\"\\u67e5\\u770b\\u6807\\u7b7e\\u5217\\u8868\",\"func_name\":\"\\u6807\\u7b7e\\u5217\\u8868\",\"func\":\"taglist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486967464}', '1486967464');
INSERT INTO `cms_log` VALUES ('124', '{\"msg\":\"\\u67e5\\u770b\\u6807\\u7b7e\\u5217\\u8868\",\"func_name\":\"\\u6807\\u7b7e\\u5217\\u8868\",\"func\":\"taglist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486967537}', '1486967537');
INSERT INTO `cms_log` VALUES ('125', '{\"msg\":\"\\u6210\\u529f\\u589e\\u52a0\\u6807\\u7b7e\",\"func_name\":\"\\u6dfb\\u52a0\\u6807\\u7b7e\",\"func\":\"addtag\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486967554}', '1486967554');
INSERT INTO `cms_log` VALUES ('126', '{\"msg\":\"\\u67e5\\u770b\\u6807\\u7b7e\\u5217\\u8868\",\"func_name\":\"\\u6807\\u7b7e\\u5217\\u8868\",\"func\":\"taglist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486967555}', '1486967555');
INSERT INTO `cms_log` VALUES ('127', '{\"msg\":\"\\u67e5\\u770b\\u6807\\u7b7e\\u5217\\u8868\",\"func_name\":\"\\u6807\\u7b7e\\u5217\\u8868\",\"func\":\"taglist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486967571}', '1486967571');
INSERT INTO `cms_log` VALUES ('128', '{\"msg\":\"\\u67e5\\u770b\\u6807\\u7b7e\\u5217\\u8868\",\"func_name\":\"\\u6807\\u7b7e\\u5217\\u8868\",\"func\":\"taglist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486967635}', '1486967635');
INSERT INTO `cms_log` VALUES ('129', '{\"msg\":\"\\u67e5\\u770b\\u6807\\u7b7e\\u5217\\u8868\",\"func_name\":\"\\u6807\\u7b7e\\u5217\\u8868\",\"func\":\"taglist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486967659}', '1486967659');
INSERT INTO `cms_log` VALUES ('130', '{\"msg\":\"\\u67e5\\u770b\\u6807\\u7b7e\\u5217\\u8868\",\"func_name\":\"\\u6807\\u7b7e\\u5217\\u8868\",\"func\":\"taglist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486967675}', '1486967675');
INSERT INTO `cms_log` VALUES ('131', '{\"msg\":\"\\u6392\\u5e8f\\u66f4\\u65b0\\u6210\\u529f\",\"func_name\":\"\\u6392\\u5e8f\",\"func\":\"Tags\\/changeOrder\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486967681}', '1486967681');
INSERT INTO `cms_log` VALUES ('132', '{\"msg\":\"\\u67e5\\u770b\\u6807\\u7b7e\\u5217\\u8868\",\"func_name\":\"\\u6807\\u7b7e\\u5217\\u8868\",\"func\":\"taglist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486967684}', '1486967684');
INSERT INTO `cms_log` VALUES ('133', '{\"msg\":\"\\u7f16\\u8f91\\u6807\\u7b7e\\u4fe1\\u606f\",\"func_name\":\"\\u7f16\\u8f91\\u6807\\u7b7e\",\"func\":\"edittag\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486967700}', '1486967700');
INSERT INTO `cms_log` VALUES ('134', '{\"msg\":\"\\u67e5\\u770b\\u6807\\u7b7e\\u5217\\u8868\",\"func_name\":\"\\u6807\\u7b7e\\u5217\\u8868\",\"func\":\"taglist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486967701}', '1486967701');
INSERT INTO `cms_log` VALUES ('135', '{\"msg\":\"\\u6210\\u529f\\u589e\\u52a0\\u6807\\u7b7e\",\"func_name\":\"\\u6dfb\\u52a0\\u6807\\u7b7e\",\"func\":\"addtag\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486967719}', '1486967719');
INSERT INTO `cms_log` VALUES ('136', '{\"msg\":\"\\u67e5\\u770b\\u6807\\u7b7e\\u5217\\u8868\",\"func_name\":\"\\u6807\\u7b7e\\u5217\\u8868\",\"func\":\"taglist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486967720}', '1486967720');
INSERT INTO `cms_log` VALUES ('137', '{\"msg\":\"\\u67e5\\u770b\\u6807\\u7b7e\\u5217\\u8868\",\"func_name\":\"\\u6807\\u7b7e\\u5217\\u8868\",\"func\":\"taglist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486967725}', '1486967725');
INSERT INTO `cms_log` VALUES ('138', '{\"msg\":\"\\u5220\\u9664\\u6807\\u7b7e\\u6210\\u529f\",\"func_name\":\"\\u5220\\u9664\\u6807\\u7b7e\",\"func\":\"deltag\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486967740}', '1486967740');
INSERT INTO `cms_log` VALUES ('139', '{\"msg\":\"\\u67e5\\u770b\\u6807\\u7b7e\\u5217\\u8868\",\"func_name\":\"\\u6807\\u7b7e\\u5217\\u8868\",\"func\":\"taglist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486967742}', '1486967742');
INSERT INTO `cms_log` VALUES ('140', '{\"msg\":\"\\u67e5\\u770b\\u6807\\u7b7e\\u5217\\u8868\",\"func_name\":\"\\u6807\\u7b7e\\u5217\\u8868\",\"func\":\"taglist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486967769}', '1486967769');
INSERT INTO `cms_log` VALUES ('141', '{\"msg\":\"\\u67e5\\u770b\\u5bfc\\u822a\\u5217\\u8868\",\"func_name\":\"\\u5bfc\\u822a\\u5217\\u8868\",\"func\":\"navlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486967772}', '1486967772');
INSERT INTO `cms_log` VALUES ('142', '{\"msg\":\"\\u67e5\\u770b\\u6807\\u7b7e\\u5217\\u8868\",\"func_name\":\"\\u6807\\u7b7e\\u5217\\u8868\",\"func\":\"taglist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486967774}', '1486967774');
INSERT INTO `cms_log` VALUES ('143', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486968347}', '1486968347');
INSERT INTO `cms_log` VALUES ('144', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486968716}', '1486968716');
INSERT INTO `cms_log` VALUES ('145', '{\"msg\":\"\\u6dfb\\u52a0\\u914d\\u7f6e\\u9879\\u6210\\u529f\",\"func_name\":\"\\u521b\\u5efa\\u914d\\u7f6e\\u9879\",\"func\":\"Conf\\/createConf\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486969456}', '1486969456');
INSERT INTO `cms_log` VALUES ('146', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486969458}', '1486969458');
INSERT INTO `cms_log` VALUES ('147', '{\"msg\":\"\\u6dfb\\u52a0\\u914d\\u7f6e\\u9879\\u6210\\u529f\",\"func_name\":\"\\u521b\\u5efa\\u914d\\u7f6e\\u9879\",\"func\":\"Conf\\/createConf\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486969828}', '1486969828');
INSERT INTO `cms_log` VALUES ('148', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486969829}', '1486969829');
INSERT INTO `cms_log` VALUES ('149', '{\"msg\":\"\\u6dfb\\u52a0\\u914d\\u7f6e\\u9879\\u6210\\u529f\",\"func_name\":\"\\u521b\\u5efa\\u914d\\u7f6e\\u9879\",\"func\":\"Conf\\/createConf\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486969900}', '1486969900');
INSERT INTO `cms_log` VALUES ('150', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486969901}', '1486969901');
INSERT INTO `cms_log` VALUES ('151', '{\"msg\":\"\\u914d\\u7f6e\\u66f4\\u65b0\\u6210\\u529f\",\"func_name\":\"\\u66f4\\u6539\\u914d\\u7f6e\\u9879\",\"func\":\"Conf\\/changeContent\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486970009}', '1486970009');
INSERT INTO `cms_log` VALUES ('152', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1486970010}', '1486970010');
INSERT INTO `cms_log` VALUES ('153', '{\"msg\":\"\\u767b\\u5f55\\u6210\\u529f\",\"func_name\":\"\\u767b\\u5f55\",\"func\":\"login\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487038172}', '1487038172');
INSERT INTO `cms_log` VALUES ('154', '{\"msg\":\"\\u67e5\\u770b\\u6570\\u636e\\u5e93\\u5217\\u8868\",\"func_name\":\"\\u6570\\u636e\\u5e93\\u5217\\u8868\",\"func\":\"export\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487059531}', '1487059531');
INSERT INTO `cms_log` VALUES ('155', '{\"msg\":\"\\u67e5\\u770b\\u8fd0\\u884c\\u9879\\u76ee\",\"func_name\":\"\\u9879\\u76ee\\u5217\\u8868\",\"func\":\"prolist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487060086}', '1487060086');
INSERT INTO `cms_log` VALUES ('156', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487065745}', '1487065745');
INSERT INTO `cms_log` VALUES ('157', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487065748}', '1487065748');
INSERT INTO `cms_log` VALUES ('158', '{\"msg\":\"\\u67e5\\u770b\\u6807\\u7b7e\\u5217\\u8868\",\"func_name\":\"\\u6807\\u7b7e\\u5217\\u8868\",\"func\":\"taglist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487065751}', '1487065751');
INSERT INTO `cms_log` VALUES ('159', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487065823}', '1487065823');
INSERT INTO `cms_log` VALUES ('160', '{\"msg\":\"\\u67e5\\u770b\\u53cb\\u60c5\\u8fde\\u63a5\\u5217\\u8868\",\"func_name\":\"\\u53cb\\u60c5\\u8fde\\u63a5\\u5217\\u8868\",\"func\":\"linklist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487065826}', '1487065826');
INSERT INTO `cms_log` VALUES ('161', '{\"msg\":\"\\u67e5\\u770b\\u53cb\\u60c5\\u8fde\\u63a5\\u5217\\u8868\",\"func_name\":\"\\u53cb\\u60c5\\u8fde\\u63a5\\u5217\\u8868\",\"func\":\"linklist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487065828}', '1487065828');
INSERT INTO `cms_log` VALUES ('162', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487066055}', '1487066055');
INSERT INTO `cms_log` VALUES ('163', '{\"msg\":\"\\u6dfb\\u52a0\\u914d\\u7f6e\\u9879\\u6210\\u529f\",\"func_name\":\"\\u521b\\u5efa\\u914d\\u7f6e\\u9879\",\"func\":\"Conf\\/createConf\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487066088}', '1487066088');
INSERT INTO `cms_log` VALUES ('164', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487066089}', '1487066089');
INSERT INTO `cms_log` VALUES ('165', '{\"msg\":\"\\u6dfb\\u52a0\\u914d\\u7f6e\\u9879\\u6210\\u529f\",\"func_name\":\"\\u521b\\u5efa\\u914d\\u7f6e\\u9879\",\"func\":\"Conf\\/createConf\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487066124}', '1487066124');
INSERT INTO `cms_log` VALUES ('166', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487066125}', '1487066125');
INSERT INTO `cms_log` VALUES ('167', '{\"msg\":\"\\u6dfb\\u52a0\\u914d\\u7f6e\\u9879\\u6210\\u529f\",\"func_name\":\"\\u521b\\u5efa\\u914d\\u7f6e\\u9879\",\"func\":\"Conf\\/createConf\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487066151}', '1487066151');
INSERT INTO `cms_log` VALUES ('168', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487066152}', '1487066152');
INSERT INTO `cms_log` VALUES ('169', '{\"msg\":\"\\u6dfb\\u52a0\\u914d\\u7f6e\\u9879\\u6210\\u529f\",\"func_name\":\"\\u521b\\u5efa\\u914d\\u7f6e\\u9879\",\"func\":\"Conf\\/createConf\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487066171}', '1487066171');
INSERT INTO `cms_log` VALUES ('170', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487066172}', '1487066172');
INSERT INTO `cms_log` VALUES ('171', '{\"msg\":\"\\u767b\\u5f55\\u6210\\u529f\",\"func_name\":\"\\u767b\\u5f55\",\"func\":\"login\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487143563}', '1487143563');
INSERT INTO `cms_log` VALUES ('172', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487143574}', '1487143574');
INSERT INTO `cms_log` VALUES ('173', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487148630}', '1487148630');
INSERT INTO `cms_log` VALUES ('174', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487148640}', '1487148640');
INSERT INTO `cms_log` VALUES ('175', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487148650}', '1487148650');
INSERT INTO `cms_log` VALUES ('176', '{\"msg\":\"\\u67e5\\u770b\\u5bfc\\u822a\\u5217\\u8868\",\"func_name\":\"\\u5bfc\\u822a\\u5217\\u8868\",\"func\":\"navlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487150771}', '1487150771');
INSERT INTO `cms_log` VALUES ('177', '{\"msg\":\"\\u67e5\\u770bbanner\\u5217\\u8868\",\"func_name\":\"banner\\u5217\\u8868\",\"func\":\"bannerlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487150776}', '1487150776');
INSERT INTO `cms_log` VALUES ('178', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487150781}', '1487150781');
INSERT INTO `cms_log` VALUES ('179', '{\"msg\":\"\\u67e5\\u770b\\u8fd0\\u884c\\u9879\\u76ee\",\"func_name\":\"\\u9879\\u76ee\\u5217\\u8868\",\"func\":\"prolist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487150785}', '1487150785');
INSERT INTO `cms_log` VALUES ('180', '{\"msg\":\"\\u5373\\u5c06\\u8fc7\\u671f\\u7684\\u9879\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u5373\\u5c06\\u8fc7\\u671f\\u7684\\u9879\\u76ee\",\"func\":\"lastpro\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487150790}', '1487150790');
INSERT INTO `cms_log` VALUES ('181', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487150798}', '1487150798');
INSERT INTO `cms_log` VALUES ('182', '{\"msg\":\"\\u8fc7\\u671f\\u7684\\u9879\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u8fc7\\u671f\\u7684\\u9879\\u76ee\",\"func\":\"outpro\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487151624}', '1487151624');
INSERT INTO `cms_log` VALUES ('183', '{\"msg\":\"\\u5373\\u5c06\\u8fc7\\u671f\\u7684\\u9879\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u5373\\u5c06\\u8fc7\\u671f\\u7684\\u9879\\u76ee\",\"func\":\"lastpro\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487151627}', '1487151627');
INSERT INTO `cms_log` VALUES ('184', '{\"msg\":\"\\u67e5\\u770b\\u8fd0\\u884c\\u9879\\u76ee\",\"func_name\":\"\\u9879\\u76ee\\u5217\\u8868\",\"func\":\"prolist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487151629}', '1487151629');
INSERT INTO `cms_log` VALUES ('185', '{\"msg\":\"\\u9879\\u76ee\\u56de\\u6536\\u7ad9\",\"func_name\":\"\\u9879\\u76ee\\u56de\\u6536\\u7ad9\",\"func\":\"recyclepro\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487151630}', '1487151630');
INSERT INTO `cms_log` VALUES ('186', '{\"msg\":\"\\u67e5\\u770b\\u6807\\u7b7e\\u5217\\u8868\",\"func_name\":\"\\u6807\\u7b7e\\u5217\\u8868\",\"func\":\"taglist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487151631}', '1487151631');
INSERT INTO `cms_log` VALUES ('187', '{\"msg\":\"\\u4fee\\u6539\\u90ae\\u4ef6\\u914d\\u7f6e\\u9879\\u6210\\u529f\",\"func_name\":\"\\u521b\\u5efa\\u914d\\u7f6e\\u9879\",\"func\":\"Conf\\/mail\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487208070}', '1487208070');
INSERT INTO `cms_log` VALUES ('188', '{\"msg\":\"\\u4fee\\u6539\\u90ae\\u4ef6\\u914d\\u7f6e\\u9879\\u6210\\u529f\",\"func_name\":\"\\u521b\\u5efa\\u914d\\u7f6e\\u9879\",\"func\":\"Conf\\/mail\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487229012}', '1487229012');
INSERT INTO `cms_log` VALUES ('189', '{\"msg\":\"\\u4fee\\u6539\\u90ae\\u4ef6\\u914d\\u7f6e\\u9879\\u6210\\u529f\",\"func_name\":\"\\u521b\\u5efa\\u914d\\u7f6e\\u9879\",\"func\":\"Conf\\/mail\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487229070}', '1487229070');
INSERT INTO `cms_log` VALUES ('190', '{\"msg\":\"\\u4fee\\u6539\\u90ae\\u4ef6\\u914d\\u7f6e\\u9879\\u6210\\u529f\",\"func_name\":\"\\u521b\\u5efa\\u914d\\u7f6e\\u9879\",\"func\":\"Conf\\/mail\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487229634}', '1487229634');
INSERT INTO `cms_log` VALUES ('191', '{\"msg\":\"\\u4fee\\u6539\\u90ae\\u4ef6\\u914d\\u7f6e\\u9879\\u6210\\u529f\",\"func_name\":\"\\u521b\\u5efa\\u914d\\u7f6e\\u9879\",\"func\":\"Conf\\/mail\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487229638}', '1487229638');
INSERT INTO `cms_log` VALUES ('192', '{\"msg\":\"\\u4fee\\u6539\\u90ae\\u4ef6\\u914d\\u7f6e\\u9879\\u6210\\u529f\",\"func_name\":\"\\u521b\\u5efa\\u914d\\u7f6e\\u9879\",\"func\":\"Conf\\/mail\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487230671}', '1487230671');
INSERT INTO `cms_log` VALUES ('193', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487231260}', '1487231260');
INSERT INTO `cms_log` VALUES ('194', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487233851}', '1487233851');
INSERT INTO `cms_log` VALUES ('195', '{\"msg\":\"\\u67e5\\u770b\\u53cb\\u60c5\\u8fde\\u63a5\\u5217\\u8868\",\"func_name\":\"\\u53cb\\u60c5\\u8fde\\u63a5\\u5217\\u8868\",\"func\":\"linklist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487233854}', '1487233854');
INSERT INTO `cms_log` VALUES ('196', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487233871}', '1487233871');
INSERT INTO `cms_log` VALUES ('197', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487233873}', '1487233873');
INSERT INTO `cms_log` VALUES ('198', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487235673}', '1487235673');
INSERT INTO `cms_log` VALUES ('199', '{\"msg\":\"\\u67e5\\u770b\\u53cb\\u60c5\\u8fde\\u63a5\\u5217\\u8868\",\"func_name\":\"\\u53cb\\u60c5\\u8fde\\u63a5\\u5217\\u8868\",\"func\":\"linklist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487236473}', '1487236473');
INSERT INTO `cms_log` VALUES ('200', '{\"msg\":\"\\u4fee\\u6539\\u63d0\\u9192\\u6a21\\u677f\\u6210\\u529f\",\"func_name\":\"\\u4fee\\u6539\\u6a21\\u677f\",\"func\":\"Conf\\/noticeEdit\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487239869}', '1487239869');
INSERT INTO `cms_log` VALUES ('201', '{\"msg\":\"\\u4fee\\u6539\\u63d0\\u9192\\u6a21\\u677f\\u6210\\u529f\",\"func_name\":\"\\u4fee\\u6539\\u6a21\\u677f\",\"func\":\"Conf\\/noticeEdit\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487239887}', '1487239887');
INSERT INTO `cms_log` VALUES ('202', '{\"msg\":\"\\u4fee\\u6539\\u63d0\\u9192\\u6a21\\u677f\\u6210\\u529f\",\"func_name\":\"\\u4fee\\u6539\\u6a21\\u677f\",\"func\":\"Conf\\/noticeEdit\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1487240133}', '1487240133');
INSERT INTO `cms_log` VALUES ('203', '{\"msg\":\"\\u767b\\u5f55\\u6210\\u529f\",\"func_name\":\"\\u767b\\u5f55\",\"func\":\"login\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1491959898}', '1491959898');
INSERT INTO `cms_log` VALUES ('204', '{\"msg\":\"\\u67e5\\u770b\\u5bfc\\u822a\\u5217\\u8868\",\"func_name\":\"\\u5bfc\\u822a\\u5217\\u8868\",\"func\":\"navlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1491959908}', '1491959908');
INSERT INTO `cms_log` VALUES ('205', '{\"msg\":\"\\u67e5\\u770bbanner\\u5217\\u8868\",\"func_name\":\"banner\\u5217\\u8868\",\"func\":\"bannerlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1491959910}', '1491959910');
INSERT INTO `cms_log` VALUES ('206', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1491959911}', '1491959911');
INSERT INTO `cms_log` VALUES ('207', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1491959913}', '1491959913');
INSERT INTO `cms_log` VALUES ('208', '{\"msg\":\"\\u67e5\\u770b\\u6807\\u7b7e\\u5217\\u8868\",\"func_name\":\"\\u6807\\u7b7e\\u5217\\u8868\",\"func\":\"taglist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1491959933}', '1491959933');
INSERT INTO `cms_log` VALUES ('209', '{\"msg\":\"\\u67e5\\u770b\\u8fd0\\u884c\\u9879\\u76ee\",\"func_name\":\"\\u9879\\u76ee\\u5217\\u8868\",\"func\":\"prolist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1491981065}', '1491981065');
INSERT INTO `cms_log` VALUES ('210', '{\"msg\":\"\\u5373\\u5c06\\u8fc7\\u671f\\u7684\\u9879\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u5373\\u5c06\\u8fc7\\u671f\\u7684\\u9879\\u76ee\",\"func\":\"lastpro\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1491981068}', '1491981068');
INSERT INTO `cms_log` VALUES ('211', '{\"msg\":\"\\u767b\\u5f55\\u6210\\u529f\",\"func_name\":\"\\u767b\\u5f55\",\"func\":\"login\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1495446661}', '1495446661');
INSERT INTO `cms_log` VALUES ('212', '{\"msg\":\"\\u67e5\\u770b\\u53cb\\u60c5\\u8fde\\u63a5\\u5217\\u8868\",\"func_name\":\"\\u53cb\\u60c5\\u8fde\\u63a5\\u5217\\u8868\",\"func\":\"linklist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1495446689}', '1495446689');
INSERT INTO `cms_log` VALUES ('213', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1495446692}', '1495446692');
INSERT INTO `cms_log` VALUES ('214', '{\"msg\":\"\\u67e5\\u770b\\u6807\\u7b7e\\u5217\\u8868\",\"func_name\":\"\\u6807\\u7b7e\\u5217\\u8868\",\"func\":\"taglist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1495446693}', '1495446693');
INSERT INTO `cms_log` VALUES ('215', '{\"msg\":\"\\u67e5\\u770b\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u5e2e\\u52a9\\u4e2d\\u5fc3\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1495446696}', '1495446696');
INSERT INTO `cms_log` VALUES ('216', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1495446697}', '1495446697');
INSERT INTO `cms_log` VALUES ('217', '{\"msg\":\"\\u67e5\\u770b\\u680f\\u76ee\\u5217\\u8868\",\"func_name\":\"\\u680f\\u76ee\\u5217\\u8868\",\"func\":\"catelist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1495446697}', '1495446697');
INSERT INTO `cms_log` VALUES ('218', '{\"msg\":\"\\u67e5\\u770bbanner\\u5217\\u8868\",\"func_name\":\"banner\\u5217\\u8868\",\"func\":\"bannerlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1495446698}', '1495446698');
INSERT INTO `cms_log` VALUES ('219', '{\"msg\":\"\\u67e5\\u770b\\u5bfc\\u822a\\u5217\\u8868\",\"func_name\":\"\\u5bfc\\u822a\\u5217\\u8868\",\"func\":\"navlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1495446699}', '1495446699');
INSERT INTO `cms_log` VALUES ('220', '{\"msg\":\"\\u67e5\\u770b\\u53cb\\u60c5\\u8fde\\u63a5\\u5217\\u8868\",\"func_name\":\"\\u53cb\\u60c5\\u8fde\\u63a5\\u5217\\u8868\",\"func\":\"linklist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1495446703}', '1495446703');
INSERT INTO `cms_log` VALUES ('221', '{\"msg\":\"\\u67e5\\u770b\\u914d\\u7f6e\\u9996\\u9875\",\"func_name\":\"\\u914d\\u7f6e\\u5217\\u8868\",\"func\":\"Conf\\/index\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1495446704}', '1495446704');
INSERT INTO `cms_log` VALUES ('222', '{\"msg\":\"\\u67e5\\u770b\\u53cb\\u60c5\\u8fde\\u63a5\\u5217\\u8868\",\"func_name\":\"\\u53cb\\u60c5\\u8fde\\u63a5\\u5217\\u8868\",\"func\":\"linklist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1495446705}', '1495446705');
INSERT INTO `cms_log` VALUES ('223', '{\"msg\":\"\\u67e5\\u770b\\u5bfc\\u822a\\u5217\\u8868\",\"func_name\":\"\\u5bfc\\u822a\\u5217\\u8868\",\"func\":\"navlist\",\"operator\":\"admin\",\"ip\":\"127.0.0.1\",\"time\":1495447136}', '1495447136');

-- ----------------------------
-- Table structure for cms_mail
-- ----------------------------
DROP TABLE IF EXISTS `cms_mail`;
CREATE TABLE `cms_mail` (
  `id` int(2) NOT NULL AUTO_INCREMENT,
  `type` smallint(3) DEFAULT NULL COMMENT '邮件发送方式',
  `smtp_address` varchar(100) DEFAULT NULL COMMENT 'smtp地址',
  `is_ssl` tinyint(1) unsigned zerofill DEFAULT '0' COMMENT '是否启动ssl，0代表不启动，1代表启动',
  `port` smallint(6) DEFAULT '25' COMMENT '端口',
  `e_address` varchar(100) DEFAULT NULL COMMENT '邮箱地址',
  `e_password` varchar(100) DEFAULT NULL COMMENT '邮箱密码',
  `e_name` varchar(50) DEFAULT NULL COMMENT '发送者姓名',
  `test_address` varchar(100) DEFAULT NULL COMMENT '测试收件地址',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of cms_mail
-- ----------------------------
INSERT INTO `cms_mail` VALUES ('1', '1', 'smtp.qq.com', '1', '465', '492406945@qq.com', 'xyneumdflandcafa', '星客公关', '535699811@qq.com');

-- ----------------------------
-- Table structure for cms_navs
-- ----------------------------
DROP TABLE IF EXISTS `cms_navs`;
CREATE TABLE `cms_navs` (
  `nav_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `nav_name` varchar(50) DEFAULT NULL COMMENT '名称',
  `nav_url` varchar(255) DEFAULT NULL COMMENT '地址',
  `nav_order` int(11) DEFAULT NULL COMMENT '排序',
  `nav_pid` int(11) DEFAULT '0' COMMENT '导航的父级ID',
  PRIMARY KEY (`nav_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='导航';

-- ----------------------------
-- Records of cms_navs
-- ----------------------------
INSERT INTO `cms_navs` VALUES ('1', '导航1', 'http://', '0', '0');

-- ----------------------------
-- Table structure for cms_notice
-- ----------------------------
DROP TABLE IF EXISTS `cms_notice`;
CREATE TABLE `cms_notice` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT NULL,
  `key_id` varchar(50) DEFAULT NULL,
  `style` varchar(20) DEFAULT NULL,
  `template_id` varchar(64) DEFAULT NULL,
  `template` text,
  `tousers` varchar(255) DEFAULT NULL,
  `status` int(1) DEFAULT '0',
  `note` text,
  `obje` int(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of cms_notice
-- ----------------------------
INSERT INTO `cms_notice` VALUES ('1', '下单提醒', 'create_order', 'weixin', '', '{\"touser\":\"__touser__\",\"template_id\":\"__template_id__\",\"topcolor\":\"#0067A6\",\"data\":{\"first\":{\"value\":\"贺喜，商城有人下单了！\",\"color\":\"#00ABD8\"},\"keyword1\":{\"value\":\"订单(__order_no__)\",\"color\":\"#008972\"},\"keyword2\":{\"value\":\"__user__\",\"color\":\"#008972\"},\"keyword3\":{\"value\":\"__order_amount____currency_unit__\",\"color\":\"#EFC028\"},\"keyword4\":{\"value\":\"__order_amount____currency_unit__\",\"color\":\"#EFC028\"},\"keyword5\":{\"value\":\"__create_time__\",\"color\":\"#EFC028\"},\"remark\":{\"value\":\"济南泰创软件科技有限公司--祝你生意兴隆!\",\"color\":\"#F2572D\"}}}', '', '0', '在微信模板搜索中搜索“下单通知”，对应的模板编号为：OPENTM207350184', '0');
INSERT INTO `cms_notice` VALUES ('2', '下单提醒', 'create_order', 'email', '2233', '<h1>贺喜，商城有人下单了！</h1>\r\n订单编号：__order_no__<br/>\r\n下单者：__user__ <br/>\r\n订单金额：__order_amount____currency_unit__ <br/>\r\n下单时间：__create_time__ <br/>\r\n济南泰创软件科技公司--祝您生意兴隆！', '112', '0', '以下变量可以使用</br>\r\n订单编号：__order_no__\r\n下单者：__user__ \r\n订单金额：__order_amount__\r\n货币单位：__currency_unit__ \r\n下单时间：__create_time__ ', '0');
INSERT INTO `cms_notice` VALUES ('3', '下单提醒', 'create_order', 'sms', '', '{\"order_no\":\"__order_no__\",\"user\":\"__user__\",\"order_amount\":\"__order_amount____currency_unit__\",\"time\":\"__create_time__\"}', '', '0', '请务必注意短信下发字数的限制<br/>\r\n订单编号{order_no} 长度20位\r\n用户:{user}\r\n订单金额:{order_amount}\r\n下单时间{time}', '0');
INSERT INTO `cms_notice` VALUES ('4', '发货提醒', 'payment_order', 'weixin', '', '{\"touser\":\"__touser__\",\"template_id\":\"__template_id__\",\"topcolor\":\"#0067A6\",\"data\":{\"first\":{\"value\":\"客户已完成支付，请及时发货！\",\"color\":\"#00ABD8\"},\"keyword1\":{\"value\":\"__order_amount____currency_unit__\",\"color\":\"#008972\"},\"keyword2\":{\"value\":\"订单编号(__order_no__)\",\"color\":\"#008972\"},\"keyword3\":{\"value\":\"__accept_name__,__mobile__,__address__\",\"color\":\"#EFC028\"},\"remark\":{\"value\":\"济南泰创软件科技有限公司--祝你生意兴隆!\",\"color\":\"#F2572D\"}}}', '', '0', '在微信模板搜索中搜索“发货提醒”，对应的模板编号为：OPENTM203331384', '0');
INSERT INTO `cms_notice` VALUES ('5', '发货提醒', 'payment_order', 'email', '', '<h1>客户已完成付款，请及时发货！</h1>\r\n订单金额：__order_amount____currency_unit__ <br/>\r\n订单编号：__order_no__<br/>\r\n收货信息：__accept_name__,__mobile__,__address__<br/>\r\n济南泰创软件科技公司--祝您生意兴隆！', '', '0', '以下变量可以使用</br>\r\n订单编号：__order_no__\r\n订单金额：__order_amount__\r\n货币单位：__currency_unit__ \r\n收货地址：__address__\r\n收货人：__accept_name__\r\n收货人电话：__mobile__', '0');
INSERT INTO `cms_notice` VALUES ('7', '用户咨询提醒', 'user_ask', 'weixin', '', '{\"touser\":\"__touser__\",\"template_id\":\"__template_id__\",\"topcolor\":\"#0067A6\",\"data\":{\"first\":{\"value\":\"你好，你有一条用户咨询待解决!\",\"color\":\"#00ABD8\"},\"keyword1\":{\"value\":\"__user__\",\"color\":\"#008972\"},\"keyword2\":{\"value\":\"__content__\",\"color\":\"#008972\"},\"remark\":{\"value\":\"请尽快处理，提高公司信誉!\",\"color\":\"#F2572D\"}}}', '', '0', '在微信模板搜索中搜索“用户咨询提醒”，对应的模板编号为：OPENTM202119578', '0');
INSERT INTO `cms_notice` VALUES ('6', '发货提醒', 'payment_order', 'sms', '', '{\"order_no\":\"__order_no__\",\"order_amount\":\"__order_amount____currency_unit__\",\"time\":\"__pay_time__\"}', '', '0', '请务必注意短信下发字数的限制<br/>\r\n订单编号{order_no} 长度20位\r\n订单金额:{order_amount}\r\n付款时间{time}', '0');
INSERT INTO `cms_notice` VALUES ('8', '用户咨询提醒', 'user_ask', 'email', '', '<h1>你好，你有一条用户咨询待解决！</h1>\r\n用户：__user__ <br/>\r\n咨询内容：__content__<br/>\r\n请尽快处理，提高公司信誉!', '', '0', '以下变量可以使用</br>\r\n用户：__user__\r\n咨询内容：__content__\r\n', '0');
INSERT INTO `cms_notice` VALUES ('9', '用户咨询提醒', 'user_ask', 'sms', '', '{\"user\":\"__user__\",\"content\":\"__content__\"}', '', '0', '请务必注意短信下发字数的限制<br/>\r\n用户:{user}\r\n咨询内容:{content}', '0');
INSERT INTO `cms_notice` VALUES ('10', '后台登录通知', 'admin_login', 'weixin', '222', '{\"touser\":\"__touser__\",\"template_id\":\"__template_id__\",\"topcolor\":\"#0067A6\",\"data\":{\"first\":{\"value\":\"帐号__manager__已登录后台\",\"color\":\"#00ABD8\"},\"keyword1\":{\"value\":\"__time__\",\"color\":\"#008972\"},\"keyword2\":{\"value\":\"__login_type__\",\"color\":\"#008972\"},\"keyword3\":{\"value\":\"__ip__\",\"color\":\"#EFC028\"},\"remark\":{\"value\":\"如非公司管理人员操作，请立即访问桌面版修改密码\",\"color\":\"#F2572D\"}}}', '222', '0', '在微信模板搜索中搜索“登录通知”，对应的模板编号为：OPENTM217116132', '0');
INSERT INTO `cms_notice` VALUES ('11', '后台登录通知', 'admin_login', 'email', '', '<h1>帐号__manager__已登录后台</h1>\r\n登录时间：__time__ <br/>\r\n登录设备：__login_type__<br/>\r\n登录IP：__ip__<br/>\r\n如非公司管理人员操作，请立即访问桌面版修改密码', '', '0', '以下变量可以使用</br>\r\n登录时间：__time__ \r\n登录设备：__login_type__\r\n登录IP：__ip__', '0');
INSERT INTO `cms_notice` VALUES ('12', '后台登录通知', 'admin_login', 'sms', '1122', '{\"manager\":\"__manager__\",\"time\":\"__time__\",\"login_type\":\"__login_type__\",\"ip\":\"__ip__\"}', '111', '0', '请务必注意短信下发字数的限制<br/>\r\n管理员:{manager}\r\n登录时间:{time}\r\n登录设备:{login_type}\r\n登录IP:{ip}', '0');
INSERT INTO `cms_notice` VALUES ('13', '退款/退货申请提醒', 'refund_application', 'weixin', '', '{\"touser\":\"__touser__\",\"template_id\":\"__template_id__\",\"topcolor\":\"#0067A6\",\"data\":{\"first\":{\"value\":\"买家__user__申请退货\",\"color\":\"#00ABD8\"},\"keyword1\":{\"value\":\"__order_no__\",\"color\":\"#008972\"},\"keyword2\":{\"value\":\"__goods_name__\",\"color\":\"#008972\"},\"keyword3\":{\"value\":\"__order_amount__\",\"color\":\"#EFC028\"},\"remark\":{\"value\":\"请尽快处理用户的退款/退货的申请，提高公司信誉！\",\"color\":\"#F2572D\"}}}', '', '0', '在微信模板搜索中搜索“退货申请提醒”，对应的模板编号为：OPENTM204146731', '0');
INSERT INTO `cms_notice` VALUES ('14', '退款/退货申请提醒', 'refund_application', 'email', '', '<h1>买家__user__申请退货</h1>\r\n订单编号：__order_no__ <br/>\r\n商品名称：__goods_name__<br/>\r\n订单金额：__order_amount__<br/>\r\n请尽快处理用户的退款/退货的申请，提高公司信誉！', '', '0', '以下变量可以使用</br>\r\n用户：__user__\r\n订单编号：__order_no__\r\n商品名称：__goods_name__\r\n商品金额：__order_amount__', '0');
INSERT INTO `cms_notice` VALUES ('15', '退款/退货申请提醒', 'refund_application', 'sms', '', '{\"user\":\"__user__\",\"order_no\":\"__order_no__\",\"goods_name\":\"__goods_name__\",\"order_amount\":\"__order_amount__\"}', '', '0', '请务必注意短信下发字数的限制<br/>\r\n客户:{user}\r\n订单编号:{order_no}\r\n商品名称:{goods_name}\r\n订单金额:{order_amount}', '0');
INSERT INTO `cms_notice` VALUES ('16', '提现申请通知', 'withdrawal_application', 'weixin', '', '{\"touser\":\"__touser__\",\"template_id\":\"__template_id__\",\"topcolor\":\"#0067A6\",\"data\":{\"first\":{\"value\":\"用户申请提现！\",\"color\":\"#00ABD8\"},\"keyword1\":{\"value\":\"__user__\",\"color\":\"#008972\"},\"keyword2\":{\"value\":\"__amount____currency_unit__\",\"color\":\"#008972\"},\"keyword3\":{\"value\":\"__account__\",\"color\":\"#EFC028\"},\"keyword4\":{\"value\":\"账户名/开户名(__name__)\",\"color\":\"#EFC028\"},\"remark\":{\"value\":\"请尽快进行处理!\",\"color\":\"#F2572D\"}}}', '', '0', '在微信模板搜索中搜索“提现申请通知”，对应的模板编号为：OPENTM207277133', '0');
INSERT INTO `cms_notice` VALUES ('17', '提现申请通知', 'withdrawal_application', 'email', '', '<h1>用户提现申请！</h1>\r\n用户：__user__ <br/>\r\n申请金额：__amount____currency_unit__<br/>\r\n银行卡号：__account__<br/>\r\n商户号：__name__<br/>\r\n请尽快处理用户的退款/退货的申请，提高公司信誉！', '', '0', '以下变量可以使用</br>\r\n用户：__user__\r\n银行卡号：__account__\r\n商户号：__name__\r\n申请金额：__amount__', '0');
INSERT INTO `cms_notice` VALUES ('18', '提现申请通知', 'withdrawal_application', 'sms', '', '{\"user\":\"__user__\",\"amount\":\"__amount__\",\"account\":\"__account__\",\"name\":\"__name__\"}', '', '0', '请务必注意短信下发字数的限制<br/>\r\n客户:{user}\r\n商户号:{name}\r\n银行卡号:{account}\r\n申请金额:{amount}', '0');
INSERT INTO `cms_notice` VALUES ('19', '下单提醒', 'create_order', 'sms', '', '{\"order_no\":\"__order_no__\",\"order_amount\":\"__order_amount____currency_unit__\",\"time\":\"__create_time__\"}', null, '0', '订单编号{order_no} 长度20位 订单金额:{order_amount} 下单时间{time}', '1');
INSERT INTO `cms_notice` VALUES ('20', '发货提醒', 'order_send', 'sms', '', '{\"order_no\":\"__order_no__\",\"express_name\":\"__express_name__\",\"express_number\":\"__express_number__\"}', null, '0', '请务必注意短信下发字数的限制<br/>\r\n订单编号{order_no} 长度20位\r\n快递公司:{express_name}\r\n快递单号{express_number}\r\n', '1');
INSERT INTO `cms_notice` VALUES ('21', '退款/退货处理提醒', 'refund_action', 'sms', '', '{\"order_no\":\"__order_no__\",\"status\":\"__status__\"}', null, '0', '请务必注意短信下发字数的限制<br/>\r\n申请提现的金额{amount} \r\n处理状态(通过，未通过):{status}\r\n', '1');
INSERT INTO `cms_notice` VALUES ('22', '提现处理提醒', 'withdrawal_action', 'sms', '', '{\"amount\":\"__amount__\",\"status\":\"__status__\"}', null, '0', '请务必注意短信下发字数的限制<br/>\r\n申请提现的金额{amount} \r\n处理状态(通过，未通过):{status}\r\n', '1');

-- ----------------------------
-- Table structure for cms_project
-- ----------------------------
DROP TABLE IF EXISTS `cms_project`;
CREATE TABLE `cms_project` (
  `pro_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '项目主键ID',
  `pro_name` varchar(100) DEFAULT NULL COMMENT '运营项目名',
  `pro_service_cash` int(11) DEFAULT NULL COMMENT '项目维护续费费用',
  `pro_service_time` int(10) DEFAULT NULL COMMENT '项目上线时间',
  `pro_end_time` int(10) DEFAULT NULL COMMENT '项目维护结束时间',
  `pro_domain` varchar(100) DEFAULT NULL COMMENT '项目域名',
  `pro_status` tinyint(4) DEFAULT '0' COMMENT '项目状态，0：正常，1：即将到期，2：过期',
  `pro_cname` varchar(50) DEFAULT NULL COMMENT '项目甲方联系人',
  `pro_email` varchar(50) DEFAULT NULL COMMENT '网站的联系人邮箱',
  `email_notice` tinyint(4) DEFAULT '0' COMMENT '是否邮件通知，0：未通知，1：已通知',
  `email_notice_num` int(10) DEFAULT '0' COMMENT '邮箱通知次数',
  `pro_phone` varchar(11) DEFAULT NULL COMMENT '网站联系人的手机号码',
  `phone_notice` tinyint(4) DEFAULT '0' COMMENT '电话通知，0：未通知，1：已通知',
  `phone_notice_num` int(10) DEFAULT '0' COMMENT '电话通知次数',
  `pro_renewal` tinyint(4) DEFAULT NULL COMMENT '是否续期，0：未知，1：续期，2：不续期',
  `isdel` tinyint(4) DEFAULT '0' COMMENT '是否删除，0：正常，1：删除',
  `isphone_notice_time` int(10) DEFAULT NULL COMMENT '记录短信通知时间',
  `isemail_notice_time` int(10) DEFAULT NULL COMMENT '记录邮件通知时间',
  PRIMARY KEY (`pro_id`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='项目运营';

-- ----------------------------
-- Records of cms_project
-- ----------------------------
INSERT INTO `cms_project` VALUES ('1', '星客广告', '2000', '1471425660', '1473758512', 'www.thinker888.com', '2', '测试', '2851047632@qq.com', '0', '7', '13516511034', '0', '14', '0', '0', '1471363200', '1474276517');
INSERT INTO `cms_project` VALUES ('2', '星客广告', '2000', '1471425660', '1475745712', 'www.thinker888.com', '2', '测试', '2851047632@qq.com', '0', '6', '13516511034', '0', '14', '0', '0', '1471363200', '1474277722');
INSERT INTO `cms_project` VALUES ('3', '星客广告', '2000', '1471425660', '1503134512', 'www.thinker888.com', '0', '测试', '2851047632@qq.com', '0', '6', '13516511034', '0', '14', '0', '0', '1471363200', '1474278157');
INSERT INTO `cms_project` VALUES ('4', '星客广告', '2000', '1471425660', '1504171312', 'www.thinker888.com', '0', '测试', '2851047632@qq.com', '0', '6', '13516511034', '0', '14', '0', '0', '1471363200', '1474278430');
INSERT INTO `cms_project` VALUES ('5', '星客广告', '2000', '1471425660', '1502961712', 'www.thinker888.com', '0', '测试', '2851047632@qq.com', '0', '5', '13516511034', '0', '14', '0', '0', '1471363200', '1471363200');
INSERT INTO `cms_project` VALUES ('6', '测试', '1000', '1474340039', '1505876041', 'www.10000.com', '0', '测试', '139@139.com', '0', '0', '13516511024', '0', '0', '0', '0', '0', '0');

-- ----------------------------
-- Table structure for cms_tags
-- ----------------------------
DROP TABLE IF EXISTS `cms_tags`;
CREATE TABLE `cms_tags` (
  `tag_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tag_name` varchar(50) DEFAULT NULL COMMENT '标签名称',
  `tag_order` int(11) DEFAULT NULL COMMENT '排序',
  PRIMARY KEY (`tag_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='导航';

-- ----------------------------
-- Records of cms_tags
-- ----------------------------
INSERT INTO `cms_tags` VALUES ('1', '笔记本', '0');
INSERT INTO `cms_tags` VALUES ('3', '台式机', '1');

-- ----------------------------
-- Table structure for cms_users
-- ----------------------------
DROP TABLE IF EXISTS `cms_users`;
CREATE TABLE `cms_users` (
  `user_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户表主键',
  `username` varchar(50) DEFAULT NULL COMMENT '用户名',
  `password` varchar(50) DEFAULT NULL COMMENT '用户密码',
  `troop` tinyint(4) DEFAULT NULL COMMENT '1：战区机关   2 军以下部队',
  `create_time` int(10) DEFAULT NULL COMMENT '创建时间',
  `operator` varchar(50) DEFAULT NULL COMMENT '操作人',
  `status` tinyint(4) DEFAULT '0' COMMENT '0：正常，1：解除封禁，2：封禁，3：删除。',
  `change_pwd_time` int(10) DEFAULT NULL,
  `change_operator` varchar(50) DEFAULT NULL,
  `userlocation` varchar(50) DEFAULT NULL COMMENT '用户单位',
  PRIMARY KEY (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='用户表';

-- ----------------------------
-- Records of cms_users
-- ----------------------------
