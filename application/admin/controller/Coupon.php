<?php
//优惠券管理
namespace app\admin\controller;

use \think\Validate;
use app\common\controller\Base;
use think\Db;

class Coupon extends Base
{
    private $rule = [
        'title'  => 'require',
        'desc' => 'require',
        'number' => 'require',
        'price' => 'require',
        'starttime' => 'require',
        'endtime' => 'require',
    ];
    private $msg = [
        'name.require' => '优惠券名不能为空',
        'desc.require' => '优惠券简介不能为空',
        'price.require' => '优惠券价格不能为空',
        'number.require' => '优惠券数量不能为空',
        'starttime.require' => '优惠券开始时间不能为空',
        'endtime.require' => '优惠券结束时间不能为空',
    ];


    public function couponList($title = "", $starttime = "", $endtime = "", $type = "", $pageNo = 1, $pageSize = 10)
    {
        $user = $this->adminCheckLogin();
        if ($user['success']) {
            $sql = [];
            if ($title != "") {
                $sql['a.title'] = ['like', '%' . $title . '%'];
            }
            if ($type != '') {
                $sql['a.type'] = ['=', $type];
            }
            if ($starttime != "") {
                $sql['a.starttime'] = ["<=", $starttime];
                $sql['a.endtime'] = [">=", $endtime];
            }
            $data = Db::table('coupon')->alias("a")->join("good b", 'a.type=b.id')->where($sql)->field("a.*,b.label")->page($pageNo, $pageSize)->select();
            $total = Db::table('coupon')->alias("a")->where($sql)->count();
            $req = ['pageNo' => $pageNo, 'pageSize' => $pageSize, 'total' => $total, 'records' => $data];
            return $this->sendMsgSuccess($req);
        } else {
            return  $user;
        }
    }

    public function couponAdd()
    {
        $user = $this->adminCheckLogin();
        $req = $this->request;
        $validate = new Validate($this->rule, $this->msg);
        if ($user['success']) {
            $data = $req->param();
            if ($validate->check($data)) {
                if ($req->isPost()) {
                    $data = $req->param();
                    $data['createTime'] = time();
                    $data['updateTime'] = time();
                    $sql = Db::table("coupon")->insert($data);
                 return   $this->sendMsgSuccess($sql);
                } else {
                    return $this->sendMsgFail("请正确访问");
                }
            } else {
                return $this->sendMsgFail($validate->getError());
            }
        } else {
            return  $user;
        }
    }
}
