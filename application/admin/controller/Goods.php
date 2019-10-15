<?php
//产品中心
namespace app\admin\controller;

use app\common\controller\Base;
use app\admin\model\Good;
use think\Db;
use \think\Validate;

class Goods extends Base
{
    public function gettree()
    {
        $req = $this->request->param()['type'];
        //type==1 组织树   2大类类表
        if ($req == 1) {
            $listData = Db::table('good')->where('enable=1')->select();
            $res = Good::quote_make_tree($listData);
            return $this->sendMsgSuccess(['label' => '产品', 'id' => '0', 'path' => 0, 'enable' => '1', 'children' => $res]);
        } else {
            $listData = Db::table('good')->where('enable=1')->field('id,Fpid,label as "title"')->select();
            foreach ($listData as $key => $value) {
                $listData[$key]['expand'] = true;
            }
            $res = Good::quote_make_tree($listData);
            return $this->sendMsgSuccess(['title' => '产品', 'id' => '0', 'path' => 0, 'enable' => '1', 'children' => $res]);
        }
    }
    public function untree()
    {
        $listData = Db::table('good')->where('enable=0')->select();
        return $this->sendMsgSuccess($listData);
    }
    public function addtree()
    {
        //添加组织
        $rule = [
            'id'  => 'require',
            'label' => 'require',
        ];
        $msg = [
            'id.require' => 'id不能为空',
            'label.require' => '大类名称不能为空'
        ];
        $req = $this->request;
        $validate = new Validate($rule, $msg);
        $user = $this->adminCheckLogin();
        if ($user['success']) {
            if ($req->isPost()) {
                $data = $req->param();
                if ($validate->check($data)) {
                    if ($data['id'] == 0) {
                        $sql = Good::create(['Fpid' => $data['id'], 'label' => $data['label'], 'enable' => 1, 'path' => '', 'createtime' => time(), 'updatetime' => time()]);
                        $req = Good::where('id', $sql->id)->update(['path' =>  $sql->id]);
                        return $this->sendMsgSuccess($req);
                    } else {
                        $path = Good::get($data['id'])->path;
                        $sql = Good::create(['Fpid' => $data['id'], 'label' => $data['label'], 'enable' => 1, 'path' => '', 'createtime' => time(), 'updatetime' => time()]);
                        $req = Good::where('id', $sql->id)->update(['path' => $path . $sql->id]);
                        return $this->sendMsgSuccess($sql);
                    }
                } else {
                    return $this->sendMsgFail($validate->getError());
                }
            } else {
                $this->sendMsgFail("请正确访问");
            }
        } else {
            return  $user;
        }
    }

    public function edittree()
    {
        //编辑组织
        $rule = [
            'id'  => 'require',
            'label' => 'require',
        ];
        $msg = [
            'id.require' => 'id不能为空',
            'label.require' => '大类名称不能为空'
        ];
        $req = $this->request;
        $validate = new Validate($rule, $msg);
        $user = $this->adminCheckLogin();
        if ($user['success']) {
            if ($req->isPost()) {
                $data = $req->param();
                if ($validate->check($data)) {
                    $sql = Db::table('good')->where('id', $data['id'])->update(['label' => $data['label'], 'updatetime' => time()]);
                    return $this->sendMsgSuccess($sql);
                } else {
                    return $this->sendMsgFail($validate->getError());
                }
            } else {
                $this->sendMsgFail("请正确访问");
            }
        } else {
            return  $user;
        }
    }


    public function deltree()
    {
        //不可用组织
        $rule = [
            'id'  => 'require',
        ];
        $msg = [
            'id.require' => 'id不能为空',
        ];
        $req = $this->request;
        $validate = new Validate($rule, $msg);
        $user = $this->adminCheckLogin();
        if ($user['success']) {
            if ($req->isPost()) {
                $data = $req->param();
                if ($validate->check($data)) {
                    $find = Db::table('good')->where('id', $data['id'])->find();
                    $paths = Db::table('good')->where('path', 'like', $find['path'] . '%')->select();
                    foreach ($paths as $key => $value) {
                        Db::table('good')->where('id', $value['id'])->update(['enable' => $data['enable'], 'updatetime' => time()]);
                    }
                    return $this->sendMsgSuccess();
                } else {
                    return $this->sendMsgFail($validate->getError());
                }
            } else {
                $this->sendMsgFail("请正确访问");
            }
        } else {
            return  $user;
        }
    }
    public function trashTree()
    {
        //彻底删除组织
        $rule = [
            'id'  => 'require',
        ];
        $msg = [
            'id.require' => 'id不能为空',
        ];
        $req = $this->request;
        $validate = new Validate($rule, $msg);
        $user = $this->adminCheckLogin();
        if ($user['success']) {
            if ($req->isPost()) {
                $data = $req->param();
                if ($validate->check($data)) {
                    // 
                    $find = Db::table('good')->where('id', $data['id'])->find();
                    $paths = Db::table('good')->where('path', 'like', $find['path'] . '%')->select();
                    foreach ($paths as $key => $value) {
                        Db::table('good')->delete($value['id']);
                    }
                    return $this->sendMsgSuccess();
                } else {
                    return $this->sendMsgFail($validate->getError());
                }
            } else {
                $this->sendMsgFail("请正确访问");
            }
        } else {
            return  $user;
        }
    }
    public function selectTree()
    {
        $req = $this->CycleData(0);
        return $this->sendMsgSuccess($req);
    }

    public  function CycleData($Fpid = 0)
    {
        $where['Fpid'] = $Fpid;
        $res = Db::table('good')->where($where)->select();;
        if (empty($res)) return false;
        foreach ($res as $k => $v) {
            $result[$v['id']]['id'] = $v['id'];
            $result[$v['id']]['label'] = $v['label'];
            $result[$v['id']]['Fpid'] = $v['Fpid'];
            $rf = $this->CycleData($v['id']);
            if ($rf) {
                foreach ($rf as $k => $vv) {
                    $result[$vv['id']]['id'] = $vv['id'];
                    $result[$vv['id']]['label'] = "   |- " . $vv['label'];
                    $result[$vv['id']]['Fpid'] = $vv['Fpid'];
                }
            }
        }
        return $result;
    }
}
