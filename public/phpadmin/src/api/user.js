import axios from '@/libs/api.request'

export const login = ({
  account,
  password
}) => {
  const data = {
    account,
    password
  }
  return axios.request({
    //登陆
    url: '/admin/login/login',
    data,
    method: 'post'
  })
}

export const logout = () => {
  //登出
  return axios.request({
    url: '/admin/login/loginOut',
  })
}

export const current = () => {
  //查看是否登陆
  return axios.request({
    url: '/admin/login/current',
    method: 'post'
  })
}

export const getUnreadCount = () => {
  //获取未读信息数量
  return axios.request({
    url: '/admin/message/count',
    method: 'get'
  })
}

export const getMessage = () => {
  //获取用户消息
  return axios.request({
    url: '/admin/message/init',
    method: 'get'
  })
}
export const removeMsg = data => {
  //删除用户消息
  return axios.request({
    url: '/admin/message/trashMsg',
    method: 'get',
    params: data
  })
}
export const readMsg = data => {
  //读了消息
  return axios.request({
    url: '/admin/message/readMsg',
    method: 'get',
    params: data
  })
}

export const menuAuth = data => {
  //获取权限导航表
  return axios.request({
    url: '/admin/menuauth/menuList',
    method: 'get',
    params: data
  })
}

export const userList = data => {
  //获取用户表
  return axios.request({
    url: '/admin/user/userList',
    method: 'post',
    data: data
  })
}

export const addUser = data => {
  //添加用户
  return axios.request({
    url: '/admin/user/addUser',
    method: 'post',
    data: data
  })
}
export const showUser = data => {
  //添加用户
  return axios.request({
    url: '/admin/user/showUser',
    method: 'post',
    data: data
  })
}

export const editUser = data => {
  //编辑用户
  return axios.request({
    url: '/admin/user/editUser',
    method: 'post',
    data: data
  })
}

export const enableUser = data => {
  //编辑用户
  return axios.request({
    url: '/admin/user/enableUser',
    method: 'post',
    data: data
  })
}


export const delUser = data => {
  //删除用户
  return axios.request({
    url: '/admin/user/delUser',
    method: 'post',
    data: data
  })
}

export const hasRead = msg_id => {
  return axios.request({
    url: 'message/has_read',
    method: 'post',
    data: {
      msg_id
    }
  })
}

export const removeReaded = msg_id => {
  return axios.request({
    url: 'message/remove_readed',
    method: 'post',
    data: {
      msg_id
    }
  })
}

export const restoreTrash = msg_id => {
  return axios.request({
    url: 'message/restore',
    method: 'post',
    data: {
      msg_id
    }
  })
}
