import {
  login,
  logout,
  getMessage,
  hasRead,
  removeReaded,
  restoreTrash,
  getUnreadCount
} from '@/api/user'

export default {
  state: {
    account: '',
    userId: '',
    avatarImgPath: '',
    access: '',
    hasGetInfo: false,
    unreadCount: 0,
    messageUnreadList: [],
    messageReadedList: [],
    messageTrashList: [],
    messageContentStore: {},
    info: {
      account: "",
      authKeys: "",
      menuAuth: "",
      nikename: "",
      phone: "",
      sex: "",
    }
  },
  mutations: {
    setAvatar(state, avatarPath) {
      state.avatarImgPath = avatarPath
    },
    setUserId(state, id) {
      state.userId = id
    },
    setAccess(state, access) {
      state.access = access
    },
    setHasGetInfo(state, status) {
      state.hasGetInfo = status
    },
    setMessageCount(state, count) {
      state.unreadCount = count
    },
    updateMessageContentStore(state, {
      msg_id,
      content
    }) {
      state.messageContentStore[msg_id] = content
    },
    moveMsg(state, {
      from,
      to,
      msg_id
    }) {
      const index = state[from].findIndex(_ => _.msg_id === msg_id)
      const msgItem = state[from].splice(index, 1)[0]
      msgItem.loading = false
      state[to].unshift(msgItem)
    },
    setUserInfo(state, data) {
      state.info = {
        account: data.account,
        authKeys: data.authKeys,
        menuAuth: data.menuAuth,
        nikename: data.nikename,
        phone: data.phone,
        sex: data.sex,
      }
    }
  },
  getters: {
    // messageUnreadCount: state => state.messageUnreadList.length
  },
  actions: {
    // 登录
    handleLogin({
      commit
    }, {
      account,
      password
    }) {
      account = account.trim()
      return new Promise((resolve, reject) => {
        login({
          account,
          password
        }).then(res => {
          resolve(res.data)
        }).catch(err => {
          reject(err)
        })
      })
    },
    // 退出登录
    handleLogOut({
      state,
      commit
    }) {
      return new Promise((resolve, reject) => {
        logout(state.token).then(() => {
          resolve()
        }).catch(err => {
          reject(err)
        })
      })
    },
    // 此方法用来获取未读消息条数，接口只返回数值，不返回消息列表
    getUnreadMessageCount({
      state,
      commit
    }) {
      getUnreadCount().then(res => {
        if (res.data.success) {
          const {
            data
          } = res
          commit('setMessageCount', data.data)
        } else {
          const {
            data
          } = res
          commit('setMessageCount', 0)
        }

      })
    },
  }
}
