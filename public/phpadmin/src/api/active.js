import axios from '@/libs/api.request'

export const listActive = data => {
  return axios.request({
    url: '/admin/active/listActive',
    method: 'post',
    data:data
  })
}

export const addActive = data => {
    return axios.request({
      url: '/admin/active/addActive',
      method: 'post',
      data:data
    })
  }
  

  export const editActive = data => {
    return axios.request({
      url: '/admin/active/editActive',
      method: 'post',
      data:data
    })
  }

  export const showActive = data => {
    return axios.request({
      url: '/admin/active/showActive',
      method: 'post',
      data:data
    })
  }

  export const delActive = data => {
    return axios.request({
      url: '/admin/active/delActive',
      method: 'post',
      data:data
    })
  }

  


  export const goodAddActive = data => {
    return axios.request({
      url: '/admin/active/goodAddActive',
      method: 'post',
      data:data
    })
  }