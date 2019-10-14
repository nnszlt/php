<template>
  <Card shadow>
    <div>
      <div class="message-page-con message-category-con">
        <Menu width="auto" active-name="unread" @on-select="handleSelect">
          <MenuItem name="unread">
            <span class="category-title">未读消息</span>
            <Badge style="margin-left: 10px" :count="messageList.unread.length"></Badge>
          </MenuItem>
          <MenuItem name="read">
            <span class="category-title">已读消息</span>
            <Badge
              style="margin-left: 10px"
              class-name="gray-dadge"
              :count="messageList.read.length"
            ></Badge>
          </MenuItem>
          <!-- <MenuItem name="trash">
            <span class="category-title">回收站</span>
            <Badge
              style="margin-left: 10px"
              class-name="gray-dadge"
              :count="messageList.trash.length"
            ></Badge>
          </MenuItem>-->
        </Menu>
      </div>
      <div class="message-page-con message-list-con">
        <Spin fix v-if="listLoading" size="large"></Spin>
        <Menu width="auto" active-name @on-select="handleView">
          <MenuItem
            v-for="(item,key) in messageList[currentMessageType]"
            :name="key"
            :key="`msg_${item.id}`"
          >
            <div>
              <p class="msg-title">{{ item.title }}</p>
              <Badge status="default" :text="item.createtime" />
              <Button
                style="float: right;margin-right: 20px;"
                :style="{ display: item.loading ? 'inline-block !important' : '' }"
                :loading="item.loading"
                size="small"
                :icon="currentMessageType === 'read' ? 'md-trash' : 'md-redo'"
                :title="currentMessageType === 'read' ? '删除' : '还原'"
                type="text"
                v-show="currentMessageType !== 'unread'"
                @click.native.stop="removeMsg(item)"
              ></Button>
            </div>
          </MenuItem>
        </Menu>
      </div>
      <div class="message-page-con message-view-con">
        <Spin fix v-if="contentLoading" size="large"></Spin>
        <div class="message-view-header">
          <h2 class="message-view-title">{{ showingMsgItem.title }}</h2>
          <time class="message-view-time">{{ showingMsgItem.create_time }}</time>
        </div>
        <div v-html="showingMsgItem.content"></div>
      </div>
    </div>
  </Card>
</template>

<script>
import { mapState, mapGetters, mapMutations, mapActions } from "vuex";
import { getMessage, readMsg, removeMsg } from "_api/user";
export default {
  name: "message_page",
  data() {
    return {
      listLoading: true,
      contentLoading: false,
      currentMessageType: "unread",
      messageContent: "",
      showingMsgItem: {},
      messageList: {
        read: [],
        trash: [],
        unread: []
      }
    };
  },
  computed: {},
  methods: {
    stopLoading(name) {},
    handleSelect(name) {
      this.currentMessageType = name;
      this.showingMsgItem = {
        title: "",
        content: "",
        create_time: ""
      };
    },
    handleView(e) {
      this.showingMsgItem = this.messageList[this.currentMessageType][e];
      console.log(this.currentMessageType)
      if (this.currentMessageType == "unread")
        readMsg({ id: this.showingMsgItem.id }).then(res => {
          if (res.data.success) {
            this.getMessageList();
          } else {
            this.$Message.error(res.data.msg);
          }
        });
    },
    removeMsg(item) {
      removeMsg({ id: item.id }).then(res => {
        if (res.data.success) {
          this.showingMsgItem = {
            title: "",
            content: "",
            create_time: ""
          };
          this.getMessageList();
          this.$Message.success(res.data.msg);
        } else {
          this.$Message.error(res.data.msg);
        }
      });
    },
    getMessageList() {
      getMessage()
        .then(res => {
          this.messageList = res.data.data;
          this.listLoading = false;
        })
        .catch(() => this.stopLoading("listLoading"));
    }
  },
  mounted() {
    this.listLoading = true;
    // 请求获取消息列表
    this.getMessageList();
  }
};
</script>

<style lang="less">
.message-page {
  &-con {
    height: ~"calc(100vh - 176px)";
    display: inline-block;
    vertical-align: top;
    position: relative;
    &.message-category-con {
      border-right: 1px solid #e6e6e6;
      width: 200px;
    }
    &.message-list-con {
      border-right: 1px solid #e6e6e6;
      width: 230px;
    }
    &.message-view-con {
      position: absolute;
      left: 446px;
      top: 16px;
      right: 16px;
      bottom: 16px;
      overflow: auto;
      padding: 12px 20px 0;
      .message-view-header {
        margin-bottom: 20px;
        .message-view-title {
          display: inline-block;
        }
        .message-view-time {
          margin-left: 20px;
        }
      }
    }
    .category-title {
      display: inline-block;
      width: 65px;
    }
    .gray-dadge {
      background: gainsboro;
    }
    .not-unread-list {
      .msg-title {
        color: rgb(170, 169, 169);
      }
      .ivu-menu-item {
        .ivu-btn.ivu-btn-text.ivu-btn-small.ivu-btn-icon-only {
          display: none;
        }
        &:hover {
          .ivu-btn.ivu-btn-text.ivu-btn-small.ivu-btn-icon-only {
            display: inline-block;
          }
        }
      }
    }
  }
}
</style>
