import Vue from "vue";
import Router from "vue-router";
Vue.use(Router);
import Home from "../views/Home.vue";
import About from "../views/About.vue";

const router = new Router({
  mode: "history",
  routes: [
    {
      path: "/admin/requested_shifts",
      component: Home,
    },
    {
      path: "/admin/requested_shifts/about", 
      component: About
    }

  ],
});
export default router;