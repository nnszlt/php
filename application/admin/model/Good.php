<?php
//  文件名和数据表的名是一样的 开头大些
namespace app\admin\model;

use think\Model;

class Good extends Model
{
    /**
     * 把返回的数据集转换成Tree
     * @param array $list 要转换的数据集
     * @param string $pk 自增字段（栏目id）
     * @param string $pid parent标记字段
     * @return array
     */
    public static function quote_make_tree($list, $pk = 'id', $pid = 'Fpid', $child = 'children', $root = 0)
    {
        $tree = $packData = [];
        foreach ($list as $data) {
            $packData[$data[$pk]] = $data;
        }
        foreach ($packData as $key => $val) {
            if ($val[$pid] == $root) { //代表跟节点
                $tree[] = &$packData[$key];
            } else {
                //找到其父类
                $packData[$val[$pid]][$child][] = &$packData[$key];
            }
        }
        return $tree;
    }


  
}
