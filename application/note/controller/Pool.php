<?php
//操作pool 表
namespace app\note\controller;

use think\Controller;
use think\Db;

class Pool extends Controller
{
    //查询操作
    public function find1()
    {
        $sql = Db::table('pool')->where('id', 1)->find();
        dump($sql);
    }
    public function find2()
    {
        $sql = Db::table('pool')->where(['gysmc' => '北京联某科技有限公司', 'rwfqr' => '孙天和'])->select();
        dump($sql);
    }
    public function find3()
    {
        $sql = Db::table('pool')->where(['gysmc' => '北京联某科技有限公司', 'rwfqr' => '孙天和'])->select();
        dump($sql);
    }
    public function find4()
    {
        //闭包查询
        $sql =  Db::select(function ($query) {
            // dump($query);
            $query->table('pool')->where('rwfqr', '孙天和');
        });
        dump($sql);
    }
    public function find5()
    {
        //ddbh的值 是否可用
        $sql = Db::table('pool')->where('id', 1)->value('ddbh');
        dump($sql);
    }
    public function find6()
    {
        //查询某一列的值可以用
        $sql = Db::table('pool')->column('gysid', 'id');
        dump($sql);
    }
    public function find7()
    {
        //分批处理
        $sql = Db::table('pool')->chunk(10, function ($item) {
            foreach ($item as $it) {
                dump($it['gysid'] . '----哈哈哈');
            }
        });
        dump($sql);
    }
    //添加
    public function insert1()
    {
        //添加一条数据
        $sql = Db::table('pool')->insert(['rwmc' => 'zlt']);
        dump($sql);
    }
    public function insert2()
    {
        //添加一条数据
        $sql = Db::table('pool')->data(['rwmc' => 'zlt'])->insert();
        dump($sql);
    }
    public function insert3()
    {
        //添加一条数据 返回主键
        $sql = Db::table('pool')->insertGetId(['rwmc' => 'zlt']);
        dump($sql);
    }
    public function insert4()
    {
        //添加多条数据 返回主键
        $sql = Db::table('pool')->insertAll([['rwmc' => 'zlt'], ['rwmc' => 'zlt']]);
        dump($sql);
    }

    //更新
    public function update1()
    {
        //更新一条数据
        $sql = Db::table('pool')->where('id', '108')->update(['rwmc' => 'zcczcc']);
        //如果数据中包含主键，可以直接使用：
        // $sql = Db::table('pool')->update(['rwmc' => 'zcc107','id'=>'107']);
        dump($sql);
    }
    public function update2()
    {
        //更新某个字段的值
        $sql = Db::table('pool')->where('id', '100')->setField(['htbh' => '100']);
        dump($sql);
    }
    public function update3()
    {
        //htbh 字段加 1
        // $sql = Db::table('pool')->where('id', '100')->setInc('htbh');
        //htbh 字段加 10
        $sql = Db::table('pool')->where('id', '100')->setInc('htbh', 10);
        dump($sql);
    }

    public function update4()
    {
        //htbh 字段减 1
        // $sql = Db::table('pool')->where('id', '100')->setDec('htbh');
        //htbh 字段减 10
        $sql = Db::table('pool')->where('id', '100')->setDec('htbh', 10);
        dump($sql);
    }
    public function update5()
    {
        //延时10秒执行减/加
        $sql = Db::table('pool')->where('id', '100')->setDec('htbh', 10, 10);
        dump($sql);
    }
    //删除
    public function del1()
    {
        //按照主键id删除
        $sql = Db::table('pool')->delete([103, 102]);
        //按照条件删除
        $sql = Db::table('pool')->where('id', '103')->delete();
        dump($sql);
    }
    //条件查询方法

    public function where1()
    {
        //where 查询相当于 and
        $sql = Db::table('pool')->where('rwfqr', 'like', '赵%')->select();
        dump($sql);
    }
    public function where2()
    {
        //whereOR 查询相当于 Or  名字中有赵的 或者gysid==3389的
        $sql = Db::table('pool')->where('rwfqr', 'like', '赵%')->whereOr('gysid', 'like', '3389')->select();
        dump($sql);
    }
    public function where3()
    {
        //EQ ：等于（=）
        // $sql = Db::table('pool')->where('gysjc', 'eq', '44')->data(['gysjc' => '4444'])->update();
        $sql = Db::table('pool')->where(['gysjc' => '4444'])->select();
        dump($sql);
    }
    public function where4()
    {
        //NEQ： 不等于（<>）
        $sql = Db::table('pool')->where('gysjc', 'neq', '44')->select();
        dump($sql);
    }
    public function where5()
    {
        //GT：大于（>）
        $sql = Db::table('pool')->where('id', 'gt', '44')->select();
        dump($sql);
    }
    public function where6()
    {
        // EGT：大于等于（>=）
        $sql = Db::table('pool')->where('id', 'egt', '44')->select();
        dump($sql);
    }
    public function where7()
    {
        // LT：小于（<）
        $sql = Db::table('pool')->where('id', 'lt', '44')->select();
        dump($sql);
    }
    public function where8()
    {
        //ELT： 小于等于（<=）
        $sql = Db::table('pool')->where('id', 'lt', '44')->select();
        dump($sql);
    }

    public function where9()
    {
        //LIKE： 同sql的LIKE
        $sql = Db::table('pool')->where('rwfqr', 'like', '赵%')->select();
        dump($sql);
    }

    public function where10()
    {
        // BETWEEN ：同sql的 between
        $sql = Db::table('pool')->where('id', 'between', '1,5')->select();
        dump($sql);
    }
    public function where11()
    {
        //  NOT IN： 同sql的[not] in
        //不包含id是1或者5的
        $sql = Db::table('pool')->where('id', 'not in', '1,5')->select();
        dump($sql);
    }
    public function where12()
    {
        // NULL 查询字段是否（不）是Null
        $sql = Db::table('pool')->where('htbh', 'null')->select();
        // $sql = Db::table('pool')->where('htbh', 'not null')->select();
        dump($sql);
    }
    public function where13()
    {
        $sql = Db::table('pool')->where('rwmc="zcc100" AND htbh="90"')->select();
        // $sql = Db::table('pool')->where('htbh', 'not null')->select();
        dump($sql);
    }

    //field 主要目的是标识要返回或者操作的字段 可以用于查询和写入操作。
}
