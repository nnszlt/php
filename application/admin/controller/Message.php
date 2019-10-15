<?php
//消息中心
namespace app\admin\controller;

use app\common\controller\Base;
use think\Db;

class Message extends Base
{
    public function count()
    {
        //未读的条数
        $login = $this->adminCheckLogin();
        if ($login['success']) {
            $data = Db::table('message')->where('userid', $login['user'])->where('type=0', 'isDel=0')->select();
            return $this->sendMsgSuccess(count($data));
        } else {
            return  $login;
        }
    }

    public function init()
    {
        //未读的条数
        $login = $this->adminCheckLogin();
        if ($login['success']) {
            $read = Db::table('message')->where('userid', $login['user'])->where('type=1', 'isDel=0')->field('title,content,createtime,id')->order('createtime desc')->select();
            $unread = Db::table('message')->where('userid', $login['user'])->where('type=0', 'isDel=0')->field('title,content,createtime,id')->order('createtime desc')->select();
            $trash = Db::table('message')->where('userid', $login['user'])->where('type=2', 'isDel=0')->field('title,content,createtime,id')->order('createtime desc')->select();
            $res = ['unread' => $unread, 'read' =>  $read, 'trash' => $trash];
            return $this->sendMsgSuccess($res);
        } else {
            return  $login;
        }
    }

    public function readMsg()
    {
        //信息变成已读
        $req = $this->request;
        $user = $this->adminCheckLogin();
        if ($user['success']) {
            $data = $req->param();
            if (empty($data['id'])) {
                return  $this->sendMsgFail("ID不能为空");
            } else {
                $res = Db::table("message")->where("id", $data['id'])->where('type=0,isDEL=0')->update(['type' => 1]);
                return  $this->sendMsgSuccess();
            }
        } else {
            return  $user;
        }
    }
    public function trashMsg()
    {
        //删除消息
        $req = $this->request;
        $user = $this->adminCheckLogin();
        if ($user['success']) {
            $data = $req->param();

            if (empty($data['id'])) {
                return  $this->sendMsgFail("ID不能为空");
            } else {
                $res = Db::table("message")->where("id", $data['id'])->where('type=1,isDEL=0')->update(['type' => 2]);
                return  $this->sendMsgSuccess();
            }
        } else {
            return  $user;
        }
    }
}
