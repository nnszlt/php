<?php
//消息中心
namespace app\admin\controller;

use app\common\controller\Base;
use think\Db;
use app\admin\model\Active as Mactive;

class Active extends Base
{

    public function addActive()
    {
        $user = $this->adminCheckLogin();
        $req = $this->request;
        // $validate = new Validate($this->rule, $this->msg);
        if ($user['success']) {
            if ($req->isPost()) {
                $data = $req->param();
                // if ($validate->check($data)) {

                $id = Mactive::create($data);

                return $this->sendMsgSuccess();
                // } else {
                //     return $this->sendMsgFail($validate->getError());
                // }
            } else {
                $this->sendMsgFail("请正确访问");
            }
        } else {
            return  $user;
        }
    }


    public function editActive()
    {
        $user = $this->adminCheckLogin();
        $req = $this->request;
        if ($user['success']) {
            if ($req->isPost()) {
                $data = $req->param();
                dump($data);
                exit();
                $id = Mactive::create($data);
                return $this->sendMsgSuccess();
            } else {
                $this->sendMsgFail("请正确访问");
            }
        } else {
            return  $user;
        }
    }
    public function listActive($type = '', $starttime = "", $endtime = "", $title = "", $enable = "", $pageNo = 1, $pageSize = 10, $from = "1")
    {

        if ($from == 1) {
            $data = Db::table('active')->where(self::sqlChange($type, $starttime, $endtime, $title, $enable, $from))->page($pageNo, $pageSize)->select();
        } else {
            $data = Db::table('active')->alias('a')->join('coupon b', 'a.coupon=b.id', 'LEFT')->field("a.*,b.title as couponTitle,b.number as number,b.price as couponPrice ,b.desc as couponDesc ")->where(self::sqlChange($type, $starttime, $endtime, $title, $enable, 2))->order("a.type")->select();
            foreach ($data as $key => $value) {
                if ($value['type'] == "3") {
                    if ($value["endtime"] <= time() || $value["number"] < 1) {
                        unset($data[$key]);
                    }
                }
            }
        }

        $total = Db::table('active')->where(self::sqlChange($type, $starttime, $endtime, $title, $enable, 1))->count();
        $req = ['pageNo' => $pageNo, 'pageSize' => $pageSize, 'total' => $total, 'records' => $data];
        return $this->sendMsgSuccess($req);
    }
    public function delActive()
    {
        $user = $this->adminCheckLogin();
        $req = $this->request;
        if ($user['success']) {
            if ($req->isPost()) {
                $data = $req->param();
                $sql = Db::table("active")->delete($data['id']);
                return $this->sendMsgSuccess($sql);
            } else {
                $this->sendMsgFail("请正确访问");
            }
        } else {
            return  $user;
        }
    }
    public function goodAddActive($id = "", $activeid = "")
    {
        $user = $this->adminCheckLogin();
        $req = $this->request;
        if ($user['success']) {
            if ($req->isPost()) {
                $data = $req->param();
                $req = Db::table("goods")->where("id", "in", $id)->update(["activeid" => $activeid]);
                return $this->sendMsgSuccess($req);
            } else {
                $this->sendMsgFail("请正确访问");
            }
        } else {
            return  $user;
        }
    }

    protected  function sqlChange($type = "", $starttime = "", $endtime = "", $title = "", $enable = "", $from = "")
    {

        $sql = [];
        if ($title != "") {
            $sql[$from == "1" ? 'title' : 'a.title'] = ['like', '%' . $title . '%'];
        }
        if ($enable != '') {
            $sql[$from == "1" ? 'enable' : 'a.enable'] = ['=', $enable];
        }
        if ($type != '') {
            $sql[$from == "1" ? 'type' : 'a.type'] = ['=', $type];
        }
        if ($starttime != "") {
            $sql[$from == "1" ? 'starttime' : 'a.starttime'] = ["<=", $starttime];
            $sql[$from == "1" ? 'endtime' : 'a.endtime'] = [">=", $endtime];
        }
        return  $sql;
    }
}
