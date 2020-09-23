import Vue from 'vue'
import App from '../staff.vue'
import './api/index'

document.addEventListener('DOMContentLoaded', () => {
    const app = new Vue({
        render: h => h(App)
    }).$mount()
    document.body.appendChild(app.$el)
})
