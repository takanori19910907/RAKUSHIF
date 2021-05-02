import Vue from "vue";
import Router from "vue-router";
Vue.use(Router);
import Home from "../views/Home.vue";
import About from "../views/About.vue";
// import RequestedShift from '../components/RequestedShift.vue';
// import RequestedShiftIndex from 'RequestedShiftIndex.vue';
// import RequestedShiftDetail from 'RequestedShiftDetail.vue';

const router = new Router({
  mode: "history",
  routes: [
     //ルーティングの設定
    // { path: '/',
    //   component: RequestedShift,
    // },
    // { path: '/2021.04.25',
    //   component: RequestedShiftIndex,
    // },
    // { path: '/2021.04.25/:id(\\d+)',
    //   component: RequestedShiftDetail,
    // },
    {
      path: "/admin/requested_shifts",
      component: Home,
    },
    // {
    //   path: "/admin/requested_shifts/:id",
    //   component: About,
    // },
    {
      path: "/admin/requested_shifts/about", 
      component: About
    }

  ],
});
export default router;