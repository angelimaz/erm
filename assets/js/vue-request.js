import Vue from 'vue'
import App from './App.vue'

const requestContainer = document.querySelector("#request-container")

if (requestContainer) {
  console.log("have a requestContainer")
  new Vue({
    el: '#request-container',
    template: '<App/>',
    components: { App }
  })
}