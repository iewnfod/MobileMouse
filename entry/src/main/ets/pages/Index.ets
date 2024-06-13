import ListItemCustom from '../components/list/ListItemCustom'
import ListTitle from '../components/list/ListTitle'
import InputDialog from '../components/InputDialog'
import { Server } from '../Server'
import PreferencesUtils, { DATA_PREFERENCES_NAME, DATA_PREFERENCE_KEYS } from '../PreferencesUtil'

@Entry
@Component
struct Index {
  @State private servers: Array<Server> = []

  private openDeleteServer: Server = null
  private deleteWidth = 80
  private downX = 0

  inputDialogController: CustomDialogController = new CustomDialogController({
    builder: InputDialog({
      message: $r('app.string.addServer'),
      placeholder: $r('app.string.addServerPrompt'),
      confirm: (value) => {
        if (value) {
          let newServer = new Server(value)
          if (this.servers.indexOf(newServer) === -1) {
            this.servers.push(newServer)
            this.saveServers()
          }
        }
      }
    })
  })

  saveServers() {
    PreferencesUtils.putPreferenceValue(
      DATA_PREFERENCES_NAME,
      DATA_PREFERENCE_KEYS.servers,
      Array.from(this.servers, (s) => s.address)
    )
  }

  onAddClick() {
    this.inputDialogController.open()
  }

  onDeleteServer(server: Server) {
    this.servers = this.servers.filter((s) => s !== server)
    this.saveServers()
  }

  onScrollTouch(event: TouchEvent, server: Server) {
    if (this.openDeleteServer != null && this.openDeleteServer != server) {
      this.openDeleteServer.scroller.scrollTo({ xOffset: 0, yOffset: 0,
        animation: { duration: 100, curve: Curve.Linear }
      })
    }

    console.log(event.touches[0].x.toString())

    switch (event.type) {
      case TouchType.Down:
        this.downX = event.touches[0].x
        break
      case TouchType.Up:
        let xOffset = event.touches[0].x - this.downX
        if (xOffset == 0) {
          return
        }

        let toxOffset = 0
        this.openDeleteServer = null;
        if (Math.abs(xOffset) > vp2px(this.deleteWidth) / 4 && xOffset < 0) {
          toxOffset = vp2px(this.deleteWidth)
          this.openDeleteServer = server
        }

        server.scroller.scrollTo({ xOffset: toxOffset, yOffset: 0,
          animation: { duration: 300, curve: Curve.Linear }
        })

        this.downX = 0
        break
    }
  }

  onPageShow() {
    PreferencesUtils.getPreferenceValue(DATA_PREFERENCES_NAME, DATA_PREFERENCE_KEYS.servers, []).then(ss => {
      // @ts-ignore
      this.servers = Array.from(ss, (s) => new Server(s))
    })
  }

  build() {
    Column() {
      Column() {
        Row() {
          Text($r('app.string.title'))
            .fontColor($r('app.color.main'))
            .fontSize(24)
            .fontWeight(700)
            .margin({bottom: 20, top: 10})

          Blank()

          Button() {
            Image($r('app.media.add'))
              .height(20)
              .fillColor($r('app.color.line_grey'))
          }
          .backgroundColor($r('app.color.bg_grey'))
          .padding(5)
          .translate({y: -5})
          .onClick(() => {
            this.onAddClick()
          })
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
      }
      .width('100%')

      List({space: 16}) {
        ListItem() {
          ListTitle({title: $r('app.string.ServerListTitle')})
        }

        ForEach(this.servers, (server: Server) => {
          ListItem() {
            Scroll(server.scroller) {
              Row() {
                ListItemCustom({
                  content: server.address.toString(),
                  address: 'pages/ConnectPage',
                  param: JSON.stringify({ serverAddress: server.address.toString() })
                })

                Text($r('app.string.remove'))
                  .fontColor(Color.White)
                  .height(40)
                  .margin(8)
                  .width(this.deleteWidth)
                  .borderRadius(8)
                  .backgroundColor(Color.Red)
                  .textAlign(TextAlign.Center)
                  .onClick(() => {
                    this.onDeleteServer(server)
                  })
              }
            }
            .scrollable(ScrollDirection.Horizontal)
            .scrollBar(BarState.Off)
            .onTouch((event: TouchEvent) => {
              this.onScrollTouch(event, server)
            })
          }
          .width('100%')
        })
      }
      .height('auto')
      .width('100%')
    }
    .padding(20)
    .width('100%')
  }
}
