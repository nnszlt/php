/*
 Navicat Premium Data Transfer

 Source Server         : shop
 Source Server Type    : MySQL
 Source Server Version : 50721
 Source Host           : localhost:8889
 Source Schema         : shop

 Target Server Type    : MySQL
 Target Server Version : 50721
 File Encoding         : 65001

 Date: 06/11/2019 18:05:58
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for active
-- ----------------------------
DROP TABLE IF EXISTS `active`;
CREATE TABLE `active` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) NOT NULL COMMENT '活动类型 1 秒杀 2满减 3送券',
  `starttime` varchar(255) NOT NULL COMMENT '倒计时开始时间',
  `endtime` varchar(255) NOT NULL COMMENT '倒计时结束时间',
  `title` varchar(255) NOT NULL COMMENT '活动标题',
  `enable` int(255) NOT NULL COMMENT '0可用1不可用',
  `desc` varchar(255) DEFAULT NULL COMMENT '活动描述',
  `coupon` varchar(255) DEFAULT NULL COMMENT '优惠券id',
  `manjian` varchar(255) DEFAULT NULL COMMENT '满，减',
  `miaosha` varchar(255) DEFAULT NULL COMMENT '原价要减去秒杀价',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of active
-- ----------------------------
BEGIN;
INSERT INTO `active` VALUES (1, '1', '1572252277', '1582252277', '大减价', 0, '大减价活动', NULL, NULL, '20');
INSERT INTO `active` VALUES (2, '2', '1572252277', '1582252277', '满10减1', 0, '满10减1', NULL, '10,1', NULL);
INSERT INTO `active` VALUES (3, '1', '1569945600', '1573488000', '秒杀1', 0, '原价减90', NULL, NULL, '90');
INSERT INTO `active` VALUES (4, '2', '1569945600', '1573488000', '满减1', 0, '满100减10快', NULL, '100,1', NULL);
INSERT INTO `active` VALUES (5, '3', '1569945600', '1573488000', '送券1', 0, '送减50元优惠券', '1', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `id` int(255) NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `account` varchar(255) NOT NULL COMMENT '账号',
  `password` varchar(255) NOT NULL COMMENT '密码',
  `nikename` varchar(255) DEFAULT NULL COMMENT '昵称',
  `sex` int(255) DEFAULT NULL COMMENT '性别 0男 1女',
  `phone` varchar(255) DEFAULT NULL COMMENT '手机号',
  `menuAuth` varchar(255) NOT NULL DEFAULT '' COMMENT '后台菜单权限',
  `authKeys` varchar(255) DEFAULT NULL COMMENT '后台操作权限',
  `createTime` int(255) DEFAULT NULL COMMENT '创建时间',
  `enable` int(255) DEFAULT NULL COMMENT '启用状态 0关闭 1启用',
  `lastLoginTime` int(255) DEFAULT NULL COMMENT '上次登陆时间',
  `type` int(255) NOT NULL COMMENT '前后台可登录 0前台 1后台 2全部',
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of admin
-- ----------------------------
BEGIN;
INSERT INTO `admin` VALUES (1, 'admin', '202cb962ac59075b964b07152d234b70', '超级管理员', 1, NULL, 'A1,A2,A3,B1,B2,C1,C2,D1,D2,E1,E2,E3', '', 1571897684, 1, 1572936115, 2);
INSERT INTO `admin` VALUES (6, 'user01', '202cb962ac59075b964b07152d234b70', 'user01', 1, '18561487265', 'A1,A2,A3', '', 1571987539, 1, 1571987548, 1);
COMMIT;

-- ----------------------------
-- Table structure for authKey
-- ----------------------------
DROP TABLE IF EXISTS `authKey`;
CREATE TABLE `authKey` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT '操作权限名',
  `key` varchar(255) NOT NULL COMMENT '操作权限key',
  `authid` varchar(255) NOT NULL COMMENT '操作权限id',
  `Fpid` int(255) NOT NULL COMMENT '父级id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of authKey
-- ----------------------------
BEGIN;
INSERT INTO `authKey` VALUES (1, '产品管理', '0', '0', 0);
INSERT INTO `authKey` VALUES (2, '产品大类管理', '0', '0', 1);
COMMIT;

-- ----------------------------
-- Table structure for banner
-- ----------------------------
DROP TABLE IF EXISTS `banner`;
CREATE TABLE `banner` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT 'banner位置',
  `imgs` varchar(255) NOT NULL COMMENT 'banner 照片地址',
  `createTime` varchar(255) NOT NULL COMMENT '创建时间',
  `updateTime` varchar(255) NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of banner
-- ----------------------------
BEGIN;
INSERT INTO `banner` VALUES (1, '首页轮播', 'uploads/20191018/167acdb5f97895fa2f55e08f42389134.png,uploads/20191018/167acdb5f97895fa2f55e08f42389134.png', '1572232696', '1572232696');
INSERT INTO `banner` VALUES (2, 'weibu', 'uploads/20191028/cf0a3cc24c51a3761c0cab4b0d4966ad.jpg', '1572232667', '1572232667');
COMMIT;

-- ----------------------------
-- Table structure for coupon
-- ----------------------------
DROP TABLE IF EXISTS `coupon`;
CREATE TABLE `coupon` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL COMMENT '优惠券名',
  `desc` varchar(255) NOT NULL COMMENT '优惠券简介',
  `price` varchar(255) NOT NULL COMMENT '优惠价格',
  `starttime` varchar(255) NOT NULL COMMENT '优惠券开始时间',
  `endtime` varchar(255) NOT NULL COMMENT '优惠券结束时间',
  `type` varchar(255) DEFAULT NULL COMMENT '优惠券类型（产品大类）TY 通用',
  `createTime` varchar(255) DEFAULT NULL,
  `updateTime` varchar(255) DEFAULT NULL,
  `number` int(255) NOT NULL COMMENT '优惠券数量',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of coupon
-- ----------------------------
BEGIN;
INSERT INTO `coupon` VALUES (1, '减50', '全部类型减50', '50', '1572330092', '1582330092', '1', '1572330092', '1572330092', 100);
INSERT INTO `coupon` VALUES (3, '通用20', '通用20', '20', '1572883200', '1577289600', 'TY', '1573034330', '1573034330', 20);
INSERT INTO `coupon` VALUES (4, 'request.getContextPath()', '12', '12', '1572969600', '1576425600', '1', '1573034465', '1573034465', 12);
INSERT INTO `coupon` VALUES (5, 'request.getContextPath()', '12', '12', '1572969600', '1576425600', '1', '1573034484', '1573034484', 12);
COMMIT;

-- ----------------------------
-- Table structure for good
-- ----------------------------
DROP TABLE IF EXISTS `good`;
CREATE TABLE `good` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '节点自身唯一标识',
  `label` varchar(255) DEFAULT NULL,
  `Fpid` int(11) DEFAULT NULL COMMENT '父节点id',
  `enable` int(255) NOT NULL COMMENT '0不可用 1可用',
  `path` int(255) NOT NULL COMMENT '这条数据的结构',
  `createtime` int(255) NOT NULL,
  `updatetime` int(255) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of good
-- ----------------------------
BEGIN;
INSERT INTO `good` VALUES (1, '电子产品', 0, 1, 1, 1571117194, 1571117194);
INSERT INTO `good` VALUES (2, '食品', 0, 1, 2, 1571117204, 1571117204);
INSERT INTO `good` VALUES (3, '小米', 2, 1, 23, 1571125672, 1571125672);
INSERT INTO `good` VALUES (4, '大米', 2, 1, 24, 1571125712, 1571125712);
INSERT INTO `good` VALUES (5, '胶州小米', 3, 1, 235, 1571126817, 1571132044);
INSERT INTO `good` VALUES (6, '青岛小米', 3, 1, 236, 1571132052, 1571132052);
COMMIT;

-- ----------------------------
-- Table structure for goods
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT '产品名称',
  `price` int(255) NOT NULL COMMENT '价格',
  `number` int(11) NOT NULL COMMENT '库存',
  `mprice` int(255) NOT NULL COMMENT '市场价格',
  `no` varchar(255) NOT NULL COMMENT '产品型号',
  `enable` int(255) NOT NULL COMMENT '是否可用 0不可 1可以',
  `desc` varchar(255) DEFAULT NULL COMMENT '产品概述',
  `brand` varchar(255) DEFAULT NULL COMMENT '产品品牌',
  `like` int(255) DEFAULT '0' COMMENT '喜欢',
  `unit` varchar(255) NOT NULL COMMENT '计价单位',
  `imgs` varchar(255) NOT NULL COMMENT '产品图片',
  `type` varchar(255) NOT NULL COMMENT '产品类型',
  `volume` int(255) unsigned DEFAULT '0' COMMENT '销量',
  `label` varchar(255) DEFAULT NULL COMMENT '标签',
  `content` longtext COMMENT '产品详情介绍',
  `commentid` varchar(255) DEFAULT NULL COMMENT '评论id',
  `path` varchar(255) NOT NULL COMMENT '产品分类path',
  `createtime` int(255) NOT NULL COMMENT '创建时间',
  `updatetime` int(255) NOT NULL COMMENT '更新时间',
  `activeid` int(11) DEFAULT NULL COMMENT '活动的id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of goods
-- ----------------------------
BEGIN;
INSERT INTO `goods` VALUES (9, '手机', 3999, 89, 2999, '76542', 0, '', 'apple', 0, '台', 'uploads/20191018/167acdb5f97895fa2f55e08f42389134.png', '1', 0, '23,24', '', NULL, '1', 1572240607, 1572240607, 1);
INSERT INTO `goods` VALUES (10, '食品', 3999, 89, 2999, '76542', 0, '', 'apple', 0, '台', 'uploads/20191018/167acdb5f97895fa2f55e08f42389134.png', '2', 0, '', '', NULL, '2', 1571380807, 1571380807, 1);
INSERT INTO `goods` VALUES (11, '小米', 3999, 89, 2999, '76542', 0, '', 'apple', 0, '台', 'uploads/20191018/167acdb5f97895fa2f55e08f42389134.png', '3', 0, '', '', NULL, '23', 1571380816, 1571380816, NULL);
INSERT INTO `goods` VALUES (12, '大米', 3999, 89, 2999, '76542', 0, '', 'apple', 0, '台', 'uploads/20191018/167acdb5f97895fa2f55e08f42389134.png', '4', 0, '', '', NULL, '24', 1571380823, 1571380823, NULL);
INSERT INTO `goods` VALUES (13, '青岛小米', 3999, 89, 2999, '76542', 0, '', 'apple', 0, '台', 'uploads/20191018/167acdb5f97895fa2f55e08f42389134.png', '6', 0, '', '', NULL, '236', 1571380831, 1571380831, NULL);
INSERT INTO `goods` VALUES (14, '手机', 3999, 89, 2999, '76542', 0, '', 'apple', 0, '台', 'uploads/20191018/167acdb5f97895fa2f55e08f42389134.png', '1', 0, '', '<p>asdasd&nbsp; sad sad asasdasd&nbsp; sad sad asasdasd&nbsp; sad sad asasdasd&nbsp; sad sad as</p>', NULL, '1', 1571818217, 1571818217, NULL);
INSERT INTO `goods` VALUES (15, '手机', 3999, 89, 2999, '76542', 0, '', 'apple', 0, '台', 'uploads/20191018/167acdb5f97895fa2f55e08f42389134.png', '1', 0, '', '<p>asndasmdnas,mdansdasdasd</p>', NULL, '1', 1571818236, 1571818236, NULL);
INSERT INTO `goods` VALUES (16, '手机', 3999, 89, 2999, '76542', 0, '', 'apple', 0, '台', 'uploads/20191018/167acdb5f97895fa2f55e08f42389134.png', '1', 0, '', '', NULL, '1', 1571818564, 1571818564, NULL);
INSERT INTO `goods` VALUES (17, '手机', 3999, 89, 2999, '76542', 0, '', 'apple', 0, '台', 'uploads/20191018/167acdb5f97895fa2f55e08f42389134.png', '1', 0, '', '', NULL, '1', 1571818598, 1571818598, NULL);
INSERT INTO `goods` VALUES (18, '手机', 3999, 89, 2999, '76542', 0, '', 'apple', 0, '台', 'uploads/20191018/167acdb5f97895fa2f55e08f42389134.png', '1', 0, '', '', NULL, '1', 1571818626, 1571818626, NULL);
INSERT INTO `goods` VALUES (19, '手机', 3999, 89, 2999, '76542', 0, '', 'apple', 0, '台', 'uploads/20191018/167acdb5f97895fa2f55e08f42389134.png', '1', 0, '', '', NULL, '1', 1571818707, 1571818707, NULL);
INSERT INTO `goods` VALUES (20, '手机', 3999, 89, 2999, '76542', 0, '', 'apple', 0, '台', 'uploads/20191018/167acdb5f97895fa2f55e08f42389134.png', '1', 0, '', '<p>12312312</p>', NULL, '1', 1571819255, 1571819255, NULL);
COMMIT;

-- ----------------------------
-- Table structure for menuAuth
-- ----------------------------
DROP TABLE IF EXISTS `menuAuth`;
CREATE TABLE `menuAuth` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL COMMENT '后台访问菜单名',
  `menuid` varchar(255) NOT NULL COMMENT '后台访问菜单id',
  `Fpid` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of menuAuth
-- ----------------------------
BEGIN;
INSERT INTO `menuAuth` VALUES (1, '产品管理', 'A1', 0);
INSERT INTO `menuAuth` VALUES (2, '产品大类管理', 'A2', 1);
INSERT INTO `menuAuth` VALUES (3, '产品列表管理', 'A3', 1);
INSERT INTO `menuAuth` VALUES (4, '标签管理', 'B1', 0);
INSERT INTO `menuAuth` VALUES (5, '标签列表', 'B2', 4);
INSERT INTO `menuAuth` VALUES (6, '用户管理', 'C1', 0);
INSERT INTO `menuAuth` VALUES (7, '用户列表', 'C2', 6);
INSERT INTO `menuAuth` VALUES (8, '轮播管理', 'D1', 0);
INSERT INTO `menuAuth` VALUES (9, '轮播列表', 'D2', 8);
INSERT INTO `menuAuth` VALUES (10, '活动管理', 'E1', 0);
INSERT INTO `menuAuth` VALUES (11, '活动列表', 'E2', 10);
INSERT INTO `menuAuth` VALUES (12, '优惠券列表', 'E3', 10);
COMMIT;

-- ----------------------------
-- Table structure for message
-- ----------------------------
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `userid` int(255) NOT NULL COMMENT '用户id',
  `isDel` int(255) NOT NULL COMMENT '是否删除 0没 1删了',
  `type` int(255) NOT NULL COMMENT '消息类型 0没读 1读了 2回收站',
  `title` varchar(255) NOT NULL COMMENT '标题',
  `content` varchar(255) DEFAULT NULL COMMENT '内容',
  `createtime` varchar(255) NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of message
-- ----------------------------
BEGIN;
INSERT INTO `message` VALUES (1, 1, 0, 0, '测试未读', '测试未读', '1571017461000');
INSERT INTO `message` VALUES (2, 1, 0, 0, '测试已读', '测试已读', '1571017461000');
INSERT INTO `message` VALUES (3, 1, 0, 0, '测试回收站', '测试回收站', '1571017461000');
INSERT INTO `message` VALUES (4, 1, 0, 1, '测试未读1', '测试未读1', '1571021240000');
COMMIT;

-- ----------------------------
-- Table structure for pool
-- ----------------------------
DROP TABLE IF EXISTS `pool`;
CREATE TABLE `pool` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rwmc` varchar(255) DEFAULT NULL COMMENT '任务名称',
  `htbh` varchar(255) DEFAULT NULL COMMENT '合同编号',
  `ddbh` varchar(255) DEFAULT NULL COMMENT '订单编号',
  `gysid` varchar(255) DEFAULT NULL COMMENT '供应商ID',
  `gysmc` varchar(255) DEFAULT NULL COMMENT '供应商名称',
  `gysjc` varchar(255) DEFAULT NULL COMMENT '供应商简称',
  `cgdwid` varchar(255) DEFAULT NULL COMMENT '采购单位ID',
  `cgdw` varchar(255) DEFAULT NULL COMMENT '采购单位',
  `xqgkbm` varchar(255) DEFAULT NULL COMMENT '需求归口部门',
  `rwfqr` varchar(255) DEFAULT NULL COMMENT '任务发起人',
  `ddsj` varchar(255) DEFAULT NULL COMMENT '订单时间',
  `spzs` varchar(255) DEFAULT NULL COMMENT '商品总数',
  `ddzj` double(255,2) DEFAULT NULL COMMENT '订单总价',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pool
-- ----------------------------
BEGIN;
INSERT INTO `pool` VALUES (1, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190930184758374', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '376466', '长沙分行', '长沙分行', '李运恒', '2019-09-30 18:47:58', '30', 6870.00);
INSERT INTO `pool` VALUES (2, '关于《晨光》的评价', '2017-ZH-0176-OE-01', 'PR20190927192418212', '452', '北京东方金鹰信息科技股份有限公司', '东方金鹰', '376466', '长沙分行', '长沙分行', '李运恒', '2019-09-27 19:24:18', '50', 1009.30);
INSERT INTO `pool` VALUES (3, '关于《中信得力协议》的评价11111', '2017-ZH-0176-OE-04', 'PR20190929145932857', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '32811', '广州分行', '广州分行', '王尔烟', '2019-09-29 14:59:32', '3', 59.00);
INSERT INTO `pool` VALUES (4, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190926163646668', '3389', '北京联某科技有限公司', '0922测试03', '183825', '合肥分行', '合肥分行', '孙天和', '2019-09-26 16:36:46', '1', 1105.00);
INSERT INTO `pool` VALUES (5, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190927154038162', '3389', '北京联某科技有限公司', '0922测试03', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-27 15:40:38', '5', 675.00);
INSERT INTO `pool` VALUES (6, '关于《中信齐心协议》的评价', '2017-ZH-0176-OE-02', 'PR20190925104913591', '3380', '3', '4444', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-25 10:49:13', '1', 817.00);
INSERT INTO `pool` VALUES (7, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190924103031021', '3389', '北京联某科技有限公司', '0922测试03', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-24 10:30:31', '5', 47.00);
INSERT INTO `pool` VALUES (8, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190927171421345', '3389', '北京联某科技有限公司', '0922测试03', '134803', '上海分行', '上海分行', '王惜海', '2019-09-27 17:14:21', '3', 111.00);
INSERT INTO `pool` VALUES (9, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190911152418288', '3389', '北京联某科技有限公司', '0922测试03', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-11 15:24:18', '50', 495.00);
INSERT INTO `pool` VALUES (10, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190926104022199', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '134803', '上海分行', '上海分行', '赵向晨', '2019-09-26 10:40:22', '60', 202.00);
INSERT INTO `pool` VALUES (11, '关于《晨光》的评价', '2017-ZH-0176-OE-01', 'PR20190926103153606', '452', '北京东方金鹰信息科技股份有限公司', '东方金鹰', '32811', '广州分行', '广州分行', '孙春燕', '2019-09-26 10:31:53', '1', 32.00);
INSERT INTO `pool` VALUES (12, '关于《晨光》的评价', '2017-ZH-0176-OE-01', 'PR20190926105649982', '452', '北京东方金鹰信息科技股份有限公司', '东方金鹰', '32811', '广州分行', '广州分行', '孙春燕', '2019-09-26 10:56:50', '1', 124.00);
INSERT INTO `pool` VALUES (13, '关于《晨光》的评价', '2017-ZH-0176-OE-01', 'PR20190925180321376', '452', '北京东方金鹰信息科技股份有限公司', '东方金鹰', '32811', '广州分行', '广州分行', '孙春燕', '2019-09-25 18:03:21', '50', 42.00);
INSERT INTO `pool` VALUES (14, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190924101515760', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '183825', '合肥分行', '合肥分行', '孙天和', '2019-09-24 10:15:15', '4', 254.00);
INSERT INTO `pool` VALUES (15, '关于《中信齐心协议》的评价', '2017-ZH-0176-OE-02', 'PR20190923103656140', '3380', '3', '4444', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-23 10:36:56', '820', 3261.00);
INSERT INTO `pool` VALUES (16, '关于《晨光》的评价', '2017-ZH-0176-OE-01', 'PR20190926091746859', '452', '北京东方金鹰信息科技股份有限公司', '东方金鹰', '32811', '广州分行', '广州分行', '孙春燕', '2019-09-26 09:17:46', '13', 1428.00);
INSERT INTO `pool` VALUES (17, '关于《中信齐心协议》的评价', '2017-ZH-0176-OE-02', 'PR20190924102955170', '3380', '3', '4444', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-24 10:29:55', '200', 234.00);
INSERT INTO `pool` VALUES (18, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190924103826334', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '163791', '哈尔滨分行', '哈尔滨分行', '李微婉', '2019-09-24 10:38:26', '2', 302.00);
INSERT INTO `pool` VALUES (19, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190920103516277', '3389', '北京联某科技有限公司', '0922测试03', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-20 10:35:16', '15', 123.00);
INSERT INTO `pool` VALUES (20, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190920104301857', '3389', '北京联某科技有限公司', '0922测试03', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-20 10:43:01', '2', 34.00);
INSERT INTO `pool` VALUES (21, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190912142618028', '3389', '北京联某科技有限公司', '0922测试03', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-12 14:26:18', '229', 2804.00);
INSERT INTO `pool` VALUES (22, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190916100324567', '3389', '北京联某科技有限公司', '0922测试03', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-16 10:03:24', '135', 417.00);
INSERT INTO `pool` VALUES (23, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190925180838887', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '32811', '广州分行', '广州分行', '孙春燕', '2019-09-25 18:08:38', '2', 3.00);
INSERT INTO `pool` VALUES (24, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190918145053475', '3389', '北京联某科技有限公司', '0922测试03', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-18 14:50:53', '63', 1678.00);
INSERT INTO `pool` VALUES (25, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190903151914887', '3389', '北京联某科技有限公司', '0922测试03', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-03 15:19:14', '60', 58.00);
INSERT INTO `pool` VALUES (26, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190910163726049', '3389', '北京联某科技有限公司', '0922测试03', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-10 16:37:26', '26', 120.00);
INSERT INTO `pool` VALUES (27, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190919161532313', '3389', '北京联某科技有限公司', '0922测试03', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-19 16:15:32', '20', 175.00);
INSERT INTO `pool` VALUES (28, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190920145136227', '3389', '北京联某科技有限公司', '0922测试03', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-20 14:51:36', '137', 1034.00);
INSERT INTO `pool` VALUES (29, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190925100313861', '3389', '北京联某科技有限公司', '0922测试03', '134803', '上海分行', '上海分行', '赵奕', '2019-09-25 10:03:13', '6', 22.00);
INSERT INTO `pool` VALUES (30, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190916105852010', '3389', '北京联某科技有限公司', '0922测试03', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-16 10:58:52', '167', 4978.00);
INSERT INTO `pool` VALUES (31, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190905171658011', '3389', '北京联某科技有限公司', '0922测试03', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-05 17:16:58', '226', 832.00);
INSERT INTO `pool` VALUES (32, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190905134139118', '3389', '北京联某科技有限公司', '0922测试03', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-05 13:41:39', '2', 124.00);
INSERT INTO `pool` VALUES (33, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190920103947179', '3389', '北京联某科技有限公司', '0922测试03', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-20 10:39:47', '40', 4627.00);
INSERT INTO `pool` VALUES (34, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190912142158118', '3389', '北京联某科技有限公司', '0922测试03', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-12 14:21:58', '1', 399.00);
INSERT INTO `pool` VALUES (35, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190924100859584', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '32811', '广州分行', '广州分行', '孙春燕', '2019-09-24 10:08:59', '5', 90.00);
INSERT INTO `pool` VALUES (36, '关于《中信齐心协议》的评价', '2017-ZH-0176-OE-02', 'PR20190911155546645', '3380', '3', '4444', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-11 15:55:46', '200', 780.00);
INSERT INTO `pool` VALUES (37, '关于《晨光》的评价', '2017-ZH-0176-OE-01', 'PR20190920104233357', '452', '北京东方金鹰信息科技股份有限公司', '东方金鹰', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-20 10:42:33', '3', 40.00);
INSERT INTO `pool` VALUES (38, '关于《晨光》的评价', '2017-ZH-0176-OE-01', 'PR20190920145101501', '452', '北京东方金鹰信息科技股份有限公司', '东方金鹰', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-20 14:51:01', '144', 819.00);
INSERT INTO `pool` VALUES (39, '关于《晨光》的评价', '2017-ZH-0176-OE-01', 'PR20190920144646431', '452', '北京东方金鹰信息科技股份有限公司', '东方金鹰', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-20 14:46:46', '2', 1320.00);
INSERT INTO `pool` VALUES (40, '关于《晨光》的评价', '2017-ZH-0176-OE-01', 'PR20190920103407637', '452', '北京东方金鹰信息科技股份有限公司', '东方金鹰', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-20 10:34:07', '120', 837.00);
INSERT INTO `pool` VALUES (41, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190920175128840', '3389', '北京联某科技有限公司', '0922测试03', '376466', '长沙分行', '长沙分行', '李运恒', '2019-09-20 17:51:28', '15', 83.00);
INSERT INTO `pool` VALUES (42, '关于《晨光》的评价', '2017-ZH-0176-OE-01', 'PR20190919173846834', '452', '北京东方金鹰信息科技股份有限公司', '东方金鹰', '376466', '长沙分行', '长沙分行', '李运恒', '2019-09-19 17:38:46', '50', 220.00);
INSERT INTO `pool` VALUES (43, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190920175002790', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '376466', '长沙分行', '长沙分行', '李运恒', '2019-09-20 17:50:02', '25', 45.00);
INSERT INTO `pool` VALUES (44, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190927190330094', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '376466', '长沙分行', '长沙分行', '李运恒', '2019-09-27 19:03:30', '115', 10693.00);
INSERT INTO `pool` VALUES (45, '关于《中信齐心协议》的评价', '2017-ZH-0176-OE-02', 'PR20190912142523050', '3380', '3', '4444', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-12 14:25:23', '30', 106.00);
INSERT INTO `pool` VALUES (46, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190919111507920', '3389', '北京联某科技有限公司', '0922测试03', '191822', '沈阳分行', '沈阳分行', '王静枫', '2019-09-19 11:15:08', '3', 114.00);
INSERT INTO `pool` VALUES (47, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190919170250534', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '376466', '长沙分行', '长沙分行', '李运恒', '2019-09-19 17:02:50', '155', 1183.00);
INSERT INTO `pool` VALUES (48, '关于《晨光》的评价', '2017-ZH-0176-OE-01', 'PR20190910175251530', '452', '北京东方金鹰信息科技股份有限公司', '东方金鹰', '32811', '广州分行', '广州分行', '孙春燕', '2019-09-10 17:52:51', '5', 254.00);
INSERT INTO `pool` VALUES (49, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190925175139747', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '376466', '长沙分行', '长沙分行', '李运恒', '2019-09-25 17:51:39', '20', 62.00);
INSERT INTO `pool` VALUES (50, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190930145611351', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '191822', '沈阳分行', '沈阳分行', '王静枫', '2019-09-30 14:56:11', '2', 48.00);
INSERT INTO `pool` VALUES (51, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190916172512877', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '32811', '广州分行', '广州分行', '赵伟彦', '2019-09-16 17:25:12', '4', 158.00);
INSERT INTO `pool` VALUES (52, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190924171538738', '3389', '北京联某科技有限公司', '0922测试03', '376466', '长沙分行', '长沙分行', '李运恒', '2019-09-24 17:15:38', '2', 136.00);
INSERT INTO `pool` VALUES (53, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190926120712031', '3389', '北京联某科技有限公司', '0922测试03', '191822', '沈阳分行', '沈阳分行', '王静枫', '2019-09-26 12:07:12', '3', 25.00);
INSERT INTO `pool` VALUES (54, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190916173117716', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '32811', '广州分行', '广州分行', '赵伟彦', '2019-09-16 17:31:17', '1', 49.00);
INSERT INTO `pool` VALUES (55, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190920135600906', '3389', '北京联某科技有限公司', '0922测试03', '191822', '沈阳分行', '沈阳分行', '王静枫', '2019-09-20 13:56:00', '2', 487.00);
INSERT INTO `pool` VALUES (56, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190919104856990', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '32811', '广州分行', '广州分行', '赵伟彦', '2019-09-19 10:48:57', '1', 40.00);
INSERT INTO `pool` VALUES (57, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190906154354972', '3389', '北京联某科技有限公司', '0922测试03', '134803', '上海分行', '上海分行', '赵恨蕊', '2019-09-06 15:43:55', '4', 31.00);
INSERT INTO `pool` VALUES (58, '关于《中信齐心协议》的评价', '2017-ZH-0176-OE-02', 'PR20190916100252008', '3380', '3', '4444', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-16 10:02:52', '50', 1219.00);
INSERT INTO `pool` VALUES (59, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190905100300478', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '142830', '总行', '总行', '王晨曦', '2019-09-05 10:03:00', '2', 1018.00);
INSERT INTO `pool` VALUES (60, '关于《中信齐心协议》的评价', '2017-ZH-0176-OE-02', 'PR20190918170731494', '3380', '3', '4444', '32811', '广州分行', '广州分行', '孙春燕', '2019-09-18 17:07:31', '1', 63.00);
INSERT INTO `pool` VALUES (61, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190925180443283', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '376466', '长沙分行', '长沙分行', '李运恒', '2019-09-25 18:04:43', '40', 7771.12);
INSERT INTO `pool` VALUES (62, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190924102405771', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '376466', '长沙分行', '长沙分行', '李运恒', '2019-09-24 10:24:05', '34', 5376.00);
INSERT INTO `pool` VALUES (63, '关于《晨光》的评价', '2017-ZH-0176-OE-01', 'PR20190918171019963', '452', '北京东方金鹰信息科技股份有限公司', '东方金鹰', '32811', '广州分行', '广州分行', '孙春燕', '2019-09-18 17:10:19', '2', 248.00);
INSERT INTO `pool` VALUES (64, '关于《晨光》的评价', '2017-ZH-0176-OE-01', 'PR20190918090609433', '452', '北京东方金鹰信息科技股份有限公司', '东方金鹰', '183825', '合肥分行', '合肥分行', '孙天和', '2019-09-18 09:06:09', '20', 409.00);
INSERT INTO `pool` VALUES (65, '关于《晨光》的评价', '2017-ZH-0176-OE-01', 'PR20190918085938292', '452', '北京东方金鹰信息科技股份有限公司', '东方金鹰', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-18 08:59:38', '2', 80.00);
INSERT INTO `pool` VALUES (66, '关于《晨光》的评价', '2017-ZH-0176-OE-01', 'PR20190926123123049', '452', '北京东方金鹰信息科技股份有限公司', '东方金鹰', '191822', '沈阳分行', '沈阳分行', '王静枫', '2019-09-26 12:31:23', '4', 117.00);
INSERT INTO `pool` VALUES (67, '关于《中信齐心协议》的评价', '2017-ZH-0176-OE-02', 'PR20190918104948666', '3380', '3', '4444', '32811', '广州分行', '广州分行', '赵伟彦', '2019-09-18 10:49:48', '1', 593.00);
INSERT INTO `pool` VALUES (68, '关于《欧菲斯》的评价', '2017-ZH-0176-OE-03', 'PR20190924103354021', '3389', '北京联某科技有限公司', '0922测试03', '376466', '长沙分行', '长沙分行', '李运恒', '2019-09-24 10:33:54', '25', 43.00);
INSERT INTO `pool` VALUES (69, '关于《晨光》的评价', '2017-ZH-0176-OE-01', 'PR20190919111923312', '452', '北京东方金鹰信息科技股份有限公司', '东方金鹰', '32811', '广州分行', '广州分行', '赵伟彦', '2019-09-19 11:19:23', '50', 30.00);
INSERT INTO `pool` VALUES (70, '关于《晨光》的评价', '2017-ZH-0176-OE-01', 'PR20190912142449271', '452', '北京东方金鹰信息科技股份有限公司', '东方金鹰', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-12 14:24:49', '110', 145.00);
INSERT INTO `pool` VALUES (71, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190911134008908', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '134803', '上海分行', '上海分行', '王惜海', '2019-09-11 13:40:08', '3', 230.00);
INSERT INTO `pool` VALUES (72, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190910094718466', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '134803', '上海分行', '上海分行', '赵向晨', '2019-09-10 09:47:18', '11', 75.00);
INSERT INTO `pool` VALUES (73, '关于《晨光》的评价', '2017-ZH-0176-OE-01', 'PR20190916105750726', '452', '北京东方金鹰信息科技股份有限公司', '东方金鹰', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-16 10:57:50', '371', 1352.00);
INSERT INTO `pool` VALUES (74, '关于《晨光》的评价', '2017-ZH-0176-OE-01', 'PR20190912085016659', '452', '北京东方金鹰信息科技股份有限公司', '东方金鹰', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-12 08:50:16', '5', 110.00);
INSERT INTO `pool` VALUES (75, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190924102504524', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '376466', '长沙分行', '长沙分行', '李运恒', '2019-09-24 10:25:04', '77', 2232.00);
INSERT INTO `pool` VALUES (76, '关于《中信齐心协议》的评价', '2017-ZH-0176-OE-02', 'PR20190912164053195', '3380', '3', '4444', '32811', '广州分行', '广州分行', '孙春燕', '2019-09-12 16:40:53', '5', 185.00);
INSERT INTO `pool` VALUES (77, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190923110108729', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '191822', '沈阳分行', '沈阳分行', '王静枫', '2019-09-23 11:01:08', '3', 142.00);
INSERT INTO `pool` VALUES (78, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190910182738802', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '134803', '上海分行', '上海分行', '赵恨蕊', '2019-09-10 18:27:38', '4', 1996.00);
INSERT INTO `pool` VALUES (79, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190916075827672', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '134803', '上海分行', '上海分行', '吴怀薇', '2019-09-16 07:58:27', '2', 76.00);
INSERT INTO `pool` VALUES (80, '关于《晨光》的评价', '2017-ZH-0176-OE-01', 'PR20190917134405855', '452', '北京东方金鹰信息科技股份有限公司', '东方金鹰', '32811', '广州分行', '广州分行', '赵寒梅', '2019-09-17 13:44:05', '1', 527.00);
INSERT INTO `pool` VALUES (81, '关于《中信齐心协议》的评价', '2017-ZH-0176-OE-02', 'PR20190916164403058', '3380', '3', '4444', '32811', '广州分行', '广州分行', '孙春燕', '2019-09-16 16:44:03', '1', 3.00);
INSERT INTO `pool` VALUES (82, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190903183958084', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '32811', '广州分行', '广州分行', '赵伟彦', '2019-09-03 18:39:58', '1', 524.00);
INSERT INTO `pool` VALUES (83, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190918105203097', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '32811', '广州分行', '广州分行', '赵伟彦', '2019-09-18 10:52:03', '2', 238.00);
INSERT INTO `pool` VALUES (84, '关于《中信齐心协议》的评价', '2017-ZH-0176-OE-02', 'PR20190925095043900', '3380', '3', '4444', '191822', '沈阳分行', '沈阳分行', '王静枫', '2019-09-25 09:50:43', '7', 224.00);
INSERT INTO `pool` VALUES (85, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190923110656122', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '376466', '长沙分行', '长沙分行', '李运恒', '2019-09-23 11:06:56', '105', 1193.00);
INSERT INTO `pool` VALUES (86, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190925133349747', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '191822', '沈阳分行', '沈阳分行', '王静枫', '2019-09-25 13:33:49', '3', 126.00);
INSERT INTO `pool` VALUES (87, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190923110524875', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '376466', '长沙分行', '长沙分行', '李运恒', '2019-09-23 11:05:24', '21', 2903.00);
INSERT INTO `pool` VALUES (88, '关于《中信齐心协议》的评价', '2017-ZH-0176-OE-02', 'PR20190916112036200', '3380', '3', '4444', '5200', '南昌分行', '南昌分行', '王天元', '2019-09-16 11:20:36', '60', 171.00);
INSERT INTO `pool` VALUES (89, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190918111914704', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '376466', '长沙分行', '长沙分行', '李运恒', '2019-09-18 11:19:14', '151', 1009.20);
INSERT INTO `pool` VALUES (90, '关于《中信齐心协议》的评价', '2017-ZH-0176-OE-02', 'PR20190916183541577', '3380', '3', '4444', '134803', '上海分行', '上海分行', '赵向晨', '2019-09-16 18:35:41', '2', 117.00);
INSERT INTO `pool` VALUES (91, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190905134107291', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-05 13:41:07', '5', 101.00);
INSERT INTO `pool` VALUES (92, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190906095755908', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '56840', '南京分行', '南京分行', '赵青亦', '2019-09-06 09:57:56', '5', 245.00);
INSERT INTO `pool` VALUES (93, '关于《晨光》的评价', '2017-ZH-0176-OE-01', 'PR20190912154402814', '452', '北京东方金鹰信息科技股份有限公司', '东方金鹰', '32811', '广州分行', '广州分行', '赵从蓉', '2019-09-12 15:44:02', '4', 447.00);
INSERT INTO `pool` VALUES (94, '关于《晨光》的评价', '2017-ZH-0176-OE-01', 'PR20190912100119738', '452', '北京东方金鹰信息科技股份有限公司', '东方金鹰', '32811', '广州分行', '广州分行', '孙春燕', '2019-09-12 10:01:19', '1', 124.00);
INSERT INTO `pool` VALUES (95, '关于《晨光》的评价', '2017-ZH-0176-OE-01', 'PR20190917172935613', '452', '北京东方金鹰信息科技股份有限公司', '东方金鹰', '191822', '沈阳分行', '沈阳分行', '王静枫', '2019-09-17 17:29:35', '20', 43.00);
INSERT INTO `pool` VALUES (96, '关于《中信得力协议》的评价', '2017-ZH-0176-OE-04', 'PR20190910091109112', '3387', '深圳市银之杰科技股份有限公司', '银之杰', '220249', '深圳分行', '深圳分行', '王白萱', '2019-09-10 09:11:09', '20', 215.00);
INSERT INTO `pool` VALUES (97, '关于《晨光》的评价', '2017-ZH-0176-OE-01', 'PR20190906165207088', '452', '北京东方金鹰信息科技股份有限公司', '东方金鹰', '5200', '南昌分行', '南昌分行', '王天元', '2019-09-06 16:52:07', '258', 5580.00);
INSERT INTO `pool` VALUES (98, '关于《晨光》的评价', '2017-ZH-0176-OE-01', 'PR20190909160258415', '452', '北京东方金鹰信息科技股份有限公司', '东方金鹰', '183825', '合肥分行', '合肥分行', '王吟怀', '2019-09-09 16:02:58', '17', 415.00);
INSERT INTO `pool` VALUES (99, 'zlt', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `pool` VALUES (100, 'zcc100', '71', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `pool` VALUES (101, 'zcc100', '90', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `pool` VALUES (102, 'zlt', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `pool` VALUES (104, 'zlt', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `pool` VALUES (105, 'zlt', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `pool` VALUES (106, 'zlt', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `pool` VALUES (107, 'zcc107', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `pool` VALUES (108, 'zcczcc', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `pool` VALUES (109, '任务名称1', '2019-10-11', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `pool` VALUES (110, '110', '2019-10-11', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `pool` VALUES (111, '111', '2019-10-11', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `pool` VALUES (112, '支付宝', '2019-10-12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `pool` VALUES (113, '百度宝', '2019-10-13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `pool` VALUES (114, '来了包1', '2019-10-11', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `pool` VALUES (115, '微信包', '2019-10-11', NULL, NULL, '应知己', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `pool` VALUES (116, '支付宝', '2019-10-12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `pool` VALUES (117, '美团宝', '2019-10-12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `pool` VALUES (118, 'thinkphp', '2019-10-12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `pool` VALUES (119, '支付宝1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `pool` VALUES (120, '百度宝1', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `pool` VALUES (121, 'thinkphp2', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `pool` VALUES (122, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2013-10-01 12:23:14', NULL, NULL);
INSERT INTO `pool` VALUES (123, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2013-10-01 12:23:14', NULL, NULL);
INSERT INTO `pool` VALUES (124, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2013-10-01 12:23:14', NULL, NULL);
INSERT INTO `pool` VALUES (125, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2013-10-01 12:23:14', NULL, NULL);
INSERT INTO `pool` VALUES (126, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1570860438', NULL, NULL);
INSERT INTO `pool` VALUES (127, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1570860441', NULL, NULL);
INSERT INTO `pool` VALUES (128, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1570860442', NULL, NULL);
INSERT INTO `pool` VALUES (129, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1570860442', NULL, NULL);
INSERT INTO `pool` VALUES (130, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1570860443', NULL, NULL);
INSERT INTO `pool` VALUES (131, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1570860443', NULL, NULL);
INSERT INTO `pool` VALUES (132, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1570860634', NULL, NULL);
INSERT INTO `pool` VALUES (133, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1570860641', NULL, NULL);
INSERT INTO `pool` VALUES (134, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '1570860802', NULL, NULL);
INSERT INTO `pool` VALUES (135, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2019-10-10', NULL, NULL);
INSERT INTO `pool` VALUES (136, '可以删除', '2019-10-12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `pool` VALUES (137, '可以删除', '2019-10-12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for tags
-- ----------------------------
DROP TABLE IF EXISTS `tags`;
CREATE TABLE `tags` (
  `id` int(255) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT '标签名',
  `enable` int(255) NOT NULL COMMENT '0可用 1不可用',
  `content` varchar(255) DEFAULT NULL COMMENT '标签的简介',
  `createtime` int(255) NOT NULL COMMENT '创建时间',
  `updatetime` int(255) NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tags
-- ----------------------------
BEGIN;
INSERT INTO `tags` VALUES (3, '123', 1, '123', 1571206340, 1571207671);
INSERT INTO `tags` VALUES (4, '12', 0, '12123', 1571206726, 1571210584);
INSERT INTO `tags` VALUES (5, 'wode', 0, '', 1571208912, 1571208912);
INSERT INTO `tags` VALUES (6, '23', 0, '未', 1571210604, 1571210604);
INSERT INTO `tags` VALUES (7, '企鹅', 0, '企鹅去玩', 1571210608, 1571210608);
INSERT INTO `tags` VALUES (8, '123', 0, '123', 1571210696, 1571210696);
INSERT INTO `tags` VALUES (9, '阿斯顿', 0, '', 1571210700, 1571210700);
INSERT INTO `tags` VALUES (10, '去', 0, '', 1571210704, 1571210704);
INSERT INTO `tags` VALUES (11, '我', 0, '', 1571210707, 1571210707);
INSERT INTO `tags` VALUES (12, '鹅', 0, '', 1571210710, 1571210710);
INSERT INTO `tags` VALUES (13, '人', 0, '', 1571210713, 1571210713);
INSERT INTO `tags` VALUES (14, '天', 0, '', 1571210716, 1571210716);
INSERT INTO `tags` VALUES (15, '啊', 0, '', 1571210720, 1571210720);
INSERT INTO `tags` VALUES (16, '是', 0, '', 1571210724, 1571210724);
INSERT INTO `tags` VALUES (17, '福', 0, '', 1571210728, 1571210728);
INSERT INTO `tags` VALUES (18, '干', 0, '', 1571210731, 1571210731);
INSERT INTO `tags` VALUES (19, '好', 0, '', 1571210734, 1571210734);
INSERT INTO `tags` VALUES (20, '姐', 0, '', 1571210737, 1571210737);
INSERT INTO `tags` VALUES (21, '这', 0, '', 1571210742, 1571210742);
INSERT INTO `tags` VALUES (22, '小', 0, '', 1571210746, 1571210746);
INSERT INTO `tags` VALUES (23, '才', 0, '', 1571210750, 1571210750);
INSERT INTO `tags` VALUES (24, '才v', 0, '', 1571210759, 1571210759);
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
