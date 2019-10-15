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
        <Input
          style="width:242px;"
          class="input"
          v-model="serach.searchWord"
          placeholder="工号/姓名/邮箱/部门/标签"
          clearable
        />
        <Select class="select juesleixing" v-model="serach.followStatus">
          <Option v-for="item in gzlist" :value="item.value" :key="item.value">{{ item.label }}</Option>
        </Select>
        <Button type="primary" icon="ios-search" @click="serachdata()">搜索</Button>
      </div>
    </div>
    <div class="serach_bar mt10">
      <div class="serach_bar_left">
        <Button disabled icon="md-sync">数据同步</Button>
      </div>
      <div class="serach_bar_right">
        <Button :to="{ name: 'addGood'}" type="primary" icon="md-add">添加商品</Button>
        <Button
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
          <template slot-scope="{ row, index }" slot="action">
            <div class="buttonGroup">
              <Tooltip content="编辑" placement="top">
                <Icon
                  class="cp"
                  size="25"
                  @click="showRoleModal3('edit',row,index)"
                  type="ios-create-outline"
                />
              </Tooltip>
              <Tooltip :content="row.grayStatus=='正常'?'加入灰名单':'移出灰名单'" placement="top">
                <Icon
                  class="cp"
                  size="20"
                  @click="grayStatus(row,index)"
                  :type="row.grayStatus=='正常'?'md-person-add':'md-person'"
                />
              </Tooltip>

              <Tooltip :content="row.grayStatus=='正常'?'加入灰名单':'移出灰名单'" placement="top">
                <Icon
                  class="cp"
                  size="20"
                  @click="grayStatus(row,index)"
                  :type="row.grayStatus=='正常'?'md-person-add':'md-person'"
                />
              </Tooltip>
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
  </div>
</template>
<script>
import { getGoodTree } from "_api/goods";
export default {
  name: "goodList",
  data() {
    return {
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
      rideoGroup: {
        normal: "正常",
        total: "全部",
        gray: "禁用"
      },
      serach: {
        grayStatus: "",
        searchWord: "",
        tag: "",
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
          title: "可用",
          key: "enable",
          ellipsis: true,
          tooltip: true,
          align: "center",

          minWidth: 30
          //28
        },
        {
          title: "标签",
          key: "tag",
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
          allEmployee.deletEmployee({ ids: idArr.toString() }).then(res => {
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
    rideoGroupChange(v) {
      if (v.indexOf("全部") > -1) {
        this.serach.grayStatus = "";
      } else if (v.indexOf("正常") > -1) {
        this.serach.grayStatus = 0;
      } else if (v.indexOf("灰名单") > -1) {
        this.serach.grayStatus = 1;
      }
      this.getlist();
    },
    getlist() {
      return;
      //获取列表信息
      var data = {
        pageNo: this.page.pageNo,
        pageSize: this.page.pageSize,
        followStatus:
          this.serach.followStatus == "all" ? "" : this.serach.followStatus,
        groupName: this.serach.groupName,
        groupId: this.serach.groupId,
        searchWord: this.serach.searchWord,
        grayStatus: this.serach.grayStatus
      };

      allEmployee
        .pageEmployee(data)
        .then(res => {
          $(".el-table__body-wrapper").scrollTop(0);
          this.tableSelect = [];
          this.rideoGroup.total = `全部 (${res.data.data.normal +
            res.data.data.gray})`;
          this.rideoGroup.normal = `正常 (${res.data.data.normal})`;
          this.rideoGroup.gray = `灰名单 (${res.data.data.gray})`;
          res.data.data.records.map((v, i) => {
            v.index = (this.page.pageNo - 1) * this.page.pageSize + 1 + i;
            if (v.followStatus == 0) {
              v.followStatus = "未关注";
            } else if (v.followStatus == 1) {
              v.followStatus = "已关注";
            }
            if (v.grayStatus == 0) {
              v.grayStatus = "正常";
            } else if (v.grayStatus == 1) {
              v.grayStatus = "已拉灰";
            }
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
          console.log(this.tree);
        } else {
          this.$Message.error(res.data.msg);
        }
      });
    },
    treeClick(e) {
      console.log(e);
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
</style>
