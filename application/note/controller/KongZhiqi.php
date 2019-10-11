<?php

namespace app\note\controller;

use think\Controller;

class KongZhiqi extends Controller
{
    public function index()
    {
        //http://thinkphp:8888/note/kong_zhiqi/index
        //KongZhiqi 这种控制器 访问使用 kong_zhiqi
        //不支持pathInfo 的访问方式  http://thinkphp:8888/index.php?s=/note/kong_zhiqi/index
        return 'KongZhiqi';
    }

}
