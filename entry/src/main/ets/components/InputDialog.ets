@CustomDialog
struct InputDialog {
  message: string | Resource = ""
  placeholder: string | Resource = ""
  confirm?: (value: string) => void
  cancel?: (value: string) => void
  value: string
  controller: CustomDialogController

  build() {
    Column({ space: 20 }) {
      Text(this.message)

      TextInput({ placeholder: this.placeholder })
        .onChange((v) => this.value = v)

      Row() {
        Button($r('app.string.cancel'))
          .onClick(() => {
            if (this.cancel) {
              this.cancel(this.value)
            }
            this.controller.close()
          })
          .width('40%')
          .fontColor($r('app.color.default'))
          .backgroundColor($r('app.color.bg'))

        Button($r('app.string.confirm'))
          .onClick(() => {
            if (this.confirm) {
              this.confirm(this.value)
            }
            this.controller.close()
          })
          .width('40%')
      }
      .width("100%")
      .justifyContent(FlexAlign.SpaceAround)
    }
    .padding(20)
  }
}

export default InputDialog
