<template>
  <div class="activeList minwidth">
    <div class="serach_bar">
      <div class="serach_bar_right">
        <Button
          type="primary"
          :disabled="tableSelect.length==0"
          icon="ios-remove-circle-outline"
          @click="del_table"
        >删除</Button>
        <Button
          class="margin-left-sm"
          type="primary"
          icon="ios-add-circle-outline"
          @click="addActive('添加活动')"
        >添加</Button>
      </div>
      <div class="serach_bar_left">
        <Select class="select" v-model="serach.type">
          <Option v-for="item in type" :value="item.id" :key="item.id">{{ item.name }}</Option>
        </Select>
        <Select class="select" v-model="serach.enable">
          <Option v-for="item in enable" :value="item.value" :key="item.value">{{ item.name }}</Option>
        </Select>
        <DatePicker
          class="select"
          type="datetimerange"
          format="yyyy-MM-dd HH:mm"
          placeholder="请选择活动时间"
          style="width: 300px"
          @on-change="timeChange"
        ></DatePicker>
        <Input class="input" v-model="serach.title" placeholder="活动名" clearable />
        <Button type="primary" icon="ios-search" @click="serachdata()">搜索</Button>
      </div>
    </div>

    <div class="content mt10">
      <div class="table">
        <el-table
          empty-text="暂无数据"
          :data="datalist"
          border
          fit
          :max-height="tableHeight"
          @selection-change="table_select"
        >
          <el-table-column align="center" type="selection" width="55"></el-table-column>
          <el-table-column align="center" width="65" :show-overflow-tooltip="true" label="序号">
            <template slot-scope="scope">{{(page.pageNo-1)*page.pageSize+scope.$index+1}}</template>
          </el-table-column>
          <el-table-column align="center" :show-overflow-tooltip="true" prop="type" label="活动类型">
            <template slot-scope="scope">{{scope.row.type==1?'秒杀':scope.row.type==2?'满减':'领券'}}</template>
          </el-table-column>
          <el-table-column align="center" :show-overflow-tooltip="true" prop="title" label="活动标题"></el-table-column>
          <el-table-column align="center" :show-overflow-tooltip="true" prop="desc" label="标签简介"></el-table-column>
          <el-table-column align="center" :show-overflow-tooltip="true" prop="enable" label="活动时间">
            <template
              slot-scope="scope"
            >{{formatDate(scope.row.starttime*1000)+"--"+formatDate(scope.row.endtime*1000)}}</template>
          </el-table-column>
          <el-table-column align="center" :show-overflow-tooltip="true" prop="enable" label="标签简介">
            <template slot-scope="scope">{{scope.row.enable==0?'可用':'不可用'}}</template>
          </el-table-column>
          <el-table-column align="center" :show-overflow-tooltip="true" label="操作">
            <template slot-scope="scope">
              <span @click="editBanner('编辑活动',scope.row)" class="cpl margin-left-sm">编辑</span>
            </template>
          </el-table-column>
        </el-table>
        <div class="table_page">
          <Page
            :total="page.total"
            :current="page.pageNo"
            show-total
            show-elevator
            show-sizer
            :page-size="20"
            :page-size-opts="page.pageGroup"
            @on-change="pageChange"
            @on-page-size-change="pageGroupChange"
          ></Page>
        </div>
      </div>
    </div>
    <!-- 添加标签s -->
    <Modal v-model="modal.modalShow" :title="modal.modalTitle" @on-visible-change="modalChange">
      <Form ref="form" :model="modal.form" :rules="modal.rule" :label-width="80">
        <FormItem label="活动类型" prop="type">
          <Select class="select" v-model="modal.form.type" placeholder="请选择活动类型">
            <Option
              v-for="item in type"
              v-show="item.id!='all'"
              :value="item.id"
              :key="item.id"
            >{{ item.name }}</Option>
          </Select>
        </FormItem>
        <FormItem label="活动标题" prop="title">
          <Input v-model="modal.form.title" placeholder="请输入活动标题"></Input>
        </FormItem>
        <FormItem label="活动时间" prop="starttime">
          <DatePicker
            :value="modal.time"
            type="datetimerange"
            format="yyyy-MM-dd HH:mm"
            placeholder="请选择开始结束时间"
            @on-change="timeFromChange"
          ></DatePicker>
        </FormItem>
        <FormItem label="是否可用" prop="enable">
          <RadioGroup v-model="modal.form.enable">
            <Radio label="0">可用</Radio>
            <Radio label="1">不可用</Radio>
          </RadioGroup>
        </FormItem>

        <FormItem label="秒杀价" v-show="modal.form.type==1" prop="miaosha">
          <Input v-model="modal.form.miaosha" placeholder="原价减-去秒杀价"></Input>
        </FormItem>
        <FormItem label="满减" v-show="modal.form.type==2" prop="man">
          <Input class="sinput" v-model="modal.form.man" placeholder="满"></Input>
          <span class="padding-horizontal-xs">减</span>
          <Input class="sinput" v-model="modal.form.jian" placeholder="减"></Input>
        </FormItem>

        <FormItem label="优惠券" v-show="modal.form.type==3" prop="coupon">
          <Select
            class="select"
            filterable
            v-model="modal.form.coupon"
            placeholder="请选择优惠券"
            @on-change="couponChange"
          >
            <Option v-for="item in coupondata" :value="item.id" :key="item.id">{{ item.title }}</Option>
          </Select>
        </FormItem>
        <FormItem label="优惠券简介" v-show="modal.form.type==3&&couponDesc!=''">{{couponDesc}}</FormItem>

        <FormItem label="活动简介" prop="desc">
          <Input v-model="modal.form.desc" type="textarea" placeholder="请输入活动简介"></Input>
        </FormItem>
      </Form>
      <div slot="footer">
        <Button type="text" size="large" @click="modal.modalShow=false">取消</Button>
        <Button type="primary" size="large" @click="ok">确定</Button>
      </div>
    </Modal>
    <!-- 添加标签e -->
  </div>
