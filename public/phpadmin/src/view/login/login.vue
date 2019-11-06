<style lang="less">
@import "./login.less";
</style>

<template>
  <div class="login">
    <div class="login-con">
      <Card icon="log-in" title="欢迎登录" :bordered="false">
        <div class="form-con">
          <login-form @on-success-valid="handleSubmit"></login-form>
          <p class="login-tip">输入任意用户名和密码即可</p>
        </div>
      </Card>
    </div>
  </div>
</template>

<script>
import LoginForm from "_c/login-form";
import { mapActions, mapMutations } from "vuex";
export default {
  components: {
    LoginForm
  },
  methods: {
    ...mapActions(["handleLogin"]),
    ...mapMutations(["setUserInfo"]),
    handleSubmit({ account, password }) {
      console.log(9999,account, password)
      this.handleLogin({ account, password }).then(res => {
        console.log(res);
        if (res.success) {
          this.setUserInfo(res.data);
          this.$Message.success(res.msg);
          this.$router.push({
            name: this.$config.homeName
          });
        } else {
          this.$Message.error(res.msg);
        }
      });
    }
  }
};
</script>

<style>
</style>
