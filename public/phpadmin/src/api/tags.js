import axios from '@/libs/api.request'

export const listtags = data => {
  //获取标签列表
  return axios.request({
    url: '/admin/tags/list',
    method: 'get',
    params: data
  })
}

export const addtags = data => {
  //添加标签
  return axios.request({
    url: '/admin/tags/addtags',
    method: 'post',
    data: data
  })
}


export const edittags = data => {
  //编辑标签
  return axios.request({
    url: '/admin/tags/edittags',
    method: 'post',
    data: data
  })
}
export const deltags = data => {
  //删除标签
  return axios.request({
    url: '/admin/tags/deltags',
    method: 'post',
    data: data
  })
}
