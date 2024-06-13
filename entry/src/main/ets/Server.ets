import webSocket from '@ohos.net.webSocket'

export enum ConnectionStatus {
  waiting,
  success,
  error
}

export class Server {
  address: string
  scroller: Scroller
  private ws: webSocket.WebSocket = null
  connectionStatus: ConnectionStatus = ConnectionStatus.waiting
  errorMessage: string = ""

  constructor(address: string) {
    this.address = address
    this.scroller = new Scroller()
  }

  connect() {
    this.ws = webSocket.createWebSocket()
    this.ws.connect(`ws://${this.address}`, (err, _value) => {
      if (!err) {
        this.connectionStatus = ConnectionStatus.success
        console.log(`${this.address} 连接成功`)
      } else {
        this.connectionStatus = ConnectionStatus.error
        this.errorMessage = err.message
        console.error(`${this.address} 连接失败`, `错误: ${JSON.stringify(err)}`)
      }
    })
  }
}
