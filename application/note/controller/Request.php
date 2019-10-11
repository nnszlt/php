<?php

namespace app\note\controller;

use think\Controller;

class Request extends Controller
{
    public function index()
    {
        //获取 request的方法
        //  dump($this->request);
        //函数助手
        $request = request();
        $request->bind('name', 'zhaolitong');
        dump($request);
    }
    public function index2()
    {
        // http: //thinkphp:8888/note/Request/index2?id=4909
        //    dump(input('id'));
        // dump(input('param.id'));
        // dump(input('get.id'));
        // input('cookie.');
    }
    public function index3()
    {
        $request = request();
        dump($request);
    }
    //返回
    public function res1()
    {
        //http://thinkphp:8888/note/Request/res1
        $arr = [1, 2, 3];
        $data = ['data' => [
            'name' => 1, 'sex' => '男', 'number' => $arr
        ], 'success' => true];
        return json($data);
        // return xml($data);
        // return json($data,404);  状态码
    }
    public function res2()
    {
        // $this->redirect("http://www.baidu.com");  //跳转网址
        // $this->redirect('res1'); //跳转方法
    }
}
