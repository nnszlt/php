<template>
  <div>
    <Tabs type="card" style="height: 100%;width: 100%;overflow:hidden">
      <TabPane label="可用大类">
        <Card shadow style="height: 100%;width: 100%;overflow:hidden">
          <div class="department-outer">
            <!-- https://github.com/lison16/v-org-tree -->
            <div class="zoom-box">
              <zoom-controller v-model="zoom" :min="20" :max="200"></zoom-controller>
            </div>
            <div class="view-box">
              <org-view
                v-if="data"
                :data="data"
                :zoom-handled="zoomHandled"
                @node-render="render"
                @on-menu-click="handleMenuClick"
              ></org-view>
            </div>
          </div>
        </Card>
      </TabPane>
      <TabPane label="禁用大类">
        <Card shadow style="height: 100%;width: 100%;overflow:hidden">
          <Table :columns="tableColumns" :data="tableDate" border>
            <template slot-scope="{ row }" slot="action">
              <Button type="primary" size="small" style="margin-right: 5px" @click="deltree(row)">恢复</Button>
              <Button type="error" size="small" @click="trashTree(row)">删除</Button>
            </template>
          </Table>
        </Card>
      </TabPane>
    </Tabs>
    <Modal v-model="modalShow" :title="modalTitle" width="360" @on-visible-change="modalHiddel">
      <Input v-model.trim="name" placeholder="请输入大类名称" clearable />
      <div slot="footer">
        <Button type="text" size="large" @click="modalShow=false">取消</Button>
        <Button type="primary" size="large" @click="ok">确定</Button>
      </div>
    </Modal>
  </div>
</template>

<script>
import OrgView from "./components/org-view.vue";
import ZoomController from "./components/zoom-controller.vue";
import {
  getGoodTree,
  addtree,
  edittree,
  deltree,
  getUnTree,
  trashTree
} from "_api/goodtype";
import "./index.less";
export default {
  name: "org_tree_page",
  components: {
    OrgView,
    ZoomController
  },
  data() {
    return {
      data: null,
      zoom: 80,
      modalShow: false,
      name: "",
      modalTitle: "",
      nodeDate: "",
      tableColumns: [
        {
          title: "序号",
          type: "index"
        },
        {
          title: "大类名称",
          key: "label"
        },
        {
          title: "操作",
          slot: "action"
        }
      ],
      tableDate: []
    };
  },
  computed: {
    zoomHandled() {
      return this.zoom / 100;
    }
  },
  methods: {
    setDepartmentData(data) {
      data.isRoot = true;
      return data;
    },
    handleMenuClick({ data, key }) {
      console.log(key);
      // this.$Message.success({
      //   duration: 5,
      //   content: `点击了《${data.label}》节点的'${menuDic[key]}'菜单`
      // });
      this.nodeDate = data;
      if (key == "edit") {
        this.name = data.label;
        this.modalTitle = "编辑大类";
        this.modalShow = true;
      } else if (key == "new") {
        this.modalTitle = "添加大类";
        this.modalShow = true;
      } else {
        this.deltree(data);
      }
    },
    addtree(data) {
      addtree({ id: data.id, label: this.name }).then(res => {
        if (res.data.success) {
          this.getDepartmentData();
          this.$Message.success(res.data.msg);
          this.modalShow = false;
        } else {
          this.$Message.error(res.data.msg);
        }
      });
    },
    edittree(data) {
      edittree({ id: data.id, label: this.name }).then(res => {
        if (res.data.success) {
          this.getDepartmentData();
          this.modalShow = false;
          this.$Message.success(res.data.msg);
        } else {
          this.$Message.error(res.data.msg);
        }
      });
    },
    deltree(data) {
      deltree({ id: data.id, enable: data.enable === 0 ? 1 : 0 }).then(res => {
        if (res.data.success) {
          this.getDepartmentData();
          this.getTable();
          this.$Message.success(res.data.msg);
        } else {
          this.$Message.error(res.data.msg);
        }
      });
    },
    getDepartmentData() {
      getGoodTree({type:1}).then(res => {
        if (res.data.success) {
          this.data = res.data.data;
        } else {
          this.$Message.error(res.data.msg);
        }
      });
    },
    modalHiddel(e) {
      if (!e) {
        this.name = "";
        this.modalTitle = "";
      }
    },
    ok() {
      if (this.modalTitle == "编辑大类") {
        this.edittree(this.nodeDate);
      } else {
        this.addtree(this.nodeDate);
      }
    },
    render(e) {
      console.log(e);
    },
    getTable() {
      getUnTree({type:1}).then(res => {
        if (res.data.success) {
          this.tableDate = res.data.data;
        } else {
          this.$Message.error(res.data.msg);
        }
      });
    },
    trashTree(e) {
      trashTree({ id: e.id }).then(res => {
        if (res.data.success) {
          this.getTable();
          this.$Message.success(res.data.msg);
        } else {
          this.$Message.error(res.data.msg);
        }
      });
    }
  },
  mounted() {
    this.getDepartmentData();
    this.getTable();
  }
};
</script>

<style lang="less" scoped>
/deep/ .ivu-tabs-content {
  height: 79vh;
}
</style>>

