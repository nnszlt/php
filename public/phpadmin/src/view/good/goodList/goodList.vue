<template>
  <div class="mailListManger minwidth">
    <div class="serach_bar">
      <div class="serach_bar_left">
        <RadioGroup
          class="RadioGroup"
          v-model="save.grayStatus"
          type="button"
          size="large"
          @on-change="rideoGroupChange"
        >
          <Radio value="all" :label="rideoGroup.total"></Radio>
          <Radio value="0" :label="rideoGroup.normal"></Radio>
          <Radio value="1" :label="rideoGroup.gray"></Radio>
        </RadioGroup>
      </div>
      <div class="serach_bar_right">
        <Input style="width:100px;" class="input" v-model="serach.no" placeholder="产品型号" clearable />
        <Input
          style="width:100px;"
          class="input"
          v-model="serach.brand"
          placeholder="产品品牌"
          clearable
        />
        <Input
          style="width:100px;"
          class="input"
          v-model="serach.name"
          placeholder="产品名称"
          clearable
        />
        <Select class="select juesleixing" v-model="serach.label" filterable>
          <Option v-for="item in tags" :value="item.id" :key="item.id">{{ item.name }}</Option>
        </Select>
        <Button type="primary" icon="ios-search" @click="serachdata()">搜索</Button>
      </div>
    </div>
    <div class="serach_bar mt10">
      <div class="serach_bar_left">
        <Button disabled icon="md-sync">数据同步</Button>
      </div>
      <div class="serach_bar_right">
        <Button
          class="margin-left-sm"
          :type="tableSelect.length>0?'primary':'dashed'"
          :disabled="tableSelect.length==0"
          @click="addActive"
        >添加活动</Button>
        <Button :to="{ name: 'addGood',params: { id: 'add' }}" type="primary" icon="md-add">添加商品</Button>
        <Button
          class="margin-left-sm"
          :type="tableSelect.length>0?'primary':'dashed'"
          :disabled="tableSelect.length==0"
          icon="ios-trash"
          @click="del_table"
        >删除</Button>
      </div>
    </div>
    <div class="content">
      <div class="tree">
        <div class="tree_header">
          <span>部门列表</span>
        </div>
        <div class="tree_content">
          <Tree :data="tree" @on-select-change="treeClick"></Tree>
        </div>
      </div>
      <div class="table">
        <Table
          highlight-row
          :max-height="tableHeight"
          border
          ref="selection"
          :columns="dataliststyle"
          :data="datalist"
          tooltip-placement="top"
          @on-selection-change="table_select"
          @on-select-cancel="tableCancel"
          @on-select-all="tableSelectAll"
          @on-select-all-cancel="tableSelectCancel"
        >
          <template slot-scope="{ row }" slot="enable">{{row.enable===0?'已上架':'已下架'}}</template>
          <template slot-scope="{ row }" slot="action">
            <div class="buttonGroup">
              <router-link
                tag="span"
                class="cpl"
                :to="{ name: 'addGood', params: { id: row.id }}"
              >编辑</router-link>
              <span class="cpl" @click="enable(row)">{{row.enable===0?'下架':'上架'}}</span>
              <span>报表</span>
            </div>
          </template>
        </Table>
        <div class="table_page">
          <div>
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
    </div>
    <Modal
      title="添加活动"
      width="700"
      v-model="modal.modalShow"
      :styles="{top: '20px'}"
      @on-visible-change="modalReset"
    >
      <div class="modalSerach">
        <Select class="select" style="width: 125px" v-model="modal.serach.type">
          <Option v-for="item in modal.type" :value="item.id" :key="item.id">{{ item.name }}</Option>
        </Select>
        <DatePicker
          ref="modalDay"
          :value="modal.time"
          class="select padding-horizontal-sm"
          type="datetimerange"
          format="yyyy-MM-dd HH:mm"
          placeholder="请选择活动时间"
          style="width: 300px"
          @on-change="modaltimeChange"
        ></DatePicker>
        <Input
          class="padding-right-sm input"
          style="width: 125px"
          v-model="modal.serach.title"
          placeholder="活动名"
          clearable
        />
        <Button type="primary" icon="ios-search" @click="modalSerachdata()">搜索</Button>
      </div>
      <RadioGroup v-model="modal.ridio" class="RadioGroup margin-top-sm">
        <div class="listRideo">
          <Collapse accordion>
            <Panel v-for="item in modal.activeList" :key="item.id">
              <Radio
                :label="item.id"
              >{{`【${item.type==1?'秒杀':item.type==2?'满减':'领券'}】${item.title}`}}</Radio>
              <div slot="content">
                <p v-if="item.type==1">秒杀： 产品原价减{{item.miaosha}}</p>
                <p
                  v-else-if="item.type==2"
                >满减：满{{item.manjian.split(",")[0]}}减{{item.manjian.split(",")[1]}}</p>
                <p v-else>
                  优惠券：减{{item.couponPrice}}
                  <br />
                  优惠券简介：{{item.couponDesc}}
                </p>
                <p>时间：{{formatDate(item.starttime*1000)+"--"+formatDate(item.endtime*1000)}}</p>
                <p>简介：{{item.desc}}</p>
              </div>
            </Panel>
          </Collapse>
        </div>
      </RadioGroup>
      <Page
        class="margin-top-sm"
        :total="modal.page.total"
        :current="modal.page.pageNo"
        show-total
        show-elevator
        show-sizer
        :page-size="20"
        :page-size-opts="modal.page.pageGroup"
        @on-change="modalpageChange"
        @on-page-size-change="modalpageGroupChange"
      ></Page>
      <div slot="footer">
        <Button type="text" size="large" @click="modal.modalShow=false">取消</Button>
        <Button type="primary" size="large" @click="activeSubmit">确定</Button>
      </div>
    </Modal>
  </div>
