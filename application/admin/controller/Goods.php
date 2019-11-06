<?php
//产品管理
namespace app\admin\controller;
use app\common\controller\Base;
use think\Db;
use \think\Validate;

class Goods extends Base
{
    private $rule = [
        'name'  => 'require',
        'price' => 'require',
        'number' => 'require',
        'mprice' => 'require',
        'no' => 'require',
        'enable' => 'require',
        'unit' => 'require',
        'type' => 'require',
        'price' => 'require',
        'imgs' => 'require'
    ];
    private $msg = [
        'name.require' => '产品名称不能为空',
        'price.require' => '产品价格不能为空',
        'number.require' => '库存不能为空',
        'mprice.require' => '市场价格不能为空',
        'no.require' => '产品型号不能为空',
        'enable.require' => '商品是否可用不能为空',
        'unit.require' => '计价单位不能为空',
        'type.require' => '大类名称不能为空',
        'mprice.require' => '大类名称不能为空',
        'imgs.require' => '产品图片不能为空',
    ];
    public function list($name = "", $no = "", $brand = "", $type = "", $enable = "", $label = "", $pageNo = 1, $pageSize = 10)
    {
        $sql = [];
        if ($name != '') {
            $sql['a.name'] = ['like', '%' . $name . '%'];
        }
        if ($no != '') {
            $sql['a.no'] = ['=', $no];
        }
        if ($brand != '') {
            $sql['a.brand'] = ['=', $brand];
        }
        if ($type != '') {
            $goodtype = Db::table('good')->where('id', $type)->find();
            $sql['a.path'] = ['like',  $goodtype['path'].'%'];
        }
        if ($enable != '') {
            $sql['a.enable'] = ['=', $enable];
        }
        if ($label != '') {
            $sql['a.label'] = ['in', $label];
        }
        $data = Db::table('goods')->alias("a")->join("active b","a.activeid=b.id","LEFT")->where($sql)->page($pageNo, $pageSize)->field("a.*,b.title as activeTitle")->select();

        $sql['a.enable'] = ['=', 1];
        $gray = Db::table('goods')->alias("a")->where($sql)->count();
        $sql['a.enable'] = ['=', 0];
        $normal = Db::table('goods')->alias("a")->where($sql)->count();
        $total = Db::table('goods')->alias("a")->where($sql)->count();
        $req = ['pageNo' => $pageNo, 'pageSize' => $pageSize, 'total' => $total, 'records' => $data, 'gray' => $gray, 'normal' => $normal];
        return $this->sendMsgSuccess($req);
    }


    public function addgoods()
    {
        $user = $this->adminCheckLogin();
        $req = $this->request;
        $validate = new Validate($this->rule, $this->msg);
        if ($user['success']) {
            if ($req->isPost()) {
                $data = $req->param();
                if ($validate->check($data)) {
                    $data['path'] = Db::table('good')->where('id', $data['type'])->find()['path'];
                    $data['createtime'] = time();
                    $data['updatetime'] = time();
                    $data['seckill']=1;
                    $sql = Db::table('goods')->insert($data);
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
    public function editgoods()
    {
        $user = $this->adminCheckLogin();
        $req = $this->request;
        $validate = new Validate($this->rule, $this->msg);
        if ($user['success']) {
            if ($req->isPost()) {
                $data = $req->param();
                if ($validate->check($data)) {
                    $data['path'] = Db::table('good')->where('id', $data['type'])->find()['path'];
                    $data['createtime'] = time();
                    $data['updatetime'] = time();
                    $sql = Db::table('goods')->where('id', $data['id'])->update($data);
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
    public function show($id = '')
    {
        $user = $this->adminCheckLogin();
        $req = $this->request;
        if ($user['success']) {
            if ($id == '') {
                return    $this->sendMsgFail("id不能为空");
            }
            $req = Db::table('goods')->where('id', $id)->find();
            if (!empty($req['label'])) {
                $req['label'] = Db::table('tags')->where('id', 'in', $req['label'])->select();
            }
            return $this->sendMsgSuccess($req);
        } else {
            return  $user;
        }
    }
    public function del($id = '')
    {
        $user = $this->adminCheckLogin();
        $req = $this->request;
        if ($user['success']) {
            if ($id == '') {
                return    $this->sendMsgFail("id不能为空");
            }
            $req = Db::table('goods')->delete($id);
            return $this->sendMsgSuccess($req);
        } else {
            return  $user;
        }
    }

    public function enable($id = '', $enable = 0)
    {
        $user = $this->adminCheckLogin();
        $req = $this->request;
        if ($user['success']) {
            if ($id == '') {
                return   $this->sendMsgFail("id不能为空");
            }
            $req = Db::table('goods')->where('id', $id)->update(['enable' => $enable]);
            return $this->sendMsgSuccess($req);
        } else {
            return  $user;
        }
    }
}
