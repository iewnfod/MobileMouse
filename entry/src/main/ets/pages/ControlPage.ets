import router from '@ohos.router'
import { Server } from '../Server'
@Entry
@Component
export default struct ControlPage {
  server: Server = router.getParams()?.['server'];
  
  build() {
    Text(this.server.address)
  }
}
