import Vue from 'vue'
import ActionCableVue from 'actioncable-vue';

Vue.use(ActionCableVue, {
  debug: true,
  debugLevel: 'error',
  connectionUrl: 'ws://localhost:3000/cable',
  connectImmediately: true
});

