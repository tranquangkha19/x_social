// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"
// import "./user_socket.js"

let typingTimeout;
const TYPING_TIMER_LENGTH = 3000;

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken}
})

let userSocket = new Socket("/socket", {params: {token: window.userToken}})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()
userSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()


let channel = userSocket.channel("room:lobby", {})
let chatInput         = document.querySelector("#chat-input")
let messagesContainer = document.querySelector("#messages")

chatInput.addEventListener("keypress", event => {
  if(event.key === 'Enter'){
    channel.push("new_msg", {body: chatInput.value})
    chatInput.value = ""
    clearTimeout(typingTimeout);
    channel.push("stop_typing"); // Notify the server that the user stopped typing
  }
  else {
    // Handle other keypress events (e.g., detect typing)
    channel.push("typing"); // Notify the server that the user is typing

    clearTimeout(typingTimeout);
    typingTimeout = setTimeout(() => {
      channel.push("stop_typing"); // Stop typing notification after a delay
    }, TYPING_TIMER_LENGTH);
  }
})

// channel.on("new_msg", payload => {
//   let messageItem = document.createElement("p")
//   messageItem.innerText = `[${Date()}] ${payload.body}`
//   messagesContainer.appendChild(messageItem)
// })

// channel.on("typing", (msg) => {
//   targetNode = document.getElementsByClassName("messages")[0]
//   targetNode.scrollTop = targetNode.scrollHeight
// })

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

window.liveSocket = liveSocket
window.userSocket = userSocket

