import Vue from 'vue'
//import App from './App.vue'

const qApp = document.querySelector("#q-app")

if (qApp) {
  console.log("have a requestContainer")
//   Vue.component('my-page', {
//     template: '#my-page'
//   })

  new Vue({
    el: '#q-app',
    data: function () {
      return {
        version: Quasar.version,
        drawerState: true
      }
    },
    methods: {
      launch: function (url) {
        //Quasar.utils.openURL(url)
      }
    }
  })
}