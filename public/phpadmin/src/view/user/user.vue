<template>
  <div class="role myBody minwidth">
    <div class="serach_bar">
      <div class="serach_bar_right">
        <Button type="primary" icon="ios-add-circle-outline" @click="Account('添加账号')">添加</Button>
        <Button
          :disabled="tableSelect.length==0"
          icon="ios-remove-circle-outline"
          @click="del_table"
        >删除</Button>
        <Button
          :disabled="tableSelect.length==0"
          icon="ios-radio-button-off"
          @click="changeStatus('启用')"
        >启用</Button>
        <Button :disabled="tableSelect.length==0" icon="md-power" @click="changeStatus('停用')">停用</Button>
      </div>
      <div class="serach_bar_left">
        <Select class="select juesleixing" v-model="serach.enable" placeholder="账号状态">
          <Option v-for="item in enableList" :value="item.id" :key="item.id">{{ item.name }}</Option>
        </Select>
        <Select class="select juesleixing" v-model="serach.type" placeholder="终端">
          <Option v-for="item in zdList" :value="item.id" :key="item.id">{{ item.name }}</Option>
        </Select>
        <Input class="input" v-model="serach.account" placeholder="账户" clearable />
        <Button type="primary" icon="ios-search" @click="serachdata()">搜索</Button>
      </div>
    </div>

    <div class="table">
      <el-table
        :data="datalist"
        border
        fit
        :max-height="tableHeight"
        @selection-change="table_select"
        empty-text="暂无数据"
      >
        <el-table-column align="center" type="selection" width="55"></el-table-column>
        <el-table-column
          align="center"
          width="65"
          :show-overflow-tooltip="true"
          prop="index"
          label="序号"
        >
          <template slot-scope="scope">{{(page.pageNo-1)*page.pageSize+scope.$index+1}}</template>
        </el-table-column>
        <el-table-column align="center" :show-overflow-tooltip="true" prop="account" label="账户"></el-table-column>
        <el-table-column align="center" :show-overflow-tooltip="true" label="可访问终端">
          <template
            slot-scope="scope"
          >{{scope.row.type==0?'前台':scope.row.type==1?'后台':scope.row.type==2?'前后台':''}}</template>
        </el-table-column>
        <el-table-column
          align="center"
          :show-overflow-tooltip="true"
          prop="lastLoginTime"
          label="上次登录时间"
        >
          <template
            slot-scope="scope"
          >{{scope.row.lastLoginTime==null?'':formatDate(scope.row.lastLoginTime*1000)}}</template>
        </el-table-column>
        <el-table-column align="center" :show-overflow-tooltip="true" prop="enable" label="状态">
          <template slot-scope="scope">{{scope.row.enable==0?'停用':'启用'}}</template>
        </el-table-column>
        <el-table-column
          align="center"
          :show-overflow-tooltip="true"
          prop="createTime"
          label="创建时间"
        >
          <template slot-scope="scope">{{formatDate(scope.row.createTime*1000)}}</template>
        </el-table-column>
        <el-table-column align="center" label="操作">
          <template slot-scope="scope">
            <el-tooltip :enterable="false" content="编辑" placement="top">
              <Icon
                class="cp"
                size="25"
                width="80"
                @click="AccountEdit(scope.row,scope.$index)"
                type="ios-create-outline"
              />
            </el-tooltip>
          </template>
        </el-table-column>
      </el-table>
      <Page
        class="table_page"
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
    <!--START 搜索 -->

    <!-- 添加账户START -->
    <Modal v-model="model.modelShow" :title="model.modelTitle">
      <Form ref="modelForm" :model="model.form" :label-width="100" :rules="model.rules">
        <FormItem label="账号" prop="account">
          <Input v-model="model.form.account" clearable placeholder="请输入账号"></Input>
        </FormItem>
        <FormItem label="密码" prop="password">
          <Input v-model="model.form.password" clearable placeholder="请输入密码"></Input>
        </FormItem>
        <FormItem label="昵称" prop="nikename">
          <Input v-model="model.form.nikename" clearable placeholder="请输入昵称"></Input>
        </FormItem>
        <FormItem label="性别" prop="sex">
          <RadioGroup v-model="model.form.sex">
            <Radio :label="1">女</Radio>
            <Radio :label="0">男</Radio>
          </RadioGroup>
        </FormItem>
        <FormItem label="电话" prop="phone">
          <Input v-model="model.form.phone" clearable placeholder="请输入电话"></Input>
        </FormItem>
        <FormItem label="后台访问权限" prop="menuAuth">
          <Tree :data="menuAuthTree" show-checkbox @on-check-change="treeSelect"></Tree>
        </FormItem>
        <FormItem label="账号状态" prop="enable">
          <RadioGroup v-model="model.form.enable">
            <Radio :label="0">关闭</Radio>
            <Radio :label="1">启用</Radio>
          </RadioGroup>
        </FormItem>
        <FormItem label="访问终端" prop="type">
          <RadioGroup v-model="model.form.type">
            <Radio :label="0">前台</Radio>
            <Radio :label="1">后台</Radio>
            <Radio :label="2">前后台</Radio>
          </RadioGroup>
        </FormItem>
      </Form>
      <div slot="footer">
        <Button type="text" size="large" @click="modalShow=false">取消</Button>
        <Button type="primary" size="large" @click="ok(model.modelTitle)">确定</Button>
      </div>
    </Modal>

    <!-- 添加账户END -->
  </div>
