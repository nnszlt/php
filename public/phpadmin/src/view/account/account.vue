<template>
  <div class="role myBody minwidth">
    <div class="serach_bar">
      <div class="serach_bar_right">
        <Button
          type="primary"
          icon="ios-add-circle-outline"
          @click="Account('添加账号')"
          v-show="$store.state.user.authList.includes('user.add')"
        >添加</Button>
        <Button
          v-show="$store.state.user.authList.includes('user.del')"
          :type="tableSelect.length>0?'primary':'dashed'"
          :disabled="tableSelect.length==0"
          icon="ios-remove-circle-outline"
          @click="del_table"
        >删除</Button>
        <Button
          :type="play?'primary':'dashed'"
          :disabled="!play"
          icon="ios-radio-button-off"
          @click="changeStatus('启用')"
          v-show="$store.state.user.authList.includes('user.edit')"
        >启用</Button>
        <Button
          :type="stop?'primary':'dashed'"
          :disabled="!stop"
          icon="md-power"
          v-show="$store.state.user.authList.includes('user.edit')"
          @click="changeStatus('停用')"
        >停用</Button>
      </div>
      <div class="serach_bar_left">
        <Select class="select juesleixing" v-model="serach.roleId" placeholder="请选择权限类型">
          <Option v-for="item in seracHroleList" :value="item.id" :key="item.id">{{ item.name }}</Option>
        </Select>
        <Input class="input" v-model="serach.username" placeholder="账户名称" clearable />
        <!-- <Input class="input" v-model="serach.tag" placeholder="标签" clearable/> -->
        <Input class="input" v-model="serach.groupName" placeholder="所属机构" clearable />
        <!-- <div
          @click="modal.modalShow2=true"
          :class="['serachDiv',serachOrgName=='请选择机构'? '':'serachDivSelect']"
        >
          <span>{{serachOrgName}}</span>
          <Icon
            v-show="serachOrgName!='请选择机构'"
            class="cp"
            @click.stop="clearSearchOrg"
            type="md-close-circle"
          />
        </div>-->
        <Input class="input" v-model="serach.relateEmployee" placeholder="负责人" clearable />
        <!-- <div
          @click="modal.modalShow3 = true"
          :class="['serachDiv',serachOrgrelateEmployee=='请选择负责人'? '':'serachDivSelect']"
        >{{serachOrgrelateEmployee}}</div>-->
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
        ></el-table-column>
        <el-table-column align="center" :show-overflow-tooltip="true" prop="username" label="账户名称"></el-table-column>
        <el-table-column align="center" :show-overflow-tooltip="true" prop="groups" label="所属机构"></el-table-column>
        <el-table-column
          align="center"
          :show-overflow-tooltip="true"
          prop="lastLoginTime"
          label="上次登录时间"
        ></el-table-column>
        <el-table-column align="center" :show-overflow-tooltip="true" prop="roleStr" label="权限类型"></el-table-column>
        <el-table-column
          align="center"
          :show-overflow-tooltip="true"
          prop="relateEmployeeName"
          label="负责人"
        ></el-table-column>
        <el-table-column align="center" :show-overflow-tooltip="true" prop="enable" label="状态"></el-table-column>
        <el-table-column
          align="center"
          :show-overflow-tooltip="true"
          prop="createTime"
          label="创建时间"
        ></el-table-column>
        <el-table-column align="center" label="操作">
          <template slot-scope="scope">
            <el-tooltip :enterable="false" content="编辑" placement="top">
              <Icon
                class="cp"
                size="25"
                width="80"
                v-show="$store.state.user.authList.includes('user.edit')"
                @click="AccountEdit(scope.row,scope.$index)"
                type="ios-create-outline"
              />
            </el-tooltip>
          </template>
        </el-table-column>
      </el-table>

      <!-- <Table
        highlight-row
        :max-height="tableHeight"
        border
        ref="selection"
        :columns="dataliststyle"
        :data="datalist"
        @on-selection-change="table_select"
        @on-select-cancel="tableCancel"
        @on-select-all="tableSelectAll"
        @on-select-all-cancel="tableSelectCancel"
      >
        <template slot-scope="{ row, index }" slot="action">
          <Tooltip content="编辑" placement="top">
            <Icon
              class="cp"
              size="25"
              v-show="$store.state.user.authList.includes('user.edit')"
              @click="AccountEdit(row,index)"
              type="ios-create-outline"
            />
          </Tooltip>
        </template>
      </Table>-->
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

    <Modal
      :mask-closable="false"
      :title="modal.model1Title"
      v-model="modal.modalShow1"
      class-name="vertical-center-modal"
      @on-cancel="modal1Cancel(modal.model1Title)"
    >
      <Form
        autocomplete="off"
        :model="modal.modalForm1"
        :rules="modal.rule"
        ref="modalForm1"
        :label-width="100"
      >
        <Input style="display: none;" placeholder="防止填充" />
        <input type="password" style="display:none" placeholder="防止自动填充" />
        <FormItem label="账户名称:" prop="username">
          <Input
            v-model="modal.modalForm1.username "
            :readonly="modal.model1Title=='编辑账号'"
            placeholder="请输入账户名称"
          />
        </FormItem>
        <FormItem label="访问权限:" prop="roleId">
          <Select
            class="select juesleixing"
            v-model="modal.modalForm1.roleId"
            placeholder="请选择权限类型"
          >
            <Option v-for="item in roleList" :value="item.id" :key="item.id">{{ item.name }}</Option>
          </Select>
        </FormItem>
        <FormItem label="所属机构:" prop="groupId">
          <div class="select_org" @click="modal.modalShow4=true">{{modal.editOrgCompanyName}}</div>
          <Input style="display: none;" v-model="modal.modalForm1.groupId" placeholder="请输入标签" />
        </FormItem>
        <FormItem label="负责人:" prop="relateEmployee">
          <div class="select_org" @click="modal.modalShow5=true">{{modal.editOrgrelateEmployee}}</div>
          <Input style="display: none;" v-model="modal.modalForm1.relateEmployee" />
          <Input style="display: none;" placeholder="防止填充" />
          <span
            v-show="modal.model1Title=='编辑账号'"
            style="    position: absolute;
    top: 0;
    right: 0;"
          >修改账号负责人后，请重新登录</span>
        </FormItem>

        <!-- <FormItem label="邮箱:" prop="email"> -->
        <!-- <Input
            v-model="modal.modalForm1.email "
            type="email"
            autocomplete="off"
            placeholder="请输入邮箱"
        />-->
        <!-- </FormItem> -->
        <FormItem label="登录密码:" prop="password">
          <input type="hidden" />
          <Input
            v-model="modal.modalForm1.password "
            type="password"
            autocomplete="off"
            placeholder="请输入登录密码"
          />
        </FormItem>
        <FormItem label="确认密码:" prop="repassword">
          <input type="hidden" />
          <Input
            v-model="modal.modalForm1.repassword"
            type="password"
            onfocus="this.removeAttribute('readonly')"
            autocomplete="off"
            placeholder="请再次输入登录密码"
          />
        </FormItem>
        <FormItem label="账号状态:" prop="enable">
          <RadioGroup v-model="modal.modalForm1.enable">
            <Radio :label="1">启用</Radio>
            <Radio :label="0">停用</Radio>
          </RadioGroup>
        </FormItem>
      </Form>
      <div slot="footer">
        <Button type="text" size="large" @click="modal1Cancel(modal.model1Title)">取消</Button>
        <Button type="primary" size="large" @click="modal1Ok(modal.model1Title)">确定</Button>
      </div>
    </Modal>
    <!--START 搜索 -->
    <Modal
      title="选择机构"
      :mask-closable="false"
      v-model="modal.modalShow2"
      @on-visible-change="serachreload"
    >
      <!-- 搜索机构组件 -->
      <!-- <serachOrgCompany
        :dataFromParent="dataFromParent"
        @serachOrgCompanyzreeSelect="serachOrgCompanySelect"
        type="radio"
        :treeRefresh="serachSx"
        treeId="serachOrgCompany"
        userinfo="[]"
      ></serachOrgCompany>-->
      <div slot="footer">
        <!-- <Button type="text" size="large" @click="modal2Cancel">取消</Button>
        <Button type="primary" size="large" @click="modal2Ok">确定</Button>-->
      </div>
    </Modal>

    <Modal
      title="选择负责人"
      :mask-closable="false"
      v-model="modal.modalShow3"
      class-name="vertical-center-modal"
      :width="600"
    >
      <!-- 搜索负责人组件 -->
      <!-- <serachOrgPeople
        :dataFromParent="dataFromParent"
        @serachOrgPeoplepeopleSelect="serachOrgPeopleSelect"
        treeId="serachOrgPeople"
        userinfo="[]"
        type="radio"
      ></serachOrgPeople>-->
      <div slot="footer"></div>
    </Modal>
    <!--END 搜索 -->
    <!--START 添加编辑 -->
    <Modal
      title="选择机构"
      :mask-closable="false"
      v-model="modal.modalShow4"
      @on-visible-change="shuaxintree"
    >
      <!-- 添加编辑机构组件 -->
      <editOrgCompany
        treeId="editOrgCompany"
        :dataFromParent="dataFromParent"
        @editOrgCompanyzreeSelect="editOrgCompanySelect"
        type="radio"
        :userinfo="modal.editOrgCompanyUserinfo"
        :treeRefresh="loadTree"
      ></editOrgCompany>
      <div slot="footer">
        <!-- <Button type="text" size="large" @click="modal4Cancel">取消</Button>
        <Button type="primary" size="large" @click="modal4Ok">确定</Button>-->
      </div>
    </Modal>

    <Modal
      title="选择负责人"
      :mask-closable="false"
      v-model="modal.modalShow5"
      class-name="vertical-center-modal"
      :width="600"
      @on-visible-change="shuaxintree"
    >
      <!-- 添加编辑负责人组件 -->
      <editOrgPeople
        treeId="editOrgPeople"
        :dataFromParent="dataFromParent"
        @editOrgPeoplepeopleSelect="editOrgPeopleSelect"
        :userinfo="modal.editOrgPeopleUserinfo"
        :treeRefresh="loadTree"
        type="radio"
      ></editOrgPeople>
      <div slot="footer"></div>
    </Modal>
    <!--END 添加编辑 -->
  </div>
