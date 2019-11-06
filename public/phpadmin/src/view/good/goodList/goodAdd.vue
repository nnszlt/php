<template>
  <div>
    <Card>
      <p slot="title">产品详情</p>
      <Form class="form" ref="form" :model="form.formDate" :rules="form.formRule" :label-width="80">
        <FormItem label="产品大类" prop="type">
          <Select v-model="form.formDate.type" filterable clearable>
            <Option v-for="item in tree" :value="item.id" :key="item.id">{{ item.label }}</Option>
          </Select>
        </FormItem>
        <FormItem label="产品型号" prop="no">
          <Input v-model="form.formDate.no" placeholder="请输入产品型号"></Input>
        </FormItem>
        <FormItem label="产品名称" prop="name">
          <Input v-model="form.formDate.name" placeholder="请输入产品名称"></Input>
        </FormItem>
        <FormItem label="销售价格" prop="price">
          <Input v-model="form.formDate.price" placeholder="请输入销售价格"></Input>
        </FormItem>
        <FormItem label="市场价格" prop="mprice">
          <Input v-model="form.formDate.mprice" placeholder="请输入市场价格"></Input>
        </FormItem>
        <FormItem label="产品品牌" prop="brand">
          <Input v-model="form.formDate.brand" placeholder="请输入产品品牌"></Input>
        </FormItem>
        <FormItem label="计价单位" prop="unit">
          <Input v-model="form.formDate.unit" placeholder="请输入计价单位"></Input>
        </FormItem>
        <FormItem label="库存" prop="number">
          <Input v-model="form.formDate.number" placeholder="请输入库存"></Input>
        </FormItem>
        <FormItem label="是否可用" prop="enable">
          <RadioGroup v-model="form.formDate.enable">
            <Radio :label="0">
              <span>可用</span>
            </Radio>
            <Radio :label="1">
              <span>不可用</span>
            </Radio>
          </RadioGroup>
        </FormItem>
        <FormItem label="产品标签" prop="label">
          <Select v-model="form.formDate.label" filterable multiple>
            <Option v-for="item in labelArr" :value="item.id" :key="item.id">{{ item.name }}</Option>
          </Select>
        </FormItem>
        <FormItem label="产品图片" prop="imgs">
          <div class="demo-upload-list" v-for="item in uploadList" :key="item.name">
            <template v-if="item.status === 'finished'">
              <img :src="item.url" />
              <div class="demo-upload-list-cover">
                <Icon type="ios-eye-outline" @click.native="handleView(item)"></Icon>
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
          <Modal title="View Image" v-model="visible">
            <img :src="imgName" v-if="visible" style="width: 100%" />
          </Modal>
        </FormItem>
        <FormItem label="产品概述" prop="desc">
          <Input type="textarea" v-model="form.formDate.desc" placeholder="请输入产品概述"></Input>
        </FormItem>
      </Form>
    </Card>
    <Card class="margin-top-sm">
      <p slot="title">产品详情介绍</p>
      <div class="editor">
        <editor
          ref="editor"
          :cache="false"
          v-model="form.formDate.content"
          @on-change="handleChange"
        />
      </div>
    </Card>
    <div class="buttnGroup">
      <Button type="primary" @click="save()">保存</Button>
    </div>
  </div>
