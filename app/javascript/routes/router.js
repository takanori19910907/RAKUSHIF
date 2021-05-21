import Vue from "vue";
import Router from "vue-router";
Vue.use(Router);
import RequestedShifts from "../views/staff/RequestedShifts.vue";
import RequestedShiftsDetail from "../views/staff/RequestedShiftsDetail.vue";
import RequestedShiftsIndex from "../views/admin/RequestedShiftsIndex.vue";
const router = new Router({
  routes: [
    {
      path: "/staff/requested_shifts/",
      component: RequestedShifts,
    },

    {
    path: '/staff/requested_shifts/id', 
      name: 'RequestedShiftsDetail',
      component: RequestedShiftsDetail
    },

    {
      path: "/admin/requested_shifts/",
      component: RequestedShiftsIndex,
    },

  ],
});
export default router;