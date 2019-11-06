import axios from '@/libs/api.request'

export const bannerList = data => {
  return axios.request({
    url: '/admin/banner/bannerList',
    method: 'post',
    data:data
  })
}


export const showBanner = data => {
  return axios.request({
    url: '/admin/banner/showBanner',
    method: 'post',
    data:data
  })
}

export const editBanner = data => {
  return axios.request({
    url: '/admin/banner/editBanner',
    method: 'post',
    data:data
  })
}

export const addBanner = data => {
  return axios.request({
    url: '/admin/banner/addBanner',
    method: 'post',
    data:data
  })
}

