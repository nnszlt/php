<?php
//  文件名和数据表的名是一样的 开头大些
namespace app\common\controller;

use think\Controller;
use think\Session;
use think\Db;

class Base extends Controller
{
    public function adminCheckLogin()
    {
        //判断是否登陆  后台用
        $user =  Session::get('USER');
        if (empty($user)) {
            return ['success' => false, 'msg' => '用户未登陆'];
        } else {
            $data = Db::table('admin')->find($user);
            Session::set('USER',  $data['id']);
            return ['success' => true, 'user' => $data['id']];
        }
    }

    public function sendMsg($type = true, $msg = '请求成功!', $data = '')
    {
        //返回参数
        return  json(['success' => $type, 'msg' => $msg, 'data' => $data]);
    }
    public function sendMsgSuccess($data = '')
    {
        //返回参数成功
        return  json(['success' => true, 'msg' => '请求成功', 'data' => $data]);
    }
    public function sendMsgFail($msg = '请求失败，请联系管理员!')
    {
        //返回参数失败
        return  json(['success' => false, 'msg' => $msg]);
    }
}
