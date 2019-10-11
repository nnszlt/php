<?php
//路由的配置在 route.php
namespace app\note\controller;

use think\Controller;

class Luyou extends Controller
{
    public function index($name = 'zcc')
    {
        //http://thinkphp:8888/luyou1
        // dump($name); http://thinkphp:8888/luyou1/name/11
        return '路由index方法==访问地址/luyou1';
    }
    public function index2($name)
    {
        return '必须匹配----' . $name;
    }

    public function index3($name)
    {
        return '可选匹配----' . $name;
    }
    public function index4($name)
    {
        return '完整匹配----' . $name;
    }
    public function index6($name)
    {
        return '定义路由的请求类型和后缀-----' . $name;
    }
}
