import Vue from "vue";
import Router from "vue-router";
Vue.use(Router);
import RequestedShifts from "../components/organisms/staff/RequestedShifts.vue";
import RequestedShiftsDetail from "../components/organisms/staff/RequestedShiftsDetail.vue";
import FixedShifts from "../components/organisms/staff/FixedShifts.vue";
import RequestedShiftsIndex from "../components/organisms/admin/RequestedShiftsIndex.vue";
import FixedShiftsIndex from "../components/organisms/admin/FixedShiftsIndex.vue";
const router = new Router({
  mode: "history",
  routes: [
    {
      path: "/users/top/staff/requested_shifts/",
      component: RequestedShifts,
    },

    {
    path: "/users/top/staff/requested_shifts/id", 
      name: "RequestedShiftsDetail",
      component: RequestedShiftsDetail
    },

    {
      path: "/users/top/staff/fixed_shifts/",
      name: "FixedShifts",
      component: FixedShifts,
    },

    {
      path: "/users/top/admin/requested_shifts/",
      name: "RequestedShiftsIndex",
      component: RequestedShiftsIndex,
    },

    {
      path: "/users/top/admin/fixed_shifts/",
      name: "FixedShiftsIndex",
      component: FixedShiftsIndex,
    },
  ],
});
export default router;