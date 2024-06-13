import router from '@ohos.router'
import LoadingBar from '../components/LoadingBar'
import { ConnectionStatus, Server } from '../Server'
import { ErrorDialog, GetStringFromResource } from '../Utils'

@Entry
@Component
struct ConnectPage {
  @State serverAddress: string = router.getParams()?.['serverAddress']

  server: Server = new Server(this.serverAddress)
  
  onPageShow() {
    if (!this.serverAddress) {
      ErrorDialog({message: 'Server Address is Required', backUrl: 'pages/Index'})
    }
    this.server.connect()
    this.checkConnection()
  }

  checkConnection() {
    switch (this.server.connectionStatus) {
      case ConnectionStatus.success:
        router.pushUrl({url: 'pages/ControlPage', params: {server: this.server}})
        return;
      case ConnectionStatus.error:
        ErrorDialog({
          title: GetStringFromResource($r('app.string.connectionFailed')),
          message: this.server.errorMessage,
          backUrl: 'pages/Index'
        })
        return;
    }

    setTimeout(() => {
      this.checkConnection()
    }, 1000)
  }

  build() {
    Column() {
      Navigation() {
        Column() {
          LoadingBar()

          Text($r('app.string.connecting'))
            .fontSize(18)
            .margin({top: 20})

          Text(this.serverAddress)
            .fontSize(16)
            .margin({top: 10})
        }
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .translate({
          y: '-10%'
        })
        .alignItems(HorizontalAlign.Center)
      }
      .title(GetStringFromResource($r('app.string.cancel')))
      .titleMode(NavigationTitleMode.Mini)
      .size({width: '100%', height: '100%'})
    }
  }
}
function message(message: any,arg1: string,arg2: string) {
throw new Error('Function not implemented.')
}
