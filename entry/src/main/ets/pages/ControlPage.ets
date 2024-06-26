import router from '@ohos.router'
import LoadingBar from '../components/LoadingBar';
import { Server } from '../Server'
import { ErrorDialog, GetStringFromResource } from '../Utils'

@Component
struct CenterContent {
  @Prop loading: boolean
  @Prop address: string

  build() {
    Column() {
      if (this.loading) {
        Column() {
          LoadingBar()

          Text($r('app.string.connecting'))
            .fontSize(18)
            .margin({top: 20})

          Text(this.address)
            .fontSize(16)
            .margin({top: 10})
        }
      } else {
        Text($r('app.string.touchArea'))
          .fontColor($r('app.color.font_light'))
      }
    }
  }
}

@Entry
@Component
struct ControlPage {
  params = JSON.parse(JSON.stringify(router.getParams()))

  @State serverAddress: string = this.params['serverAddress']
  @State connected: boolean = false

  server: Server = new Server(this.serverAddress)
  pageShowing: boolean = false

  originalX: number = 0
  originalY: number = 0

  onPageShow() {
    this.pageShowing = true

    if (!this.serverAddress) {
      ErrorDialog({message: 'Server Address is Required'})
      return
    }

    this.server.connect(
      () => {
        this.connected = true
      },
      (err) => {
        if (this.pageShowing) {
          ErrorDialog({
            title: GetStringFromResource($r('app.string.connectionFailed')),
            message: err
          })
        }
      }
    )
  }

  onPageHide() {
    this.pageShowing = false
    this.server.disconnect()
  }

  build() {
    Column() {
      Navigation() {
        Column() {
          Column() {
            CenterContent({
              loading: !this.connected,
              address: this.serverAddress
            })
          }
          .flexGrow(1)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .width('100%')
          .backgroundColor($r('app.color.bg_grey'))
          .borderRadius(10)
          .border({style: BorderStyle.Solid, color: $r('app.color.line_grey_light'), width: 1})
          .margin({bottom: 20})
          .gesture(
            PanGesture({})
              .onActionStart((event) => {
                this.originalX = event.offsetX
                this.originalY = event.offsetY
              })
              .onActionUpdate((event) => {
                if (Math.abs(this.originalX - event.offsetX) < 1 || Math.abs(this.originalY - event.offsetY) < 1) {
                  return
                }

                this.server.moveMouse(
                  event.offsetX - this.originalX,
                  event.offsetY - this.originalY
                )

                this.originalX = event.offsetX
                this.originalY = event.offsetY
              })
          )
          .onClick(() => {
            this.server.leftClick()
          })

          Row() {
            Button($r('app.string.leftClick'))
              .onClick(() => {
                if (this.connected) {
                  this.server.leftClick()
                }
              })
            Button($r('app.string.rightClick'))
              .onClick(() => {
                if (this.connected) {
                  this.server.rightClick()
                }
              })
          }
          .justifyContent(FlexAlign.SpaceEvenly)
          .alignItems(VerticalAlign.Center)
          .width('100%')
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(HorizontalAlign.Center)
        .height('100%')
        .width('100%')
        .padding({ top: 10, left: 20, right: 20, bottom: 20 })
      }
      .title(this.server ? this.server.address : GetStringFromResource($r('app.string.cancel')))
      .titleMode(NavigationTitleMode.Mini)
      .size({width: '100%', height: '100%'})
    }
  }
}
