<?php
//产品的标签
namespace app\admin\controller;

use app\common\controller\Base;
use think\Db;
//产品标签
class Tags extends Base
{
    public function list($pageNo = 1, $pageSize = 20, $searchWord = '')
    {
        $req = $this->request;
        $sql = [];
        if ($req->param()['enable'] != '') {
            $sql['enable'] = $req->param()['enable'];
        }
        if ($searchWord != '') {
            $sql['name'] = ['like', '%' . $searchWord . '%'];
        }
        $data = Db::table('tags')->where($sql)->page($pageNo, $pageSize)->select();
        $total = Db::table('tags')->count();
        $req = ['pageNo' => $pageNo, 'pageSize' => $pageSize, 'total' => $total, 'records' => $data];
        return $this->sendMsgSuccess($req);
    }

    public function addtags()
    {
        $user = $this->adminCheckLogin();
        if ($user['success']) {
            $req = $this->request;
            if ($req->isPost()) {
                $data = $req->param();
                if (empty($data['name'])) {
                    return $this->sendMsgFail('name不能为空');
                } else {
                    $sql = Db::table('tags')->insert(['name' => $data['name'], 'content' => $data['content'], 'enable' => 0, 'createtime' => time(), 'updatetime' => time()]);
                    return $this->sendMsgSuccess($sql);
                }
            } else {
                return $this->sendMsgFail('请正确访问');
            }
        } else {
            return  $user;
        }
    }

    public function edittags()
    {
        $user = $this->adminCheckLogin();
        if ($user['success']) {
            $req = $this->request;
            if ($req->isPost()) {
                $data = $req->param();
                if (empty($data['name'])) {
                    return $this->sendMsgFail('name不能为空');
                } else {
                    $sql = Db::table('tags')->where('id', $data['id'])->update(['name' => $data['name'], 'content' => $data['content'], 'enable' =>  $data['enable'], 'updatetime' => time()]);
                    return $this->sendMsgSuccess($sql);
                }
            } else {
                return $this->sendMsgFail('请正确访问');
            }
        } else {
            return  $user;
        }
    }

    public function deltags()
    {
        $user = $this->adminCheckLogin();
        if ($user['success']) {
            $req = $this->request;
            if ($req->isPost()) {
                $data = $req->param();
                if (empty($data['id'])) {
                    return $this->sendMsgFail('id不能为空');
                } else {
                    $sql = Db::table('tags')->delete($data['id']);
                    return $this->sendMsgSuccess($sql);
                }
            } else {
                return $this->sendMsgFail('请正确访问');
            }
        } else {
            return  $user;
        }
    }
}
