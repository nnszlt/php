<template>
  <div>
    <Card>
      <p slot="title">产品详情</p>
      <Form class="form" ref="form" :model="form.formDate" :rules="form.formRule" :label-width="80">
        <FormItem label="产品大类" prop="type">
          <Select v-model="form.formDate.type" clearable style="width:200px">
            <Option v-for="item in tree" :value="item.id" :key="item.id">{{ item.label }}</Option>
          </Select>
        </FormItem>
        <FormItem label="产品名称" prop="name">
          <Input v-model="form.formDate.name" placeholder="请输入产品名称"></Input>
        </FormItem>
        <FormItem label="产品名称" prop="price">
          <Input v-model="form.formDate.price" placeholder="请输入产品名称"></Input>
        </FormItem>
      </Form>
    </Card>
    <Card class="margin-top-sm">
      <p slot="title">产品详情介绍</p>
      <div class="editor">
        <editor ref="editor" :value="form.formDate.content" @on-change="handleChange" />
        <Button @click="changeContent">修改编辑器内容</Button>
      </div>
    </Card>
  </div>
</template>
<script>
import { selectTree } from "_api/goods";
import Editor from "_c/editor";
export default {
  name: "goodList",
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
          enable: "", //是否可用 0不可 1可以
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
              message: "The name cannot be empty",
              trigger: "blur"
            }
          ]
        }
      },
      tree: []
    };
  },
  methods: {
    handleChange(html, text) {
      console.log(html, text);
    },
    changeContent() {
      this.$refs.editor.setHtml("<p>powered by wangeditor</p>");
    },
    selectTree() {
      selectTree().then(res => {
        if (res.data.success) {
          this.tree = res.data.data;
        } else {
          this.$Message.error(res.data.msg);
        }
      });
    }
  },
  mounted() {
    this.selectTree();
  }
};
</script>
<style lang="less" scoped>
</style>