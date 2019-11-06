import axios from '@/libs/api.request'

export const addGoods = data => {
  //添加商品 
  return axios.request({
    url: '/admin/goods/addgoods',
    method: 'post',
    data: data
  })
}


export const editGoods = data => {
  //编辑产品
  return axios.request({
    url: '/admin/goods/editgoods',
    method: 'post',
    data: data
  })
}


export const showGoods = data => {
  //产看产品详情
  return axios.request({
    url: '/admin/goods/show',
    method: 'get',
    params: data
  })
}

export const listGoods = data => {
  //查询产品列表
  return axios.request({
    url: '/admin/goods/list',
    method: 'get',
    params: data
  })
}

export const delGoods = data => {
  //删除商品
  return axios.request({
    url: '/admin/goods/del',
    method: 'post',
    data: data
  })
}

export const enableGoods = data => {
  //商品上下架
  return axios.request({
    url: '/admin/goods/enable',
    method: 'post',
    data: data
  })
}