import router from '@ohos.router'

export function GetStringFromResource(r: Resource) {
  return getContext().resourceManager.getStringSync(r)
}

type ErrorDialogParamType = {message: string, backUrl: string, title? : string, jsonParams?: any}

export function ErrorDialog(p: ErrorDialogParamType) {
  AlertDialog.show({
    title: p.title,
    message: p.message,
    autoCancel: false,
    confirm: {
      value: $r('app.string.confirm'),
      action: () => {
        if (p.backUrl) {
          router.back({url: p.backUrl, params: p.jsonParams})
        }
      },
    }
  })
}