</template>
<script>
import {
  menuAuth,
  userList,
  addUser,
  showUser,
  editUser,
  enableUser,
  delUser
} from "_api/user";
export default {
  name: "user",
  data() {
    return {
      menuAuthTree: [],
      menuAuthTreeClear: [],
      enableList: [
        { name: "所有账号", id: "all" },
        { name: "启用账号", id: 1 },
        { name: "停用账号", id: 0 }
      ],
      zdList: [
        { name: "所有终端", id: "all" },
        { name: "前台", id: 0 },
        { name: "后台", id: 1 }
      ],
      tableHeight: null,
      tableSelect: [],
      datalist: [],
      page: {
        //分页
        total: 20,
        pageSize: 20,
        pageNo: 1,
        pageGroup: [20, 30, 40, 50]
      },
      serach: {
        //搜索内容
        enable: "all",
        type: "all",
        account: ""
      },
      model: {
        id: "",
        modelShow: false,
        modelTitle: "",
        form: {
          account: "",
          password: "",
          nikename: "",
          sex: "",
          phone: "",
          menuAuth: "",
          authKeys: "",
          enable: "",
          type: ""
        },
        rules: {
          account: [
            { required: true, message: "请输入账号", trigger: "blur" },
            { min: 6, message: "账号最少6个字", trigger: "blur" }
          ],
          password: [
            { required: true, message: "请输入密码", trigger: "blur" },
            { min: 3, message: "密码最少3个字", trigger: "blur" }
          ],
          menuAuth: [
            // { required: true, message: "请选择访问菜单", trigger: "blur" }
          ],
          enable: [
            { required: true, message: "请选择账号状态", trigger: "blur" }
          ],
          type: [{ required: true, message: "请选择访问终端", trigger: "blur" }]
        }
      }
    };
  },
  created() {},
  mounted() {
    this.menuAuth();
    this.getlist();
    this.tableHeight = $(window).height() - $(".serach_bar").height() - 220;
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
      this.$Message.destroy();
      this.$Modal.confirm({
        title: "删除",
        content: "<p>是否删除？</p>",
        onOk: () => {
          var idArr = [];
          //删除行
          this.tableSelect.map((v, i) => {
            idArr.push(v.id);
          });
         delUser({ id: idArr.toString() }).then(res => {
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
    changeStatus(e) {
      let data = {
        id: []
      };
      this.tableSelect.map(res => {
        data.id.push(res.id);
      });
      data.id = data.id.toString();
      data.enable = e == "启用" ? 1 : 0;
      enableUser(data).then(res => {
        if (res.data.success) {
            this.getlist();
          this.$Message.success(res.data.msg);
        } else {
          this.$Message.error(res.data.msg);
        }
      });
    },
    menuAuth() {
      menuAuth().then(res => {
        if (res.data.success) {
          this.menuAuthTree = res.data.data;
          this.menuAuthTreeClear = res.data.data;
        }
      });
    },
    getlist() {
      //获取列表信息
      var data = {
        enable: this.serach.enable == "all" ? "" : this.serach.enable,
        type: this.serach.type == "all" ? "" : this.serach.type,
        account: this.serach.account,
        pageNo: this.page.pageNo,
        pageSize: this.page.pageSize
      };

      userList(data)
        .then(res => {
          $(".el-table__body-wrapper").scrollTop(0);
          this.tableSelect = [];
          this.page.total = res.data.data.total;
          this.datalist = res.data.data.records;
        })
        .catch(err => {
          console.log(err);
        });
    },
    treeSelect(e) {
      this.model.form.menuAuth = e;
    },
    showAccount(id) {
      this.model.modelTitle = "编辑账号";
      this.$Message.destroy();
      showUser({ id: id }).then(res => {
        if (res.data.success == false) {
          this.$Message.error(res.data.msg);
        } else {
          this.model.form = {
            account: res.data.data.account,
            password: "删除修改密码",
            nikename: res.data.data.nikename,
            sex: res.data.data.sex,
            phone: res.data.data.phone,
            menuAuth: res.data.data.menuAuth,
            authKeys: res.data.data.authKeys,
            enable: res.data.data.enable,
            type: res.data.data.type
          };
          this.setTree(res.data.data.menuAuth.split(","));
        }
      });
    },
    setTree(menuAuth) {
      let that = this;
      var menuAuthTree = JSON.parse(JSON.stringify(that.menuAuthTree));
      var dgdata = function() {
        var str = [];
        var dg = function(list) {
          console.log(menuAuth);
          list.forEach(function(row, index) {
            if (row.children) {
              //   menuAuth.includes(row.menuid) ? (row.checked = true) : "";
              dg(row.children);
            } else {
              menuAuth.includes(row.menuid) ? (row.checked = true) : "";
            }
          });
        };
        dg(menuAuthTree);
        that.menuAuthTree = menuAuthTree;
      };
      dgdata();
    },
    AccountEdit(data, index) {
      //更新编辑
      this.model.id = data.id;
      this.$refs["modelForm"].resetFields();
      this.model.modelShow = true;
      this.model.modelTitle = "编辑账号";
      this.showAccount(data.id);
    },
    Account(e) {
      //添加账号
      this.menuAuthTree = this.menuAuthTreeClear;
      this.$refs["modelForm"].resetFields();
      this.model.modelTitle = "添加账号";
      this.model.modelShow = true;
    },

    password(rule, value, callback) {
      //新加表单验证
      if (this.modal.modalForm1.password != value) {
        callback(new Error("两次密码不同"));
      } else {
        callback();
      }
    },
    ok() {
      let that = this;
      let data = JSON.parse(JSON.stringify(that.model.form));
      if (typeof data.menuAuth != "String") {
        let menuAuth = [];
        data.menuAuth.map(res => {
          menuAuth.push(res.menuid);
        });
        data.menuAuth = menuAuth.toString();
      }

      if (this.model.modelTitle == "添加账号") {
        addUser(data).then(res => {
          if (res.data.success) {
            this.model.modelShow = false;
            this.$refs["modelForm"].resetFields();
            this.$Message.success(res.data.msg);
            this.menuAuthTree = this.menuAuthTreeClear;
            this.getlist();
          } else {
            this.$Message.error(res.data.msg);
          }
        });
      } else {
        data.id = this.model.id;
        editUser(data).then(res => {
          if (res.data.success) {
            this.model.modelShow = false;
            this.$refs["modelForm"].resetFields();
            this.$Message.success(res.data.msg);
            this.menuAuthTree = this.menuAuthTreeClear;
            this.getlist();
          } else {
            this.$Message.error(res.data.msg);
          }
        });
      }
    }
  },
  activated() {},
  components: {
    // serachOrgCompany,
    // serachOrgPeople,
    // editOrgCompany,
    // editOrgPeople
  },
  computed: {
    seracHroleList: function() {
      var list = [{ name: "所有权限", id: "all" }];
      list = list.concat(this.roleList);
      return list;
    }
  },
  watch: {}
};
</script>
<style lang="less" scoped>
.mt10 {
  margin-top: 10px;
}
.serach_bar {
  display: flex;
  justify-content: space-between;

  .serach_bar_left {
    display: flex;
    align-items: center;
    button {
      margin-right: 10px;
    }
    .serachDiv {
      border: 1px solid #dcdee2;
      width: 150px;
      background-color: #fff;
      height: 32px;
      line-height: 32px;
      margin-right: 10px;
      padding: 0px 7px;
      border-radius: 4px;
      color: #c5c8ce;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .serachDivSelect {
      color: #515a6e;
    }
  }
  .serach_bar_right {
    button {
      margin-right: 10px;
    }
  }
  .select {
    margin-right: 10px;
    width: 150px;
  }
  .input {
    width: 150px;
    margin-right: 10px;
  }
}
.table {
  margin-top: 20px;
}

.table_page {
  margin-top: 20px;
}
.tree {
  max-height: 300px;
  overflow: auto;
}
</style>




