import Vue from "vue";
import Vuex from "vuex";
import axios from "axios";
import dayjs from 'dayjs';

Vue.use(Vuex);
const savedLists = localStorage.getItem('shiftsStorageData')
const store = new Vuex.Store({
  state: {
    // ユーザー自身のユーザー情報
    myUserData: savedLists ? JSON.parse(savedLists) : [],

    //  ユーザー自身の希望シフト情報
    myRequestedShifts: savedLists ? JSON.parse(savedLists) : [],

    // 希望シフトの格納場所
    temporarilyRequestedShifts: savedLists ? JSON.parse(savedLists) : [],

    // 全ユーザー情報
    allUsersData: savedLists ? JSON.parse(savedLists) : [],

    // 全ユーザーの希望シフト情報
    requestedShiftsInTableData: savedLists ? JSON.parse(savedLists) : [],

    // 全ユーザーの確定シフト情報
    fixedShiftsInTableData: savedLists ? JSON.parse(savedLists) : []

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
      var shifts = data.shifts.filter(function (item) {
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
    // ユーザーが使う機能

    async getMyUserData(context) {
      const response = await axios.get('/api/v1/staff/users')
      context.commit('getMyUserData', response.data)
    },

    async getMyShiftData(context) {
      const response = await axios.get('/api/v1/staff/requested_shifts')
      context.commit('getMyShiftData', response.data)
    },

    async getAllShiftsByUser(context) {
      const response = await axios.get('/api/v1/staff/fixed_shifts')
      context.commit('getFixedShiftsInTableData', response.data)
    },

    addShift(context, payload) {
      context.commit('addShift', payload)
    },
    updateShift(context, payload) {
      context.commit('updateShift', payload)
    },
    resetRequestedShifts(context) {
      context.commit("resetRequestedShifts")
    },
    removeStorageShiftData(context, payload) {
      context.commit('removeStorageShiftData', payload)
    },

    postRequestedShiftsInTheTable(context) {
      context.commit('postRequestedShiftsInTheTable')
    },

    async updateShiftInTableData(context, payload) {
      if (payload.type === "requested") {
        await axios.patch(`/api/v1/staff/requested_shifts/${payload.returnedModalData.shiftId}`, {
          shiftData: {
            year: payload.returnedModalData.year,
            month: payload.returnedModalData.month,
            date: payload.returnedModalData.date,
            clockIn: payload.returnedModalData.clockIn,
            clockOut: payload.returnedModalData.clockOut,
          }
        })
        const response = await axios.get('/api/v1/staff/requested_shifts')
        context.commit('getMyShiftData', response.data)

      } else if (payload.type === "fixed") {
        await axios.patch(`/api/v1/admin/fixed_shifts/${payload.returnedModalData.shiftId}`, {
          shiftData: {
            year: payload.returnedModalData.year,
            month: payload.returnedModalData.month,
            date: payload.returnedModalData.date,
            clockIn: payload.returnedModalData.clockIn,
            clockOut: payload.returnedModalData.clockOut,
            user_id: payload.returnedModalData.userId
          }
        })
        const response = await axios.get('/api/v1/admin/fixed_shifts')
        context.commit('getFixedShiftsInTableData', response.data)
      }
    },

    async deleteFixedShiftInTableData(context, payload) {
      if (payload.type === "requested") {
        await axios.delete(`/api/v1/staff/requested_shifts/${payload.shiftID}`)
        const response = await axios.get('/api/v1/staff/requested_shifts')
        context.commit( 'getMyShiftData', response.data )
      } else if (payload.type === "fixed") {
        await axios.delete(`/api/v1/admin/fixed_shifts/${payload.shiftID}`)
        const response = await axios.get('/api/v1/staff/fixed_shifts')
        context.commit( 'getFixedShiftsInTableData', response.data )
      }
    },
    
    // 管理者が使うシフト関連機能
    async getAllShiftsByAdmin(context, payload) {
      if ( payload.type === "requested" ) {
        const response = await axios.get('/api/v1/admin/requested_shifts')
        context.commit('getRequestedShiftsByAdmin', response.data)
      } else if ( payload.type === "fixed" ) {
        const response = await axios.get('/api/v1/admin/fixed_shifts')
        context.commit('getFixedShiftsInTableData', response.data)
      }
    },

    async getAllUsers(context) {
        const response = await axios.get('/api/v1/admin/users')
        context.commit('getAllUsers', response.data)
    },

    addFixedShifts(context, payload) {
      context.commit('addFixedShifts', payload)
    },

    updateShiftInStorageData(context, payload) {
      context.commit('updateShiftInStorageData', payload)
    },
    
    deleteItemInShiftData(context, payload) {
      context.commit('deleteItemInShiftData', payload)
    },

    async createFixedShift(context, payload) {
      await axios.post('/api/v1/admin/fixed_shifts', { shifts: payload })
      const response = await axios.get('/api/v1/admin/fixed_shifts')
      context.commit('getFixedShiftsInTableData', response.data)
    }
  },

  mutations: {
    // ユーザーが使う機能
    getMyUserData(state, payload) {
      state.myUserData = payload
    },

    getMyShiftData(state, payload) {
      state.myRequestedShifts = payload
    },

    addShift(state, payload) {
      state.temporarilyRequestedShifts.push({
        clockIn: payload.clockIn,
        clockOut: payload.clockOut,
        year: payload.year,
        month: payload.month,
        date: payload.date
      })
    },
    
    updateShift(state, payload) {
      state.temporarilyRequestedShifts.splice([payload.shiftId], 1, {
        clockIn: payload.clockIn,
        clockOut: payload.clockOut,
        year: payload.year,
        month: payload.month,
        date: payload.date
      })
    },

    resetRequestedShifts(state) {
      state.temporarilyRequestedShifts = []
    },

    removeStorageShiftData(state, payload) {
      state.temporarilyRequestedShifts.splice(payload.shiftId, 1)
    },

    async postRequestedShiftsInTheTable(state) {
      if (window.confirm("入力した希望シフトをまとめて提出します、よろしいですか?")) {
        await axios.post('/api/v1/staff/requested_shifts', { shifts: state.temporarilyRequestedShifts })
      }
    },
    
    // 管理者が使う機能
    getAllUsers(state, payload) {
      state.allUsersData = payload
    },

    getRequestedShiftsByAdmin(state, payload) {
      state.requestedShiftsInTableData = payload
    },

    getFixedShiftsInTableData(state, payload) {
      state.fixedShiftsInTableData = payload
    },

    addFixedShifts(state, payload) {
      state.temporarilyFixedShifts.push(payload)
    },

    updateShiftInStorageData(state, payload) {
      let targetShift = state.requestedShiftsInTableData.find(el => el.id == payload.shiftId)
      targetShift.clock_in = `${payload.year}-${payload.month}-${payload.date} ${payload.clockIn}:00`;
      targetShift.clock_out = `${payload.year}-${payload.month}-${payload.date} ${payload.clockOut}:00`;
    },

    deleteItemInShiftData(state, payload) {
      const fixedShifts = state.requestedShiftsInTableData
      for (var i = 0; i < fixedShifts.length; i++) {
        if (payload === fixedShifts[i].id) {
          fixedShifts.splice(i, 1);
        }
      }
    }
  }
})

store.subscribe((mutation, state) => {
  localStorage.setItem('shiftsStorageData', JSON.stringify(state.temporarilyRequestedShifts))
});

export default store;