@Component
export default struct LoadingBar {
  @State loadingBarNumber: number = 6
  @State maxBarHeight: number = 25

  @State rotateAngle: number = 0

  aboutToAppear() {
    setTimeout(() => {
      animateTo({
        duration: 5000,
        iterations: -1,
        curve: Curve.EaseInOut,
      }, () => {
        this.rotateAngle = 180
      })
    }, 100)
  }

  build() {
    Row() {
      ForEach(Array.from({length: this.loadingBarNumber}), (_, index) => {
        Rect()
          .width(4)
          .height(this.maxBarHeight)
          .radius(2)
          .margin({left: 5, right: 5})
          .fill($r('app.color.primary'))
          .rotate({
            x: 1,
            y: 0,
            z: 0,
            centerX: 4 / 2,
            centerY: this.maxBarHeight / 2,
            angle: this.rotateAngle
          })
          .animation({delay: index * 100, iterations: -1})
      })
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
  }
}
