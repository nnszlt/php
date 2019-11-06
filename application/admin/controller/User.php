<?php
//用户中心
namespace app\admin\controller;

use app\common\controller\Base;
use think\Db;
use \think\Validate;

class User extends Base
{

    private $rule = [
        'account'  => 'require',
        'password' => 'require',
        // 'menuAuth' => 'require',
        'enable' => 'require',
        'type' => 'require'
    ];
    private $msg = [
        'account.require' => '账号不能为空',
        'password.require' => '密码不能为空',
        // 'menuAuth.require' => '后台菜单权限不能为空',
        'enable.require' => '账号启用状态不能为空',
        'type.require' => '访问终端不能为空'
    ];


    public function userList($pageNo = 1, $pageSize = 20, $account = '', $enable = '', $type = "")
    {
        $sql = [];
        if ($type !== '') {
            $sql['type'] =  ['in', $type . ',2'];
        }
        if ($enable !== '') {
            $sql['enable'] =  $enable;
        }
        if ($account !== '') {
            $sql['account'] = $account;
        }
        $data = Db::table('admin')->where($sql)->page($pageNo, $pageSize)->field("password", true)->select();
        $total = Db::table('admin')->count();
        $req = ['pageNo' => $pageNo, 'pageSize' => $pageSize, 'total' => $total, 'records' => $data];
        return $this->sendMsgSuccess($req);
    }
    public function showUser()
    {
        $user = $this->adminCheckLogin();
        if ($user['success']) {
            $req = $this->request;
            if ($req->isPost()) {
                $data = $req->param();

                if (empty($data['id'])) {
                    return $this->sendMsgFail('id不能为空');
                } else {
                    $req = Db::table("admin")->where("id", $data['id'])->field("password", true)->find();
                    return $this->sendMsgSuccess($req);
                }
            } else {
                return $this->sendMsgFail('请正确访问');
            }
        } else {
            return  $user;
        }
    }




    public function addUser()
    {
        $user = $this->adminCheckLogin();
        if ($user['success']) {
            $req = $this->request;
            if ($req->isPost()) {
                $data = $req->param();
                $validate = new Validate($this->rule, $this->msg);
                if ($validate->check($data)) {
                    $hasName = Db::table("admin")->where('account', $data['account'])->whereOr('phone', $data['phone'])->find();
                    if (is_null($hasName)) {
                        $data['createTime'] = time();
                        $data['password'] = md5($data['password']);
                        $sql = Db::table('admin')->insert($data);
                        return $this->sendMsgSuccess($sql);
                    } else {
                        return $this->sendMsgFail('此账号或手机号已存在');
                    }
                } else {
                    return json(['success' => false, 'msg' =>   $validate->getError()]);
                }
            } else {
                return $this->sendMsgFail('请正确访问');
            }
        } else {
            return  $user;
        }
    }


    public function editUser()
    {
        $user = $this->adminCheckLogin();
        if ($user['success']) {
            $req = $this->request;
            if ($req->isPost()) {
                $data = $req->param();
                $validate = new Validate($this->rule, $this->msg);
                if ($validate->check($data)) {
                    if ($data['password'] == '删除修改密码') {
                        unset($data['password']);
                    } else {
                        $data['password'] = md5($data['password']);
                    }
                    $sql = Db::table("admin")->update($data);
                    return $this->sendMsgSuccess($sql);
                } else {
                    return json(['success' => false, 'msg' =>   $validate->getError()]);
                }
            } else {
                return $this->sendMsgFail('请正确访问');
            }
        } else {
            return  $user;
        }
    }
    public function enableUser()
    {
        $user = $this->adminCheckLogin();
        if ($user['success']) {
            $req = $this->request;
            if ($req->isPost()) {
                $data = $req->param();
                $sql = Db::table('admin')->where('id', 'in', $data['id'])->update(['enable' => $data['enable']]);
                return $this->sendMsgSuccess($sql);
            } else {
                return $this->sendMsgFail('请正确访问');
            }
        } else {
            return  $user;
        }
    }

    public function delUser()
    {
        $user = $this->adminCheckLogin();
        if ($user['success']) {
            $req = $this->request;
            if ($req->isPost()) {
                $data = $req->param();
                $sql = Db::table('admin')->delete($data['id']);
                return $this->sendMsgSuccess($sql);
            } else {
                return $this->sendMsgFail('请正确访问');
            }
        } else {
            return  $user;
        }
    }
}
