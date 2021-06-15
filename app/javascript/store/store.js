import Vue from "vue";
import Vuex from "vuex";
import axios from "axios";
import dayjs from 'dayjs';

Vue.use(Vuex);
const savedLists = localStorage.getItem('req-shifts')
const store = new Vuex.Store({
  state: {
    // requestedShifts => 希望シフト
    // RequestedShifts-componentからdispatchされたデータを格納
    shifts: savedLists ? JSON.parse(savedLists) : [{}],

    myShifts: savedLists ? JSON.parse(savedLists) : [{}],

    // fixedShifts => 編集中シフト
    // FixedShiftIndex-componentでDBから取得したデータを格納
    fixedShifts: savedLists ? JSON.parse(savedLists) : [{}]
  },

  getters: {
  // ①カレンダーcomponentで指定した日付情報を取得し日付オブジェクトに変換
  // ②stateに保管している希望シフトデータも１つずつ日付オブジェクトへの変換処理を行う  
  // ③ ①と②の日付オブジェクトを比較し一致した希望シフトデータ
  // (カレンダーcomponentで指定した日付情報の希望シフトデータ)のみ抽出する
  // ④希望シフトとRequestedShiftsIndex componentから取得したユーザー情報を紐付けて
  // 希望シフト & ユーザー情報をセットにしたオブジェクトを作成しcomponentに返す
  
    filteredShiftData: (state) => (data) => {
      var calendarDate = dayjs(data.date.year + '-' + data.date.month + '-' + data.date.date).format('DD/MM/YYYY')
      var shifts = state.fixedShifts.filter(function (item) {
        var shiftDate = dayjs(item.clock_in).format('DD/MM/YYYY')
        return calendarDate === shiftDate
      })
      return shifts.map(shift => {
        var user = data.user.find(function (user) {
        return user.id === shift.user_id
        })
        return {
          ...shift,
          user: user
        }
      })
    },

    formattedYear:  (state) => (data) => {
        return dayjs(data).year();
    },

    formattedMonth:  (state) => (data) => {
        return dayjs(data).month() + 1;
    },

    formattedDate:  (state) => (data) => {
        return dayjs(data).date();
    },

    formattedTime: (state) => (data) => {
      return dayjs(data).format('HH:mm');
    }
  },

  actions: {
    // ユーザーが使うシフト関連機能
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
    // 管理者が使うシフト関連機能
    fixedShifts(context, payload) {
      context.commit('fixedShifts', payload)
    },
    destroyShift(context, payload) {
      context.commit('destroyShift', payload)
    },
    updateItemInShiftData(context, payload) {
      context.commit('updateItemInShiftData', payload)
    }
  },

  mutations: {
    // ユーザーが使うシフト関連機能
    addShift(state, payload) {
      state.shifts.push({
        clockIn: payload.clockIn,
        clockOut: payload.clockOut,
        year: payload.year,
        month: payload.month,
        date: payload.date
      })
    },
    
    updateShift(state, payload) {
      state.shifts.splice([payload.shiftIdx], 1, {
        clockIn: payload.clockIn,
        clockOut: payload.clockOut,
        year: payload.year,
        month: payload.month,
        date: payload.date
      })
    },

    deleteReqLists(state) {
      state.shifts = []
    },

    removeStorageShiftData(state, payload) {
      state.shifts.splice(payload.shiftIdx, 1)
    },
    
    // ユーザーが使うシフト関連機能
    fixedShifts(state, payload) {
      state.fixedShifts.push(payload)
    },

    destroyShift(state, payload) {
      for (var i = 0; i < state.fixedShifts.length; i++) {
        if (payload === state.fixedShifts[i].id) {
          state.fixedShifts.splice(i, 1);
        }
      }
    },
    updateItemInShiftData(state, payload) {
      let targetShift = state.fixedShifts.find(el => el.id == payload.shiftIdx)
      targetShift.clock_in = `${payload.year}-${payload.month}-${payload.date} ${payload.clockIn}:00`;
      targetShift.clock_out = `${payload.year}-${payload.month}-${payload.date} ${payload.clockOut}:00`;
    },

    getMyShifts(state, shifts) {
      state.myShifts = shifts
    }
  }
})

store.subscribe((mutation, state) => {
  localStorage.setItem('req-shifts', JSON.stringify(state.shifts))
});

export default store;