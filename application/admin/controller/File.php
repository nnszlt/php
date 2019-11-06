<?php
//上传
namespace app\admin\controller;

use app\common\controller\Base;

class File extends Base
{
    public function upload()
    {
        // 获取表单上传文件 例如上传了001.jpg
        $file = request()->file('file');
        // 移动到框架应用根目录/public/uploads/ 目录下
        if ($file) {
            $info = $file->move(ROOT_PATH . 'public' . DS . 'uploads');
            if ($info) {
                // 成功上传后 获取上传信息
                // dump($info->getSaveName());
                // exit();
                $data = ['url' => 'uploads/'.$info->getSaveName(), 'name' => $info->getFilename()];
                return  $this->sendMsgSuccess($data);
            } else {
                // 上传失败获取错误信息
                return $this->sendMsgFail($file->getError());
            }
        }
    }
}
