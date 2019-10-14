<?php
//  文件名和数据表的名是一样的 开头大些
namespace app\note\model;

use think\Model;

class Pool extends Model
{
      // 定义时间戳字段名
      protected $createTime = 'create_at';
      protected $updateTime = 'update_at';
    public function index()
    { }
    public function myTest()
    {
        //内部访问用$this
        return $this->getData();
    }
    public function getRwmcAttr($value, $data)
    {
        //获取器
        $status = ['zlt' => '赵理通', 'zcc100' => '张翠翠'];
        return $status[$value];
    }
    public function setDdsjAttr($value)
    {
        //修改器
        return strtolower($value);
    }
}
