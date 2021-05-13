import Vue from "vue";
import Vuex from "vuex";
import VueRouter from "vue-router";
import store from "../store/store.js";
import router from "../routes/router.js";
import App from "../App.vue";
import axios from "axios";
axios.defaults.headers.common = {
  'X-Requested-With': 'XMLHttpRequest',
  'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
};
import VueAxios from "vue-axios";

Vue.use(Vuex);
Vue.use(VueRouter);
Vue.use(VueAxios, axios);

document.addEventListener("DOMContentLoaded", () => {
  new Vue({
    el: '#app',
    store,
    router,
    render: (h) => h(App),
  })
});