</template>
<script>
import { mytime } from "@/libs/tools";
import { org } from "_api/org";
import { allManager } from "_api/system/account";
// import serachOrgCompany from "_c/org/org_compny.vue";
// import serachOrgPeople from "_c/org/org_people.vue";
import editOrgCompany from "_c/org/org_compny.vue";
import editOrgPeople from "_c/org/org_people.vue";
import { constants } from "crypto";
export default {
  name: "account",
  data() {
    return {
      dataFromParent: "",
      page: {
        //分页
        total: 20,
        pageSize: 20,
        pageNo: 1,
        pageGroup: [20, 30, 40, 50]
      },
      modal: {
        //搜索组织
        modal2id: "", // 统一id还原组件绑定
        modal2Name: "", //机构组件选择的暂存名字
        //搜索负责人
        modal3Id: "", //负责人组件选择的暂存ID
        modal2Name: "", //负责人组件选择的暂存名字
        //弹框
        modelTitle1: "",
        modalShow1: false,
        modalForm1: {
          groupId: "",
          password: "",
          repassword: "",
          relateEmployee: "",
          roleId: "",
          enable: "",
          username: "",
          email: ""
        },
        //编辑组织 暂存
        //editOrgCompany
        editOrgCompanyUserinfo: "", //编辑组织的userinfo
        editOrgCompanyName: "请选择机构",
        //编辑负责人
        modalShow2: false,
        modalForm2: {
          groupId: ""
        },
        modalShow4: false,
        modalShow5: false,
        editOrgPeopleUserinfo: "", //编辑负责人的userinfo
        editOrgrelateEmployeeIdZc: "",
        editOrgrelateEmployeedZc: "",
        editOrgrelateEmployee: "请选择负责人",
        modalShow3: false,
        rule: {
          username: [
            {
              required: true,
              message: "请输入账户名称",
              trigger: "blur"
            }
          ],
          password: [
            {
              required: true,
              message: "请输入登录密码"
            }
          ],
          repassword: [
            {
              required: true,
              message: "两次输入的密码不一致",
              validator: this.password
            }
          ],
          relateEmployee: [
            {
              required: true,
              message: "请输入负责人"
            }
          ],
          roleId: [
            {
              required: true,
              message: "请选择页面权限访问"
            }
          ],
          enable: [
            {
              required: true,
              message: "请选择页面权限访问"
            }
          ],
          groupId: [
            {
              required: true,
              message: "请选择所属机构"
            }
          ],
          email: [
            {
              required: true,
              message: "请填写邮箱"
            }
          ]
        }
      },
      serach: {
        //搜索内容
        groupId: "",
        relateEmployee: "",
        roleId: "all",
        tag: "",
        username: "",
        groupName: ""
      },
      serachSx: false,
      serachOrgNameId: "",
      serachOrgName: "请选择机构",
      serachOrgrelateEmployee: "请选择负责人",
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
          title: "账户名称",
          key: "username",
          ellipsis: true,
          tooltip: true,
          align: "center"
        },
        {
          title: "所属机构",
          key: "groups",
          ellipsis: true,
          tooltip: true,
          align: "center"
        },
        // {
        //   title: "邮箱",
        //   key: "email",
        //   ellipsis: true,
        //   tooltip: true,
        //   align: "center"
        // },
        {
          title: "上次登录时间",
          key: "lastLoginTime",
          ellipsis: true,
          tooltip: true,
          align: "center"
        },
        {
          title: "权限类型",
          key: "roleStr",
          ellipsis: true,
          tooltip: true,
          align: "center"
        },

        {
          title: "负责人",
          key: "relateEmployeeName",
          ellipsis: true,
          tooltip: true,
          align: "center"
        },
        {
          title: "状态",
          key: "enable",
          ellipsis: true,
          tooltip: true,
          width: 61,
          align: "center"
        },
        {
          title: "创建时间",
          key: "createTime",
          ellipsis: true,
          tooltip: true,
          align: "center"
        },
        {
          title: "操作",
          slot: "action",
          align: "center",
          width: 80
        }
      ],
      roleList: [],
      loadTree: false,
      play: false,
      stop: false
    };
  },
  created() {},
  mounted() {
    this.getTreeDate();
    this.getRoleList();
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
          allManager.deletManager({ userId: idArr.toString() }).then(res => {
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
    getRoleList() {
      allManager.roleList().then(res => {
        this.roleList = res.data.data;
      });
    },
    getTreeDate() {
       org.getGroupTree().then(res => {
    if(res.data.success){
      res.data.data.map(res => {
        res.isParent = res.hasSub
        if (res.groups.length != 0) {
          res.groups.map(ress => {
  
            ress.isParent = ress.hasSub
          })
        }
      })
     this.dataFromParent=res.data.data
    }


  })
    },
    getlist() {
      //获取列表信息
      var data = JSON.stringify(this.serach);
      data = JSON.parse(data);
      if (data.roleId == "all") {
        data.roleId = "";
        this.serach.roleId = "all";
      }
      data.pageNo = this.page.pageNo;
      data.pageSize = this.page.pageSize;
     data.type=0;
      allManager
        .pageManager(data)
        .then(res => {
          $(".el-table__body-wrapper").scrollTop(0);
          this.tableSelect = [];
          res.data.data.records.map((v, i) => {
            v.index = (this.page.pageNo - 1) * this.page.pageSize + 1 + i;
            v.enable = v.enable == 0 ? "停用" : "启用";
            v.createTime = mytime(v.createTime, "year");
            v.lastLoginTime =
              v.lastLoginTime == null ? "" : mytime(v.lastLoginTime, "year");
          });
          this.page.total = res.data.data.total;
          this.datalist = res.data.data.records;
        })
        .catch(err => {
          console.log(err);
        });
    },
    showAccount(id) {
      this.$Message.destroy();
      allManager.showManager({ userId: id }).then(res => {
        if (res.data.success == false) {
          this.$Message.error(res.data.msg);
        } else {
          this.modal.modalForm1.repassword = "✪";
          this.modal.modalForm1.password = "✪";
          this.modal.modalForm1.username = res.data.data.username;
          this.modal.modalForm1.userId = res.data.data.id;
          this.modal.modalForm1.enable = res.data.data.enable;
          this.modal.modalForm1.email = res.data.data.email;
          // this.modal.modalForm1.password=
          // this.modal.modalForm1.roleId = res.data.data.role;
          this.modal.modalForm1.roleId = res.data.data.role.id;
          //组织
          // this.modal.editOrgCompanyName = res.data.data.groupsStr;
          this.modal.editOrgCompanyName = returnName(
            res.data.data.group.familyPathName,
            res.data.data.group.name
          );
          this.modal.editOrgCompanyUserinfo = res.data.data.group.id; //还原组织
          this.modal.modalForm1.groupId = res.data.data.group.id;
          //负责人
          this.modal.editOrgrelateEmployee = res.data.data.relateEmployeeName;
          this.modal.modalForm1.relateEmployee = res.data.data.relateEmployee;
          // this.modal.editOrgPeopleUserinfo = res.data.data.relateEmployee; //还原负责人
          //暂存
          this.modal.editOrgCompanyNamedZc = res.data.data.group.name;
          this.modal.editOrgCompanyIdZc = res.data.data.group.id;

          this.modal.modalShow1 = true;
        }
      });
      function returnName(full, name) {
        if (full == null || full == "") {
          return name;
        } else {
          var ffn = full.replace("中信银行/", "").replace("中信银行", "");
          if (ffn.substr(0, 1) == "/" || ffn == "") {
            return name;
          } else {
            return ffn + "/" + name;
          }
        }
      }
    },
    AccountEdit(data, index) {
      //更新编辑
      this.$refs["modalForm1"].resetFields();
      this.reatModalForm1();
      this.modal.model1Title = "编辑账号";
      this.showAccount(data.id);
    },
    Account(e) {
      //添加账号
      this.$refs["modalForm1"].resetFields();
      this.modal.editOrgCompanyNamedZc = "";
      this.modal.editOrgCompanyIdZc = "";
      this.modal.model1Title = e;
      this.modal.modalShow1 = true;
    },
    changeStatus(e) {
      //改变账号状态
      var list = [];
      this.tableSelect.map(v => {
        list.push(v.id);
      });
      if (e == "启用") {
        allManager
          .changeStatusManager({ operateType: 1, userId: list.toString() })
          .then(res => {
            if (res.data.success) {
              this.$Message.success(res.data.msg);
              this.getlist();
            } else {
              this.$Message.error(res.data.msg);
            }
          });
      } else {
        allManager
          .changeStatusManager({ operateType: 0, userId: list.toString() })
          .then(res => {
            if (res.data.success) {
              this.$Message.success(res.data.msg);
              this.getlist();
            } else {
              this.$Message.error(res.data.msg);
            }
          });
      }
    },
    modal1Ok(type) {
      this.$refs["modalForm1"].validate(valid => {
        if (valid) {
          this.$Message.destroy();
          if (type == "添加账号") {
            delete this.modal.modalForm1.id;
            allManager.addManager(this.modal.modalForm1).then(res => {
              if (res.data.success) {
                this.$Message.success(res.data.msg);
                this.getlist();
                this.modal1Cancel();
              } else {
                this.$Message.error(res.data.msg);
              }
            });
          } else {
            var that = this;
            var data = JSON.parse(JSON.stringify(that.modal.modalForm1));
            if (data.password == "✪") {
              data.password = "";
              data.repassword = "";
            }
            allManager.updateManager(data).then(res => {
              if (res.data.success) {
                this.$Message.success(res.data.msg);
                this.getlist();
                this.modal1Cancel();
              } else {
                this.$Message.error(res.data.msg);
              }
            });
          }
        } else {
          return false;
        }
      });
    },
    modal1Cancel() {
      this.modal.modalShow1 = false;
      this.$refs["modalForm1"].resetFields();
      this.reatModalForm1();
    },
    modal2Ok() {
      //搜索组织确定
      // this.serachOrgName = this.modal2Name;
      // this.serach.groupId = this.modal2id;
      // this.modal.modalShow2 = false;
    },
    modal2Cancel() {
      this.modal.modalShow2 = false;
    },
    modal4Ok() {
      //编辑组织确定
      // if (this.modal.editOrgCompanyIdZc == "") {
      //   this.$Message.warning("请选择部门");
      //   return;
      // }
      // this.$refs["modalForm1"].validateField("groupId", error => {
      //   if (!error) {
      //   } else {
      //     return false;
      //   }
      // });
      // this.modal.editOrgCompanyName = this.modal.editOrgCompanyNamedZc;
      // this.modal.modalForm1.groupId = this.modal.editOrgCompanyIdZc;
      // this.modal.modalShow4 = false;
    },
    modal4Cancel() {
      this.modal.modalShow4 = false;
      this.shuaxintree();
    },
    reatModalForm1() {
      this.modal.modalForm1 = {
        groupId: "",
        password: "",
        repassword: "",
        relateEmployee: "",
        roleId: "",
        enable: "",
        username: "",
        email: ""
      };
      this.modal.editOrgrelateEmployee = "请选择负责人";
      this.modal.editOrgCompanyName = "请选择机构";
      this.shuaxintree();
    },
    serachOrgCompanySelect(e) {
      //搜索组机构件回调
      if (e.length == 0) {
        this.modal2id = "";
        this.modal2Name = "请选择机构";
        return;
      }
      var id = [];
      var name = [];
      e.map(v => {
        id.push(v.id);
        name.push(v.small);
      });
      this.modal2id = id.toString();
      this.modal2Name = name.toString();

      this.serachOrgName = this.modal2Name;
      this.serach.groupId = this.modal2id;
      this.modal.modalShow2 = false;
    },
    serachOrgPeopleSelect(r) {
      //搜索负责人组件回调
      this.serach.relateEmployee = r.id;
      this.serachOrgrelateEmployee = r.name;
      this.modal.modalShow3 = false;
    },
    shuaxintree() {
      //负责人刷新
      var that = this;
      this.loadTree = true;
      setTimeout(() => {
        that.loadTree = false;
      }, 10);
    },
    editOrgCompanySelect(r) {
      //编辑添加机构组件返回
      if (r.length != 0) {
        this.modal.editOrgCompanyNamedZc = r[0].name;
        this.modal.editOrgCompanyIdZc = r[0].id;
      } else {
        this.modal.editOrgCompanyNamedZc = "请选择机构";
        this.modal.editOrgCompanyIdZc = "";
      }
      if (this.modal.editOrgCompanyIdZc == "") {
        this.$Message.warning("请选择部门");
        return;
      }
      this.$refs["modalForm1"].validateField("groupId", error => {
        if (!error) {
        } else {
          return false;
        }
      });
      this.modal.editOrgCompanyName = this.modal.editOrgCompanyNamedZc;
      this.modal.modalForm1.groupId = this.modal.editOrgCompanyIdZc;
      this.modal.modalShow4 = false;
    },
    editOrgPeopleSelect(e) {
      //编辑添加负责人组件返回
      this.$refs["modalForm1"].validateField("relateEmployee", error => {
        if (!error) {
        } else {
          return false;
        }
      });
      this.modal.editOrgrelateEmployee = e.name;
      this.modal.modalForm1.relateEmployee = e.id;
      this.modal.modalShow5 = false;
    },
    password(rule, value, callback) {
      //新加表单验证
      if (this.modal.modalForm1.password != value) {
        callback(new Error("两次密码不同"));
      } else {
        callback();
      }
    },
    clearSearchOrg() {
      //清楚搜索的状态
      this.serachOrgName = "请选择机构";
      this.serach.groupId = "";
    },
    serachreload() {
      var that = this;
      this.serachSx = true;
      setTimeout(() => {
        that.serachSx = false;
      }, 10);
    }
  },
  activated() {},
  components: {
    // serachOrgCompany,
    // serachOrgPeople,
    editOrgCompany,
    editOrgPeople
  },
  computed: {
    seracHroleList: function() {
      var list = [{ name: "所有权限", id: "all" }];
      list = list.concat(this.roleList);
      return list;
    },
  },
  watch: {
    tableSelect: {
      handler(selection) {
        if (selection.length == 0) {
          this.play = false;
          this.stop = false;
          return;
        }
        var one = selection[0].enable;
        console.log(one);
        if (selection.length == 1) {
          if (one == "启用") {
            this.stop = true;
            this.play = false;
          } else {
            this.play = true;
            this.stop = false;
          }
        } else {
          this.play = false;
          this.stop = false;
          var enable = selection.some(res => {
            if (res.enable != one) {
              return true;
            }
          });
          if (enable) {
            this.play = false;
            this.stop = false;
          } else {
            if (one == "启用") {
              this.stop = true;
              this.play = false;
            } else {
              this.play = true;
              this.stop = false;
            }
          }
        }
      }
    }
  }
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
/deep/.ivu-tree-children .ivu-tree-children > li {
}
/deep/.ivu-tree-children .ivu-tree-children li ul {
}
</style>
