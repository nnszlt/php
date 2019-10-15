<?php

namespace app\admin\controller;

use app\common\controller\Base;
use think\Db;
use think\Session;
use \think\Validate;

class Login extends Base
{
    public function Login()
    { //登陆
        $req = $this->request;
        $rule = [
            'account'  => 'require',
            'password' => 'require|min:3',
        ];
        $msg = [
            'account.require' => '请填写账户',
            'password.require' => '请填写密码',
            'password.min' => '密码不能少于3位',
        ];
        $validate = new Validate($rule, $msg);
        if ($req->isPost()) {
            $data = $req->param();
            if ($validate->check($data)) {
                $res = Db::table('admin')->where('account', $data['account'])->where('password', md5($data['password']))->find();
                if (empty($res)) {
                    return json(['success' => false, 'msg' => '账户或密码错误']);
                } else {
                    if ($res['type'] == 1 || $res['type'] == 2) {
                        Session::set('USER', $res['id']);
                        return json(['success' => true, 'msg' => '登陆成功', 'data' => $res]);
                    } else {
                        return json(['success' => false, 'msg' => '权限不足']);
                    }
                }
            } else {
                return json(['success' => false, 'msg' =>   $validate->getError()]);
            }
        } else {
            return json(['success' => false, 'msg' => '请正确登陆']);
        }
    }
    public function loginOut()
    {
        Session::clear();
        return json(['success' => true, 'msg' => '执行成功']);
    }
    public  function current()
    {  //每次的登陆
        if ($this->request->isPost()) {
            //判断是否登陆
            $user =  Session::get('USER');
            if (empty($user)) {
                return ['success' => false, 'msg' => '用户未登陆'];
            } else {
                $data = Db::table('admin')->find($user);
                Session::set('USER',  $data['id']);
                return   $this->sendMsgSuccess($data);
            }
        } else {
            return json(['success' => false, 'msg' => '请正确访问']);
        }
    }
}
