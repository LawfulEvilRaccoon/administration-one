import jsCookie from "https://cdn.jsdelivr.net/npm/js-cookie@3.0.5/+esm"
const { timeZone } = new Intl.DateTimeFormat().resolvedOptions()
jsCookie.set("time_zone", timeZone, { expires: 365 })