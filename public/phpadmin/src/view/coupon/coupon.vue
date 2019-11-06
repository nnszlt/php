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
          @click="addActive('添加优惠券')"
        >添加</Button>
      </div>
      <div class="serach_bar_left">
        <Select
          class="select"
          placeholder="优惠券类型"
          style="width: 150px"
          v-model="serach.type"
          filterable
          clearable
        >
          <Option v-for="item in tree" :value="item.id" :key="item.id">{{ item.label }}</Option>
        </Select>
        <DatePicker
          class="select"
          type="datetimerange"
          format="yyyy-MM-dd HH:mm"
          placeholder="请选择优惠券有效范围"
          style="width: 300px"
          @on-change="timeChange"
        ></DatePicker>
        <Input class="input" v-model="serach.title" placeholder="优惠券名" clearable />
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
          <el-table-column align="center" :show-overflow-tooltip="true" prop="type" label="优惠券大类">
            <template slot-scope="scope">{{scope.row.type=="TY"?'通用':scope.row.type==2?'满减':'领券'}}</template>
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
      <Form ref="form" :model="modal.form" :rules="modal.rule" :label-width="90">
        <FormItem label="优惠大类" prop="type">
          <Select filterable class="select" v-model="modal.form.type" placeholder="请选择优惠大类">
             <Option v-for="item in tree" :value="item.id" :key="item.id">{{ item.label }}</Option>
          </Select>
        </FormItem>
        <FormItem label="优惠券标题" prop="title">
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
         <FormItem label="优惠券数量" prop="number">
          <Input v-model="modal.form.number"  placeholder="请输入优惠券数量"></Input>
        </FormItem>
          <FormItem label="优惠券价格" prop="price">
          <Input v-model="modal.form.price"  placeholder="请输入优惠券价格"></Input>
        </FormItem>
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
import { selectTree } from "_api/goodtype";
import { couponList,couponAdd,couponEdit } from "_api/coupon";

export default {
  name: "activeList",
  data() {
    return {
      page: {
        //分页
        total: 20,
        pageSize: 20,
        pageNo: 1,
        pageGroup: [20, 30, 40, 50]
      },
      serach: {
        //搜索内容
        title: "",
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
          number:"",
          price:""
        },
        rule: {
          type: [
            {
              required: true,
              message: "请选择优惠券大类"
            }
          ],
          title: [
            {
              required: true,
              message: "请输入优惠券标题"
            }
          ],
          starttime: [
            {
              required: true,
              message: "请选择优惠券时间"
            }
          ],desc:[{
             required: true,
              message: "请输入优惠券简介"
          }]
        }
      },
      tree: []
    };
  },
  mounted() {
    this.getlist();
    this.selectTree();
    this.tableHeight =
      $(window).height() -
      $(".serach_bar").height() -
      $(".serach_bar").height() -
      175;
  },
  methods: {
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
      data.type = data.type == "all" ? "" : data.type;

      couponList(data)
        .then(res => {
          $(".el-table__body-wrapper").scrollTop(0);
          this.page.total = res.data.data.total;
          this.datalist = res.data.data.records;
        })
        .catch(err => {
          console.log(err);
        });
    },
    selectTree() {
      selectTree().then(res => {
        if (res.data.success) {
          this.tree = res.data.data;
          this.tree[0] = { id: "TY", label: "通用优惠券", Fpid: 0 };
        } else {
          this.$Message.error(res.data.msg);
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
      this.modal.form.desc = data.desc;
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
        type: this.modal.form.type,
        number:this.modal.form.number,
        price:this.modal.form.price
      };
      if (this.modal.modalTitle == "添加优惠券") {
        couponAdd(data).then(res => {
          if (res.data.success) {
            this.resetFrom();
            this.getlist();
          } else {
            this.$Message.error(res.data.msg);
          }
        });
      } else {
        data.starttime = Date.parse(data.starttime);
        data.endtime = Date.parse(data.endtime);
        couponEdit(data).then(res => {
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
