import axios from '@/libs/api.request'

export const couponList = data => {
  return axios.request({
    url: '/admin/coupon/couponList',
    method: 'post',
    data:data
  })
}

export const couponAdd = data => {
  return axios.request({
    url: '/admin/coupon/couponAdd',
    method: 'post',
    data:data
  })
}

export const couponEdit = data => {
  return axios.request({
    url: '/admin/coupon/couponEdit',
    method: 'post',
    data:data
  })
}