</template>
<script>
import { selectTree } from "_api/goodtype";
import { listtags } from "_api/tags";
import { addGoods, showGoods, editGoods } from "_api/goods";
import Editor from "_c/editor";
import { mapMutations } from "vuex";
export default {
  name: "addGood",
  components: {
    Editor
  },
  data() {
    return {
      form: {
        formDate: {
          name: "", //产品名称
          brand: "", //产品品牌
          price: "", //价格
          mprice: "", //市场价格
          unit: "", //计价单位
          number: "", //库存
          no: "", //产品型号
          enable: 0, //是否可用 0不可 1可以
          desc: "", //产品概述
          imgs: "", //产品图片
          type: "", //产品类型
          label: "", //产品标签
          content: ""
        },
        formRule: {
          name: [
            {
              required: true,
              message: "产品名称不能为空"
            }
          ],
          type: [
            {
              required: true,
              message: "产品大类不能为空",
              type: "number"
            }
          ],
          no: [
            {
              required: true,
              message: "产品型号不能为空"
            }
          ],
          price: [
            {
              required: true,
              message: "产品价格不能为空"
            }
          ],
          mprice: [
            {
              required: true,
              message: "市场价格不能为空"
            }
          ],
          brand: [
            {
              required: true,
              message: "产品品牌不能为空"
            }
          ],
          unit: [
            {
              required: true,
              message: "计价单位不能为空"
            }
          ],
          number: [
            {
              required: true,
              message: "库存不能为空"
            }
          ],
          enable: [
            {
              required: true,
              message: "请选择是否可用"
            }
          ],
          imgs: [
            {
              required: true,
              message: "产品图片最少为一个"
            }
          ]
        }
      },
      tree: [],
      defaultList: [],
      imgName: "",
      visible: false,
      uploadList: [],
      labelArr: []
    };
  },
  mounted() {
    this.uploadList = this.$refs.upload.fileList;
    this.selectTree();
    this.gettags();
    if (this.$route.params.id != "add") {
      this.getGood(this.$route.params.id);
    }
  },
  activated() {
    this.uploadList = this.$refs.upload.fileList;
    this.selectTree();
    this.gettags();
    if (this.$route.params.id != "add") {
      this.getGood(this.$route.params.id);
    }
  },
  methods: {
    ...mapMutations(["closeTag"]),
    getGood(id) {
      showGoods({ id: id }).then(res => {
        if (res.data.success) {
          this.form.formDate.brand = res.data.data.brand;
          this.form.formDate.no = res.data.data.no;
          this.form.formDate.number = res.data.data.number;
          this.form.formDate.name = res.data.data.name;
          this.form.formDate.desc = res.data.data.desc;
          this.form.formDate.unit = res.data.data.unit;
          this.form.formDate.price = res.data.data.price;
          this.form.formDate.mprice = res.data.data.mprice;
          this.form.formDate.type = Number(res.data.data.type);
          this.form.formDate.enable = res.data.data.enable.toString();
          let imgs = [];
          res.data.data.imgs.split(",").map(res => {
            imgs.push({ url: this.API + res, name: res });
          });
          this.defaultList = imgs;
          this.$nextTick(() => {
            this.uploadList = this.$refs.upload.fileList;
          });
          let label = [];
          if (res.data.data.label != "") {
            res.data.data.label.map(res => {
              label.push(Number(res.id));
            });
          }
          this.form.formDate.label = label;
          this.$refs.editor.setHtml(res.data.data.content);
        } else {
          this.$Message.error(res.data.msg);
        }
      });
    },
    gettags() {
      listtags({ enable: 0, pageSize: 100000000 }).then(res => {
        if (res.data.success) {
          this.labelArr = res.data.data.records;
        } else {
          this.$Message.error(res.data.msg);
        }
      });
    },
    handleChange(html, text) {
      console.log(html, text);
    },
    changeContent() {},
    selectTree() {
      selectTree().then(res => {
        if (res.data.success) {
          this.tree = res.data.data;
        } else {
          this.$Message.error(res.data.msg);
        }
      });
    },
    handleView(data) {
      this.imgName = data.url;
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

    save() {
      let that = this;
      let imgs = [];
      this.uploadList.map(res => {
        imgs.push(res.name);
      });
      this.form.formDate.imgs = imgs.toString();
      let data = JSON.parse(JSON.stringify(that.form.formDate));
      data.label = data.label.toString();

      this.$refs["form"].validate(valid => {
        if (valid) {
          this.$route.params.id == "add"
            ? addGoods
            : (data.id = this.$route.params.id);
          editGoods(data).then(res => {
            if (res.data.success) {
              this.close();
              this.$router.push({
                name: "goodList"
              });
              this.$Message.success(res.data.msg);
            } else {
              this.$Message.error(res.data.msg);
            }
          });
        } else {
        }
      });
    },
    close() {
      /**
       * 如果是调用closeTag方法，普通的页面传入的对象参数只需要写name字段即可
       * 如果是动态路由和带参路由，需要传入query或params字段，用来区别关闭的是参数为多少的页面
       */
      this.closeTag({
        name: "addGood",
        params: {
          id: this.$route.params.id
        }
      });
    }
  }
};
</script>
<style lang="less" scoped>
.demo-upload-list {
  display: inline-block;
  width: 60px;
  height: 60px;
  text-align: center;
  line-height: 60px;
  border: 1px solid transparent;
  border-radius: 4px;
  overflow: hidden;
  background: #fff;
  position: relative;
  box-shadow: 0 1px 1px rgba(0, 0, 0, 0.2);
  margin-right: 4px;
}
.demo-upload-list img {
  width: 100%;
  height: 100%;
}
.demo-upload-list-cover {
  display: none;
  position: absolute;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  background: rgba(0, 0, 0, 0.6);
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