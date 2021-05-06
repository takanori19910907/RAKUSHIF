import Vue from "vue";
import Router from "vue-router";
Vue.use(Router);
import Home from "../views/Home.vue";
import About from "../views/About.vue";

const router = new Router({
  routes: [
    {
      path: "/",
      component: Home,
    },
    {
    path: '/about/:id', 
      name: 'About',
      component: About
      }
  ],
});
export default router;