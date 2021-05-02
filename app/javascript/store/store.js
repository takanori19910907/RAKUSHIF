import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);
const savedLists = localStorage.getItem('req-shifts')
const store = new Vuex.Store({
  state: {
    shifts: savedLists ? JSON.parse(savedLists) : [
      // ユーザーID、希望日時をlocalStorageに保存
      {
      year: 2021,
      month: 5,
      day: 1,
      clockIn: "9:00",
      clockOut: "13:00" 
      },
      {
        year: 2021,
        month: 5,
        day: 2,
      clockIn: "12:00",
      clockOut: "17:00"      
      },
    ],
  },

  getters: {},

  actions: {
    addShift(context, payload) {
      context.commit('addShift', payload)
    },
    deleteReqLists(context) {
      context.commit("deleteReqLists")
    },
    removeStorageShiftData(context, payload) {
      context.commit('removeStorageShiftData', payload)
    }
  },

  mutations: {
    addShift(state, payload) {
      state.shifts.push({
        clockIn: payload.clockIn,
        clockOut: payload.clockOut,
        year: payload.year,
        month: payload.month,
        day: payload.day
      })
    },
    deleteReqLists(state) {
      state.shifts = []
    },
    removeStorageShiftData(state, payload) {
      state.shifts.splice(payload.listIndex, 1)
    }
  },
})

store.subscribe((mutation, state) => {
  localStorage.setItem('req-shifts', JSON.stringify(state.shifts))
});

export default store;