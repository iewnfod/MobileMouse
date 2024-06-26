
import router from '@ohos.router'
@Component
export default struct ListItemCustom {
  @Prop content: string
  @Prop address: string
  @Prop param: string // JSON

  onJumpClick() {
    router.pushUrl({
      url: this.address,
      params: JSON.parse(this.param)
    })
  }

  build() {
    Column() {
      Row() {
        Text(this.content)
          .fontSize(16)
          .margin({left: 8})
          .fontColor($r('app.color.default'))

        Blank()

        Image($r('app.media.leftArrow'))
          .height(16)
          .rotate({
            x: 0,
            y: 1,
            z: 0,
            centerX: '50%',
            centerY: '50%',
            angle: 180
          })
          .fillColor($r('app.color.line_grey_light'))
      }
      .width('100%')
    }
    .alignItems(HorizontalAlign.Start)
    .padding(8)
    .width('100%')
    .height(40)
    .justifyContent(FlexAlign.Center)
    .backgroundColor($r('app.color.list_item'))
    .borderRadius(8)
    .onClick(() => {
      this.onJumpClick()
    })
  }
}
