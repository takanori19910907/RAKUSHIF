import Vue from "vue";
import Router from "vue-router";
Vue.use(Router);
import RequestedShifts from "../views/staff/RequestedShifts.vue";
import RequestedShiftsDetail from "../views/staff/RequestedShiftsDetail.vue";
import FixedShifts from "../views/staff/FixedShifts.vue";
import RequestedShiftsIndex from "../views/admin/RequestedShiftsIndex.vue";
import FixedShiftsIndex from "../views/admin/FixedShiftsIndex.vue";
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
      path: "/staff/fixed_shifts/",
      name: 'FixedShifts',
      component: FixedShifts,
    },

    {
      path: "/admin/requested_shifts/",
      name: 'RequestedShiftsIndex',
      component: RequestedShiftsIndex,
    },

    {
      path: "/admin/fixed_shifts/",
      name: 'FixedShiftsIndex',
      component: FixedShiftsIndex,
    },
  ],
});
export default router;