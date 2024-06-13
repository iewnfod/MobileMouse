@Component

export default struct ListTitle {
  title: string | Resource = ""

  build() {
    Row() {
      Rect()
        .width(4)
        .height(16)
        .radius(2)
        .fill($r('app.color.primary'))

      Text(this.title)
        .fontColor($r('app.color.default'))
        .fontSize(16)
        .fontWeight(500)
        .margin({left: 10})
    }
    .margin({top: 8})
    .alignItems(VerticalAlign.Center)
  }
}
