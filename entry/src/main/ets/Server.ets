import webSocket from '@ohos.net.webSocket'
import util from '@ohos.util'
import router from '@ohos.router'
import { ErrorDialog, GetStringFromResource } from './Utils'

export class Server {
  address: string
  scroller: Scroller
  uid: string
  private ws: webSocket.WebSocket = null

  constructor(address: string) {
    this.address = address
    this.scroller = new Scroller()
    this.uid = util.generateRandomUUID()
  }

  connect(onSuccess: () => void, onError: (err: string) => void) {
    this.ws = webSocket.createWebSocket()

    this.ws.on("message", (err, value) => {
      if (!err) {
        console.log(`Message: ${value}`)
      } else {
        console.error(err.message);
      }
    })

    this.ws.on("open", () => {
      this.ws.send(JSON.stringify({
        type: "move",
        x: 1,
        y: 1
      }))
      onSuccess()
    })

    this.ws.on("error", (err) => {
      onError(err.message)
    })

    this.ws.on("close", () => {
      if (router.getState().name !== "Index") {
        ErrorDialog({
          message: GetStringFromResource($r('app.string.connectionClosed'))
        })
      }
    })

    this.ws.connect(`ws://${this.address}`, (err) => {
      if (err) {
        onError(err.message)
      }
    })
  }

  disconnect(onSuccess?: () => void) {
    this.ws.close(() => {
      if (onSuccess) {
        onSuccess()
      }
    })
  }
}
