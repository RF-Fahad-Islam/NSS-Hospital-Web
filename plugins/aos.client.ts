import AOS from 'aos'

export default defineNuxtPlugin((nuxtApp) => {
    if (typeof window !== 'undefined') {
        nuxtApp.hook('app:mounted', () => {
            AOS.init({
                duration: 800,
                easing: 'ease-out-back',
                once: false,
                mirror: true,
                offset: 100,
                anchorPlacement: 'top-bottom',
            })
        })
    }
})