</template>
<script>
import { getGoodTree } from "_api/goodtype";
import { listGoods, enableGoods, delGoods } from "_api/goods";
import { listtags } from "_api/tags";
import { listActive, goodAddActive } from "_api/active";

export default {
  name: "goodList",
  data() {
    return {
      modal: {
        modalShow: false,
        ridio: "",
        time: "",
        activeList: [],
        serach: {
          title: "",
          enable: "all",
          type: "all",
          starttime: "",
          endtime: ""
        },
        type: [
          { name: "所有活动", id: "all" },
          { name: "秒杀", id: "1" },
          { name: "满减", id: "2" },
          { name: "送券", id: "3" }
        ],
        collapse: false,
        page: {
          //分页
          total: 20,
          pageSize: 20,
          pageNo: 1,
          pageGroup: [20, 30, 40, 50]
        }
      },
      page: {
        //分页
        total: 20,
        pageSize: 20,
        pageNo: 1,
        pageGroup: [20, 30, 40, 50]
      },
      save: {
        grayStatus: "全部"
      },
      tags: [],
      rideoGroup: {
        normal: "正常",
        total: "全部",
        gray: "禁用"
      },
      serach: {
        type: "",
        grayStatus: "",
        name: "",
        tag: "",
        no: "",
        brand: "",
        label: "",
        followStatus: "all"
      },
      tableHeight: null,
      tableSelect: [],
      datalist: [],
      dataliststyle: [
        {
          type: "selection",
          width: 50,
          align: "center"
        },

        {
          title: "序号",
          key: "name",
          type: "index",
          indexMethod: this.myindex,
          width: 61,
          align: "center"
        },
        {
          title: "产品名称",
          key: "name",
          ellipsis: true,
          tooltip: true,
          align: "center",
          minWidth: 30
          //4个
        },
        {
          title: "价格",
          key: "price",
          ellipsis: true,
          tooltip: true,
          align: "center",
          maxWidth: 115,
          minWidth: 30
          //8个
        },
        {
          title: "库存",
          key: "number",
          ellipsis: true,
          tooltip: true,
          align: "center",
          maxWidth: 115,
          minWidth: 30
          //11位
        },
        {
          title: "上下架",
          key: "enable",
          ellipsis: true,
          tooltip: true,
          align: "center",
          slot: "enable",
          minWidth: 30
          //28
        },
        {
          title: "活动",
          key: "activeTitle",
          ellipsis: true,
          tooltip: true,
          align: "center"
        },
        {
          title: "操作",
          width: 95,
          slot: "action",
          align: "center"
        }
      ],
      gzlist: [
        {
          value: "all",
          label: "全部"
        },
        {
          value: 1,
          label: "已关注"
        },
        {
          value: 0,
          label: "未关注"
        }
      ],
      tree: []
    };
  },
  mounted() {
    var that = this;
    this.getlist();
    this.getTree();
    this.getTags();
    this.getActiveList();
    setTimeout(function() {
      that.tableHeight = $(".mailListManger .tree").height() - 50;
    }, 200);
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
    tableCancel(selection, row) {
      if (selection.length == 0) {
        this.tableSelect = [];
      }
    },
    del_table() {
      this.$Modal.confirm({
        title: "删除",
        content: "<p>是否删除？</p>",
        onOk: () => {
          this.$Message.destroy();
          var idArr = [];
          //删除行
          // this.$Message.loading({
          //   content: "Loading...",
          //   duration: 0
          // });
          this.tableSelect.map((v, i) => {
            idArr.push(v.id);
          });
          delGoods({ id: idArr.toString() }).then(res => {
            this.$Message.destroy();
            if (res.data.success) {
              this.$Message.success(res.data.msg);
              this.getlist();
            } else {
              this.$Message.error(res.data.msg);
            }
          });
        },
        onCancel: () => {}
      });
    },
    tableSelectAll(selection) {
      //全选
      this.tableSelect = selection;
    },
    tableSelectCancel(selection) {
      //全取消
      this.tableSelect = [];
    },
    serachdata(page) {
      //搜索
      this.page.pageNo = 1;
      this.getlist();
    },
    modalSerachdata() {
      this.modal.page.pageNo = 1;
      this.getActiveList();
    },
    pageChange(page) {
      //页码改变
      this.page.pageNo = page;
      this.getlist();
    },
    modalpageChange(page) {
      this.modal.page.pageNo = page;
      this.getActiveList();
    },
    pageGroupChange(pageGroup) {
      //改变每页条数
      this.page.pageNo = 1;
      this.page.pageSize = pageGroup;
      this.getlist();
    },
    modalpageGroupChange(pageGroup) {
      //改变每页条数
      this.modal.page.pageNo = 1;
      this.modal.page.pageSize = pageGroup;
      this.getActiveList();
    },
    rideoGroupChange(v) {
      if (v.indexOf("全部") > -1) {
        this.serach.enable = "";
      } else if (v.indexOf("上架") > -1) {
        this.serach.enable = 0;
      } else if (v.indexOf("下架") > -1) {
        this.serach.enable = 1;
      }
      this.getlist();
    },
    getlist() {
      var data = {
        pageNo: this.page.pageNo,
        pageSize: this.page.pageSize,
        enable: this.serach.enable,
        type: this.serach.type,
        no: this.serach.no,
        brand: this.serach.brand
      };
      listGoods(data)
        .then(res => {
          $(".el-table__body-wrapper").scrollTop(0);
          this.tableSelect = [];
          this.rideoGroup.total = `全部 (${res.data.data.normal +
            res.data.data.gray})`;
          this.rideoGroup.normal = `上架 (${res.data.data.normal})`;
          this.rideoGroup.gray = `下架 (${res.data.data.gray})`;
          res.data.data.records.map((v, i) => {
            v.index = (this.page.pageNo - 1) * this.page.pageSize + 1 + i;
          });
          this.page.total = res.data.data.total;
          this.datalist = res.data.data.records;
        })
        .catch(err => {
          console.log(err);
        });
    },
    getTree() {
      getGoodTree({ type: 2 }).then(res => {
        if (res.data.success) {
          this.tree = res.data.data.children;
        } else {
          this.$Message.error(res.data.msg);
        }
      });
    },
    getTags() {
      listtags({ enable: 0, pageSize: 100000000 }).then(res => {
        if (res.data.success) {
          this.tags = res.data.data.records;
        } else {
          this.$Message.error(res.data.msg);
        }
      });
    },
    enable(e) {
      enableGoods({ id: e.id, enable: e.enable === 0 ? 1 : 0 }).then(res => {
        if (res.data.success) {
          this.getlist();
          this.$Message.success(res.data.msg);
        } else {
          this.$Message.error(res.data.msg);
        }
      });
    },
    treeClick(e) {
      this.serach.type = e[0].length === 0 ? "" : e[0].id;
      this.getlist();
    },
    addActive() {
      this.modal.modalShow = true;
    },
    getActiveList() {
      let data = {
        enable: 0,
        from: 2,
        endtime: this.modal.serach.endtime,
        starttime: this.modal.serach.starttime,
        type: this.modal.serach.type == "all" ? "" : this.modal.serach.type,
        title: this.modal.serach.title
      };
      listActive(data).then(res => {
        if (res.data.success) {
          this.modal.activeList = res.data.data.records;
          this.modal.page.total = res.data.data.total;
        } else {
          this.$Message.error(res.data.msg);
        }
      });
    },
    timeChange(e) {
      this.serach.starttime = Date.parse(e[0]) / 1000;
      this.serach.endtime = Date.parse(e[1]) / 1000;
    },
    modaltimeChange(e) {
      this.modal.serach.starttime = Date.parse(e[0]) / 1000;
      this.modal.serach.endtime = Date.parse(e[1]) / 1000;
    },
    modalReset(e) {
      this.modal.ridio = "";
      this.modal.serach.title = "";
      this.modal.serach.type = "";
      this.modal.serach.starttime = "";
      this.modal.serach.endtime = "";
      this.modal.serach.title = "";
      this.modal.serach.title = "";
      this.$refs["modalDay"].handleClear();
      this.modal.page.pageSize = 20;
      this.modal.page.pageNo = 1;
      if (!e) {
        this.getActiveList();
      }
    },
    activeSubmit() {
      let id = [];
      this.tableSelect.map((v, i) => {
        id.push(v.id);
      });
      let data = {
        id: id.toString(),
        activeid: this.modal.ridio
      };

      goodAddActive(data).then(res => {
        if (res.data.success) {
         this.modal.modalShow=false;
          this.$Message.success(res.data.msg);
        } else {
          this.$Message.error(res.data.msg);
        }
      });
    }
  }
};
</script>
<style lang="less" scoped>
.ivu-radio-group-button.ivu-radio-group-large .ivu-radio-wrapper {
  font-size: 12px;
}
.buttonGroup {
  display: flex;
  justify-content: center;
  button {
    &:first-child {
      margin-right: 10px;
    }
  }
}
.ivu-radio-group-button .ivu-radio-wrapper-checked {
  background: #2d8cf0;
  border-color: #2d8cf0;
  color: white;
  -webkit-box-shadow: -1px 0 0 0 #2d8cf0;
  box-shadow: -1px 0 0 0 #2d8cf0;
  z-index: 1;
}
.mailListManger {
  position: relative;
  height: 100%;
}
.mt10 {
  margin-top: 10px;
}
.serach_bar {
  display: flex;
  justify-content: space-between;
  .serach_bar_left {
    .ivu-upload {
      display: inline-block;
    }
  }
  .serach_bar_right {
    .ivu-upload {
      display: inline-block;
    }
  }
  button {
    margin-right: 10px;
  }
  .select {
    margin-right: 10px;
    width: 150px;
  }
  .input {
    width: 100px;
    margin-right: 10px;
  }
}

.table_page {
  margin-top: 20px;
  display: flex;
  justify-content: space-between;
}
.tree {
  max-height: 300px;
  overflow: auto;
}
.content {
  display: flex;
  margin-top: 20px;
  width: 100%;
  position: absolute;
  height: ~"calc(100% - 100px)";
  .tree {
    width: 240px;
    height: 100%;
    max-height: 100%;
    overflow: hidden;
    background: white;
    .tree_header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      background: #f8f8f9;
      border: 1px solid #e8eaec;

      padding: 5px 10px;
      span {
        font-size: 13px;
        font-weight: bold;
      }
    }
    .tree_content {
      height: ~"calc(100% - 25px)";
      overflow: auto;
      border-bottom: 1px solid #e8eaec;
      padding: 8px;
    }
  }
  .table {
    width: ~"calc(100% - 240px)";
    width: ~"calc(100% - 240px)";
    padding-left: 20px;
  }
}
.modalSerach {
  display: flex;
}
.RadioGroup {
  width: 100%;
}
</style>
