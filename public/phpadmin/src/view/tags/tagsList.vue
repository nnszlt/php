<template>
  <div class="infoManger minwidth">
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
          @click="addTags('添加标签')"
        >添加</Button>
      </div>
      <div class="serach_bar_left">
        <Select class="select" v-model="serach.enable">
          <Option v-for="item in enable" :value="item.value" :key="item.value">{{ item.name }}</Option>
        </Select>
        <Input class="input" v-model="serach.searchWord" placeholder="姓名/工号/留言内容" clearable />
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
          <el-table-column align="center" :show-overflow-tooltip="true" prop="name" label="标签名"></el-table-column>
          <el-table-column align="center" :show-overflow-tooltip="true" prop="enable" label="标签简介">
            <template slot-scope="scope">{{scope.row.enable==0?'可用':'不可用'}}</template>
          </el-table-column>
          <el-table-column align="center" :show-overflow-tooltip="true" prop="content" label="标签简介"></el-table-column>
          <el-table-column align="center" :show-overflow-tooltip="true" label="操作">
            <template slot-scope="scope">
              <span @click="editTags('编辑标签',scope.row)" class="cpl margin-left-sm">编辑</span>
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
    <Modal v-model="modal.modalShow" :title="modal.modalTitle">
      <Form ref="tagsForm" :model="modal.form" :rules="modal.rule" :label-width="80">
        <FormItem label="标签名" prop="name">
          <Input v-model="modal.form.name" placeholder="请输入标签名"></Input>
        </FormItem>

        <FormItem label="是否可用" prop="enable">
          <RadioGroup v-model="modal.form.enable">
            <Radio label="0">可用</Radio>
            <Radio label="1">不可用</Radio>
          </RadioGroup>
        </FormItem>

        <FormItem label="标签简介" prop="content">
          <Input v-model="modal.form.content" type="textarea" placeholder="请输入标签简介"></Input>
        </FormItem>
      </Form>
      <div slot="footer">
        <Button type="text" size="large" @click="modalShow=false">取消</Button>
        <Button type="primary" size="large" @click="ok">确定</Button>
      </div>
    </Modal>
    <!-- 添加标签e -->
  </div>
</template>
<script>
import { listtags, addtags, edittags, deltags } from "_api/tags";
export default {
  name: "brarList",
  data() {
    return {
      APi: window.API,
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
      serach: {
        //搜索内容
        searchWord: "",
        enable: "all"
      },
      tableHeight: null,
      tableSelect: [],
      datalist: [],
      modal: {
        modalShow: false,
        modalTitle: "",
        name: "",
        content: "",
        form: {
          id: "",
          name: "",
          content: "",
          enable: "0"
        },
        rule: {
          name: [
            {
              required: true,
              message: "请输入标签名"
            }
          ],
          enable: [
            {
              required: true
            }
          ]
        }
      }
    };
  },
  mounted() {
    this.getlist();
    this.tableHeight =
      $(window).height() -
      $(".serach_bar").height() -
      $(".serach_bar").height() -
      175;
  },
  methods: {
    myindex(r) {
      //自定义 序列号
      return r.index;
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
      console.log(123);
      //获取列表信息
      var data = JSON.parse(JSON.stringify(this.serach));
      data.pageNo = this.page.pageNo;
      data.pageSize = this.page.pageSize;
      data.enable = data.enable == "all" ? "" : data.enable;
      listtags(data)
        .then(res => {
          $(".el-table__body-wrapper").scrollTop(0);
          this.page.total = res.data.data.total;
          this.datalist = res.data.data.records;
        })
        .catch(err => {
          console.log(err);
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
        content: "<p>是否删除标签？</p>",
        onOk: () => {
          deltags({ id: idArr.toString() }).then(res => {
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
    addTags(e) {
      this.modal.modalTitle = e;
      this.modal.form.name = "";
      this.modal.form.content = "";
      this.modal.form.id = "";
      this.modal.modalShow = true;
    },
    editTags(e, data) {
      this.modal.modalTitle = e;
      this.modal.form.name = data.name;
      this.modal.form.content = data.content;
      this.modal.form.id = data.id;
      this.modal.modalShow = true;
    },
    ok() {
      if (this.modal.modalTitle == "添加标签") {
        let data = {
          name: this.modal.form.name,
          content: this.modal.form.content
        };
        addtags(data).then(res => {
          if (res.data.success) {
            this.getlist();
            this.$Message.success(res.data.msg);
            this.modal.modalShow = false;
          } else {
            this.$Message.error(res.data.msg);
          }
        });
      } else {
        let data = {
          id: this.modal.form.id,
          name: this.modal.form.name,
          content: this.modal.form.content,
          enable: parseInt(this.modal.form.enable)
        };
        edittags(data).then(res => {
          if (res.data.success) {
            this.getlist();
            this.$Message.success(res.data.msg);
            this.modal.modalShow = false;
          } else {
            this.$Message.error(res.data.msg);
          }
        });
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

.table_page {
  margin-top: 20px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
</style>
