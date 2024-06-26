import router from '@ohos.router'

export function GetStringFromResource(r: Resource) {
  return getContext().resourceManager.getStringSync(r)
}

type ErrorDialogParamType = {message: string, backUrl?: string, title? : string, jsonParams?: any}

export function ErrorDialog(p: ErrorDialogParamType) {
  const b = p.backUrl || "pages/Index"

  AlertDialog.show({
    title: p.title,
    message: p.message,
    autoCancel: false,
    confirm: {
      value: $r('app.string.confirm'),
      action: () => {
        if (b) {
          router.back({url: b, params: p.jsonParams})
        }
      },
    }
  })
}
