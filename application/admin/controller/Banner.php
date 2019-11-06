<?php
//轮播管理
namespace app\admin\controller;

use app\common\controller\Base;
use think\Db;

class Banner extends Base
{
    public function bannerList($pageNo = 1, $pageSize = 20, $searchWord = '')
    {
        $req = $this->request;
        $sql = [];
        if ($searchWord != '') {
            $sql['name'] = ['like', '%' . $searchWord . '%'];
        }
        $data = Db::table('banner')->where($sql)->page($pageNo, $pageSize)->select();
        $total = Db::table('banner')->count();
        $req = ['pageNo' => $pageNo, 'pageSize' => $pageSize, 'total' => $total, 'records' => $data];
        return $this->sendMsgSuccess($req);
    }
 
    public function addBanner()
    {
        $user = $this->adminCheckLogin();
        if ($user['success']) {
            $req = $this->request;
            if ($req->isPost()) {
                $data = $req->param();
                if (empty($data['name'])) {
                    return $this->sendMsgFail('name不能为空');
                } else {
                    $sql = Db::table('banner')->insert(['name' => $data['name'], 'imgs' => $data['imgs'], 'createTime' => time(), 'updateTime' => time()]);
                    return $this->sendMsgSuccess($sql);
                }
            } else {
                return $this->sendMsgFail('请正确访问');
            }
        } else {
            return  $user;
        }
    }

    public function editBanner()
    {
        $user = $this->adminCheckLogin();
        if ($user['success']) {
            $req = $this->request;
            if ($req->isPost()) {
                $data = $req->param();
                if (empty($data['name'])) {
                    return $this->sendMsgFail('name不能为空');
                } else {
                    $sql = Db::table('banner')->update(['id'=>$data['id'],'name' => $data['name'], 'imgs' => $data['imgs'], 'updateTime' => time()]);
                    return $this->sendMsgSuccess($sql);
                }
            } else {
                return $this->sendMsgFail('请正确访问');
            }
        } else {
            return  $user;
        }
    }

    public function showBanner()
    {
        $user = $this->adminCheckLogin();
        if ($user['success']) {
            $req = $this->request;
            if ($req->isPost()) {
                $data = $req->param();
                if (empty($data['id'])) {
                    return $this->sendMsgFail('id');
                } else {
                    $sql = Db::table('banner')->where('id',$data['id'])->find();
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
