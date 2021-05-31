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
        day: 2,
      clockIn: "12:00",
      clockOut: "17:00"      
      },
    ],
      fixedShifts: savedLists ? JSON.parse(savedLists) : [
      {
        year: 2099,
        month: 6,
        day: 2,
        clockIn: "12:00",
        clockOut: "17:00"
      },
    ]
  },

  getters: {},

  actions: {
    addShift(context, payload) {
      context.commit('addShift', payload)
    },
    updateShift(context, payload) {
      context.commit('updateShift', payload)
    },
    deleteReqLists(context) {
      context.commit("deleteReqLists")
    },
    removeStorageShiftData(context, payload) {
      context.commit('removeStorageShiftData', payload)
    },
    fixedShifts(context, payload) {
      context.commit('fixedShifts', payload)
    },
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
    
    updateShift(state, payload) {
      state.shifts.splice([payload.shiftIdx], 1, {
        clockIn: payload.clockIn,
        clockOut: payload.clockOut,
        year: payload.year,
        month: payload.month,
        day: payload.day
        }
      )
    },

    deleteReqLists(state) {
      state.shifts = []
    },
    removeStorageShiftData(state, payload) {
      state.shifts.splice(payload.shiftIdx, 1)
    },
    fixedShifts(state, payload) {
      if (payload.length) {
        state.fixedShifts.push(payload)
      }
    }
  },
})

store.subscribe((mutation, state) => {
  localStorage.setItem('req-shifts', JSON.stringify(state.shifts))
});

export default store;