</template>
<script>
import {
  listActive,
  addActive,
  showActive,
  delActive,
  editActive
} from "_api/active";
import { couponList } from "_api/coupon";

export default {
  name: "activeList",
  data() {
    return {
      coupondata: [],
      couponDesc: "",
      page: {
        //分页
        total: 20,
        pageSize: 20,
        pageNo: 1,
        pageGroup: [20, 30, 40, 50]
      },
      enable: [
        { name: "全部", value: "all" },
        { name: "不可用", value: "1" },
        { name: "可用", value: "0" }
      ],
      type: [
        { name: "所有活动", id: "all" },
        { name: "秒杀", id: "1" },
        { name: "满减", id: "2" },
        { name: "送券", id: "3" }
      ],
      serach: {
        //搜索内容
        title: "",
        enable: "all",
        type: "all",
        starttime: "",
        endtime: ""
      },
      tableHeight: null,
      tableSelect: [],
      datalist: [],
      modal: {
        modalShow: false,
        modalTitle: "",
        id: "",
        time: "",
        form: {
          type: "",
          starttime: "",
          endtime: "",
          title: "",
          desc: "",
          enable: "0",
          coupon: "",
          man: "",
          jian: "",
          miaosha: ""
        },
        rule: {
          type: [
            {
              required: true,
              message: "请选择活动类型"
            }
          ],
          title: [
            {
              required: true,
              message: "请输入活动标题"
            }
          ],
          enable: [
            {
              required: true,
              message: "请选择活动是否可用"
            }
          ],
          starttime: [
            {
              required: true,
              message: "请选择活动时间"
            }
          ],
          coupon: [
            {
              message: "请选择优惠券",
              validator: this.checkActive
            }
          ],
          man: [
            {
              message: "请输入满减",
              validator: this.checkActive
            }
          ],
          miaosha: [
            {
              message: "请输入秒杀价",
              validator: this.checkActive
            }
          ]
        }
      }
    };
  },
  mounted() {
    this.getlist();
    this.couponList();
    this.tableHeight =
      $(window).height() -
      $(".serach_bar").height() -
      $(".serach_bar").height() -
      175;
  },
  methods: {
    checkActive(rule, value, callback) {
      if (this.modal.form.type == 1) {
        if (this.modal.form.miaosha == "") {
          return callback(new Error());
        }
      }
      if (this.modal.form.type == 2) {
        if (this.modal.form.man == "" || this.modal.form.jian == "") {
          return callback(new Error());
        }
      }
      if (this.modal.form.type == 3) {
        if (this.modal.form.coupon == "") {
          return callback(new Error());
        }
      }
      return callback();
    },
    table_select(selection, row) {
      //已选择的行
      this.tableSelect = selection;
    },
    serachdata(page) {
      //搜索
      this.page.pageNo = 1;
      this.getlist();
    },
    pageChange(page) {
      //页码改变
      this.page.pageNo = page;
      this.getlist();
    },
    pageGroupChange(pageGroup) {
      //改变每页条数
      this.page.pageNo = 1;
      this.page.pageSize = pageGroup;
      this.getlist();
    },
    getlist() {
      //获取列表信息
      var data = JSON.parse(JSON.stringify(this.serach));
      data.pageNo = this.page.pageNo;
      data.pageSize = this.page.pageSize;
      data.enable = data.enable == "all" ? "" : data.enable;
      data.type = data.type == "all" ? "" : data.type;
    
      listActive(data)
        .then(res => {
          $(".el-table__body-wrapper").scrollTop(0);
          this.page.total = res.data.data.total;
          this.datalist = res.data.data.records;
        })
        .catch(err => {
          console.log(err);
        });
    },
    couponList() {
      couponList().then(res => {
        if (res.data.success) {
          this.coupondata = res.data.data.records;
        }
      });
    },
    del_table() {
      this.$Message.destroy();
      var idArr = [];
      this.tableSelect.map((v, i) => {
        idArr.push(v.id);
      });
      this.$Modal.confirm({
        title: "提示",
        content: "<p>是否删除活动？</p>",
        onOk: () => {
          delActive({ id: idArr.toString() }).then(res => {
            if (res.data.success) {
              this.$Message.destroy();
              this.getlist();
              this.$Message.success(res.data.msg);
            } else {
              this.$Message.error(res.data.msg);
            }
          });
        },
        onCancel: () => {}
      });
    },
    addActive(e) {
      this.modal.modalTitle = e;
      this.modal.form.name = "";
      this.modal.form.content = "";
      this.modal.form.id = "";
      this.modal.modalShow = true;
    },
    editBanner(e, data) {
      this.modal.modalTitle = e;
      this.modal.form.title = data.title;
      this.modal.form.type = data.type;
      this.modal.form.starttime = this.formatDate(
        data.starttime * 1000,
        "yyyy-MM-dd hh:mm"
      );
      this.modal.form.endtime = this.formatDate(
        data.endtime * 1000,
        "yyyy-MM-dd hh:mm"
      );
      this.modal.time =
        this.formatDate(data.starttime * 1000, "yyyy-MM-dd hh:mm") +
        " - " +
        this.formatDate(data.endtime * 1000, "yyyy-MM-dd hh:mm");
      this.modal.form.id = data.id;
      if (data.type == 1) {
        this.modal.form.miaosha = data.miaosha;
      }
      if (data.type == 2) {
        var p = data.manjian.split(",");
        this.modal.form.man = p[0];
        this.modal.form.jian = p[1];
      }
      if (data.type == 3) {
        this.modal.form.coupon = Number(data.coupon);
      }
     this.modal.form.desc=data.desc
      this.modal.modalShow = true;
    },
    resetFrom() {
      this.$refs["form"].resetFields();
    },
    ok() {
      this.$refs["form"].validate(valid => {
        if (valid) {
        }
      });
      let data = {
        enable: this.modal.form.enable,
        title: this.modal.form.title,
        desc: this.modal.form.desc,
        endtime: this.modal.form.endtime / 1000,
        starttime: this.modal.form.starttime / 1000,
        type: this.modal.form.type
      };
      if (data.type == 1) {
        data.miaosha = this.modal.form.miaosha;
      }
      if (data.type == 2) {
        data.manjian = this.modal.form.man + "," + this.modal.form.jian;
      }
      if (data.type == 3) {
        data.coupon = this.modal.form.coupon;
      }
      if (this.modal.modalTitle == "添加活动") {
        addActive(data).then(res => {
          if (res.data.success) {
            this.resetFrom();
            this.getlist();
          } else {
            this.$Message.error(res.data.msg);
          }
        });
      } else {
        console.log(data);
        data.starttime = Date.parse(data.starttime);
        data.endtime = Date.parse(data.endtime);
        editActive(data).then(res => {
          if (res.data.success) {
            this.resetFrom();
            this.getlist();
          } else {
            this.$Message.error(res.data.msg);
          }
        });
      }
    },
    timeChange(e) {
      this.serach.starttime = Date.parse(e[0]) / 1000;
      this.serach.endtime = Date.parse(e[1]) / 1000;
    },
    timeFromChange(e) {
      this.modal.form.starttime = Date.parse(e[0]);
      this.modal.form.endtime = Date.parse(e[1]);
    },
    couponChange(e) {
      console.log(e);
      this.coupondata.some(res => {
        if (res.id == e) {
          this.couponDesc = res.desc;
          return true;
        }
      });
    },
    modalChange(e) {
      if (!e) {
        this.resetFrom();
      }
    }
  },

  computed: {},
  watch: {}
};
</script>
<style lang="less" scoped>
.mt10 {
  margin-top: 10px;
}
.mr10 {
  margin-right: 10px;
}
.width50 {
  width: 50%;
  display: inline-block;
}

.ivu-date-picker {
  display: block;
}
.cp {
  cursor: pointer;
}
.serach_bar {
  display: flex;
  justify-content: space-between;
  .input {
    width: 150px;

    margin-right: 10px;
  }
  .serach_bar_left {
    display: flex;
    .select {
      margin-right: 10px;
      width: 150px;
    }

    .input_group {
      display: flex;
      align-items: center;
      margin-right: 10px;
      .input {
        margin-right: 0px;
      }
    }
    .select {
      margin-left: 10px;
      width: 150px;
    }
  }
}
.sinput {
  width: 100px;
  text-align: center;
}
.table_page {
  margin-top: 20px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
</style>
