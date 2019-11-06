<?php
//访问菜单权限管路
namespace app\admin\controller;

use app\common\controller\Base;
use think\Db;
use app\admin\model\Menuauth as Menu;

class Menuauth extends Base
{
   public function menuList()
   {
      $list = Db::table("Menuauth")->select();
      $req = Menu::quote_make_tree($list);
     return $this->sendMsgSuccess($req);
   }
}
