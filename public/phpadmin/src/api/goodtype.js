import axios from '@/libs/api.request'

export const getGoodTree = data => {
  //获取树
  return axios.request({
    url: '/admin/goodtype/gettree',
    method: 'get',
    params: data
  })
}
export const getUnTree = () => {
  //获禁用的取树
  return axios.request({
    url: '/admin/goodtype/untree',
    method: 'get'
  })
}

export const trashTree = data => {
  //彻底删除删除
  return axios.request({
    url: '/admin/goodtype/trashTree',
    method: 'post',
    data: data
  })
}
export const addtree = data => {
  //增加树
  return axios.request({
    url: '/admin/goodtype/addtree',
    method: 'post',
    data: data
  })
}

export const edittree = data => {
  //增加树
  return axios.request({
    url: '/admin/goodtype/edittree',
    method: 'post',
    data: data
  })
}

export const deltree = data => {
  //增加树
  return axios.request({
    url: '/admin/goodtype/deltree',
    method: 'post',
    data: data
  })
}

///产品详情

export const selectTree = () => {
  //获禁用的取树
  return axios.request({
    url: '/admin/goodtype/selectTree',
    method: 'get'
  })
}