<?php
//定义路由规则后，原来的URL地址将会失效，变成非法请求。
return [
    'luyou1' => 'note/luyou/index',
    'luyou2/:name' => 'note/luyou/index2',   //luyou2/:name   完全匹配 http://thinkphp:8888/luyou2/完全
    'luyou3/[:name]' => 'note/luyou/index3',   //lluyou3/[:name]  选择匹配   http://thinkphp:8888/luyou3/完全    或者  http://thinkphp:8888/luyou3
    'luyou4/:name$' => 'note/luyou/index4',    //$的意义   http://thinkphp:8888/luyou4/zzc 可以访问  http://thinkphp:8888/luyou4/zzc/11 不可访问
    // 定义闭包
    'luyou5/[:name]' => function ($name) {   //http://thinkphp:8888/luyou5/zz
        return 'Hello,' . $name . '!';
    },
    // 定义路由的请求类型和后缀
    'luyou6/[:name]' => ['note/luyou/index6', ['method' => 'get', 'ext' => 'html']],  //http://thinkphp:8888/luyou6/zz.html

];

// //另一种写法

// use think\Route;

// Route::rule('luyou2/:name', 'note/luyou/index2');
// Route::rule('luyou5/:name', function ($name) {
//     return 'Hello,' . $name . '!';
// });
