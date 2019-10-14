<?php
//操作pool 表
namespace app\note\controller;

use think\Controller;
use app\note\model\Pool;

class Moxing extends Controller
{

    public function index()
    {
        //实例化创建 模型对象
        $pool = new Pool();
        $res = $pool->where('id', '1')->find();
        // dump($res);
        dump($res->getData());  //getData() 查看原始数据
        // dump($res->getData('rwmc')); //只查看任务名称
    }

    public function index1()
    {
        //静态创建 模型对象
        $res = Pool::get(1)->getData();
        dump($res);
    }

    public function index2()
    {
        //静态创建 模型对象
        $res = Pool::get(1)->myTest();
        dump($res);
    }


    //模型增加 save
    public function insert1()
    {
        //单个添加
        //1. 实例化模型对象
        $pool = new Pool();
        //2.创建对象采用对象方式
        $pool->rwmc = '微信包';
        $pool->htbh = '2019-10-11';
        //3.执行添加操作
        $res = $pool->save();
        dump($res);  //返回 int(1)
    }
    public function insert2()
    {
        //批量添加
        //1.获取数据
        $data = [
            ['rwmc' => '支付宝', 'htbh' => '2019-10-12'],
            ['rwmc' => '百度宝', 'htbh' => '2019-10-13'],
        ];
        //2. 实例化模型对象
        $pool = new Pool();
        //3.执行添加操作
        $res = $pool->saveAll($data);
        dump($res);  //返回对象
    }

    public function insert3()
    {
        //批量添加    allowField 只润许写入
        //1.获取数据
        $data = [
            ['rwmc' => '支付宝1', 'htbh' => '2019-10-12'],
            ['rwmc' => '百度宝1', 'htbh' => '2019-10-13'],
        ];
        //2. 实例化模型对象
        $pool = new Pool();
        //3.执行添加操作
        $res = $pool->allowField("rwmc")->saveAll($data);
        // 过滤post数组中的非数据表字段数据
        // $user->allowField(true)->save($_POST,['id' => 1]);
        dump($res);  //返回对象
    }

    public function insert4()
    {
        //静态
        $res =  Pool::create(['rwmc' => '可以删除', 'htbh' => '2019-10-12']);
        dump($res); //返回对象
    }

    //更新
    public function updata1()
    {
        //静态方法
        $sql = Pool::get(114);
        $sql->rwmc = '来了包1';
        $sql->save();
        dump($sql);  //放回数据
    }
    public function updata2()
    {
        //静态方法
        $sql = Pool::where('id', 115)->update(['gysmc' => '应知己']);
        // $sql = Pool::update(['gysmc' => '应知己', 'id' => '115']);
        dump($sql);  //返回个数
    }
    public function updata3()
    {
        //实例化方法  save方法第二个参数为更新条件
        $table = new Pool();
        $res = $table->save(['rwmc' => '任务名称1'], ['id' => 109]);
        dump($res); //返回成功个数
    }
    public function updata4()
    {
        //批量更新
        $table = new Pool();
        $list = [
            ['id' => 110, 'rwmc' => '110'],
            ['id' => 111, 'rwmc' => '111']
        ];
        $res = $table->saveAll($list);
        dump($res); //返回数据
    }

    public function updata5()
    {
        //模型的新增和更新方法都是save方法，
        //实例化模型后调用save方法表示新增；
        //查询数据后调用save方法表示更新；
        //save方法传入更新条件后表示更新；

        // 实例化模型
        $table = new Pool();
        // 显式指定更新数据操作
        $sql = $table->isUpdate(true)
            ->save(['id' => 118, 'rwmc' => 'thinkphp']);
        dump($sql); //返回个数
    }

    public function updata6()
    {
        // 实例化模型
        $table = new Pool();
        // 显式指定更新数据操作
        $sql = $table->isUpdate(false)
            ->save(['rwmc' => 'thinkphp2']);
        dump($sql); //返回个数
    }

    //删除
    public function del1()
    {
        $table = Pool::get(131);
        $res = $table->delete();
        dump($res); //返回个数
    }
    public function del2()
    {
        //根据主键删除Î
        $res = Pool::destroy([130, 129]);
        dump($res);
    }
    public function del3()
    {
        //条件删除
        $res = Pool::destroy(['rwmc' => '可以删除Î']);
        dump($res);
    }

    //查询

    public function find1()
    {
        //静态方法查询
        // $table = Pool::get(100); //取出主键为100的数据  一条
        // $table = Pool::get(['gysjc' => '东方金鹰']); //一条
        $table = Pool::where('gysjc', '东方金鹰')->find();
        dump($table);
    }
    public function find2()
    {
        //查询多个
        //静态
        //    $sql=Pool::all(['gysjc'=>'东方金鹰']);
        //动态
        $table = new Pool();
        $sql = $table->where('gysjc', '东方金鹰')->select();
        dump($sql);
    }

    public function changeName()
    {
        //获取名字  获取器
        // $sql=Pool::get(106)->getAttr("rwmc");
        // $sql = Pool::get(106)->rwmc;
        $sql = Pool::get(106)->getData('rwmc');
        dump($sql);

        //多条数据的输出
        // $sql =  Pool::where('rwmc="zlt" OR rwmc="zcc100"')->select();
        // $res = collection($sql)->toArray();
        // dump($res);
    }
    public function setddsj()
    {
        //设置订单时间
        $sql = Pool::create(['ddsj' => '2019-10-10']);
        dump($sql);
    }
}
