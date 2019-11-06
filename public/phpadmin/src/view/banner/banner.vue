<template>
  <div class="role myBody minwidth">
    <div class="serach_bar">
      <div class="serach_bar_right">
        <Button type="primary" icon="ios-add-circle-outline" @click="Account('添加轮播')">添加</Button>
        <Button
          :disabled="tableSelect.length==0"
          icon="ios-remove-circle-outline"
          @click="del_table"
        >删除</Button>
      </div>
      <div class="serach_bar_left">
        <Input class="input" v-model="serach.searchWord" placeholder="轮播位置" clearable />
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
        <el-table-column align="center" :show-overflow-tooltip="true" prop="name" label="轮播位置"></el-table-column>
        <el-table-column align="center" :show-overflow-tooltip="true" prop="id" label="轮播类型"></el-table-column>
        <el-table-column align="center" :show-overflow-tooltip="true" prop="id" label="轮播格式">
          <template slot-scope="scope">{{scope.row.imgs.split(",").length+'个'}}</template>
        </el-table-column>
        <el-table-column
          align="center"
          :show-overflow-tooltip="true"
          prop="lastLoginTime"
          label="更新时间"
        >
          <template
            slot-scope="scope"
          >{{scope.row.updateTime==null?'':formatDate(scope.row.updateTime*1000)}}</template>
        </el-table-column>
        <el-table-column align="center" label="操作">
          <template slot-scope="scope">
            <span @click="bannerEdit(scope.row)" class="cpl margin-left-sm">编辑</span>
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
    <Modal v-model="model.modelShow" :title="model.modelTitle" @on-visible-change="modalStatus">
      <Form ref="modelForm" :model="model.form" :label-width="100" :rules="model.rules">
        <FormItem label="轮播图" prop="imgs">
          <div class="demo-upload-list" v-for="(item,index) in uploadList" :key="index">
            <template v-if="item.status === 'finished'">
               
              <img preview="1" :src="item.url" />
              
              <div class="demo-upload-list-cover">
                <Icon type="ios-trash-outline" @click.native="handleRemove(item)"></Icon>
              </div>
             
            </template>
            <template v-else>
              <Progress v-if="item.showProgress" :percent="item.percentage" hide-info></Progress>
            </template>
          </div>
          <Upload
            ref="upload"
            :show-upload-list="false"
            :default-file-list="defaultList"
            :on-success="handleSuccess"
            :format="['jpg','jpeg','png']"
            :max-size="2048"
            :on-format-error="handleFormatError"
            :on-exceeded-size="handleMaxSize"
            :before-upload="handleBeforeUpload"
            multiple
            type="drag"
            :action="API+'/admin/file/upload'"
            style="display: inline-block;width:58px;"
          >
            <div style="width: 58px;height:58px;line-height: 58px;">
              <Icon type="ios-camera" size="20"></Icon>
            </div>
          </Upload>
        </FormItem>
        <FormItem label="轮播图位置" prop="name">
          <Input v-model="model.form.name" clearable placeholder="请输入轮播图位置"></Input>
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
import { bannerList, showBanner, editBanner, addBanner } from "_api/banner";
export default {
  name: "banner",
  data() {
    return {
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
        searchWord: ""
      },
      model: {
        id: "",
        modelShow: false,
        modelTitle: "",
        form: {
          imgs: "",
          name: ""
        },
        rules: {
          imgs: [
            { required: true, message: "轮播图不能为空", trigger: "blur" }
          ],
          name: [
            { required: true, message: "轮播图位置不能为空", trigger: "blur" }
          ]
        }
      },
      defaultList: [],
      imgName: "",
      visible: false,
      uploadList: []
    };
  },
  created() {},
  mounted() {
    this.uploadList = this.$refs.upload.fileList;
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
    getlist() {
      //获取列表信息
      bannerList({ searchWord: this.serach.searchWord })
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
    bannerShow(id) {
      this.model.id = id;
      this.model.modelTitle = "编辑轮播图";
      this.$Message.destroy();
      showBanner({ id: id }).then(res => {
        if (res.data.success == false) {
          this.$Message.error(res.data.msg);
        } else {
          this.model.form.imgs = res.data.data.imgs;
          this.model.form.name = res.data.data.name;
          let imgs = [];
          res.data.data.imgs.split(",").map(res => {
            imgs.push({ url: this.API + res, name: res });
          });
          this.defaultList = imgs;
          this.$nextTick(() => {
            this.uploadList = this.$refs.upload.fileList;
          });
        }
      });
    },
    bannerEdit(data, index) {
      //更新编辑
      this.model.id = data.id;
      this.$refs["modelForm"].resetFields();
      this.model.modelShow = true;
      this.model.modelTitle = "编辑账号";
      this.$refs.upload.clearFiles();
      this.bannerShow(data.id);
    },
    Account(e) {
      //添加账号
      this.model.form.name = "";
      this.defaultList = [];
      this.model.modelTitle = "添加轮播";
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
      let imgs = [];
      this.uploadList.map(res => {
        imgs.push(res.name);
      });
      data.imgs = imgs.toString();
      if (this.model.modelTitle == "添加轮播") {
        addBanner(data).then(res => {
          if (res.data.success) {
            this.model.modelShow = false;
            this.$refs["modelForm"].resetFields();
            this.$Message.success(res.data.msg);
            this.getlist();
          } else {
            this.$Message.error(res.data.msg);
          }
        });
      } else {
        data.id = this.model.id;
        editBanner(data).then(res => {
          if (res.data.success) {
            this.model.modelShow = false;
            this.$refs["modelForm"].resetFields();
            this.$Message.success(res.data.msg);
            this.getlist();
          } else {
            this.$Message.error(res.data.msg);
          }
        });
      }
    },
    handleView(name) {
      this.imgName = name;
      this.visible = true;
    },
    handleRemove(file) {
      const fileList = this.$refs.upload.fileList;
      this.$refs.upload.fileList.splice(fileList.indexOf(file), 1);
    },
    handleSuccess(res, file) {
      file.url = this.API + res.data.url;
      file.name = res.data.url;
    },
    handleFormatError(file) {
      this.$Notice.warning({
        title: "The file format is incorrect",
        desc:
          "File format of " +
          file.name +
          " is incorrect, please select jpg or png."
      });
    },
    handleMaxSize(file) {
      this.$Notice.warning({
        title: "Exceeding file size limit",
        desc: "File  " + file.name + " is too large, no more than 2M."
      });
    },
    handleBeforeUpload() {
      const check = this.uploadList.length < 5;
      if (!check) {
        this.$Notice.warning({
          title: "Up to five pictures can be uploaded."
        });
      }
      return check;
    },
    modalStatus(e) {
      this.$nextTick(() => {
        this.uploadList = this.$refs.upload.fileList;
      });
    }
  }
};

let arr = [1, 2, 3, 4, 5, 6];
// 假设要交换第2个和第4个元素
let x = 1,
  y = 2;
arr.splice(x - 1, 1, ...arr.splice(y - 1, 1, arr[x - 1]));
console.log(arr);
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
.demo-upload-list {
  display: inline-block;
  width: 60px;
  height: 60px;
  text-align: center;
  line-height: 60px;
  border: 1px solid transparent;
  border-radius: 4px;
  //   overflow: hidden;
  background: #fff;
  position: relative;
  box-shadow: 0 1px 1px rgba(0, 0, 0, 0.2);
  margin-right: 20px;
}
.demo-upload-list img {
  width: 100%;
  height: 100%;
}
.demo-upload-list-cover {
  display: block;
  position: absolute;
  top: -6px;
  right: -8px;
  height: auto;
  background: red;
  line-height: 1;
  z-index: 8;
}
.demo-upload-list:hover .demo-upload-list-cover {
  display: block;
}
.demo-upload-list-cover i {
  color: #fff;
  font-size: 20px;
  cursor: pointer;
  margin: 0 2px;
}
</style>




