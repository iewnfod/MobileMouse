import preferences from '@ohos.data.preferences';

export const DATA_PREFERENCES_NAME = 'MobileMouseData'

export const DATA_PREFERENCE_KEYS = {
  servers: 'servers'
}

class PreferencesUtils {
  prefMap: Map<string, preferences.Preferences> = new Map()

  private checkPref(name: string): boolean {
    if (!this.prefMap.has(name)) {
      console.error(`preferences[${name}] 尚未初始化`)
      return false
    } else {
      return true
    }
  }

  async loadPreference(context, name: string) {
    try {
      const pref = await preferences.getPreferences(context, name)
      this.prefMap.set(name, pref)
      console.log(`加载 preferences[${name}] 成功`)
    } catch (e) {
      console.error(`加载 preferences[${name}] 失败`, JSON.stringify(e))
    }
  }

  async putPreferenceValue(name: string, key: string, value: preferences.ValueType) {
    if (!this.checkPref(name)) return;
    
    try {
      const pref = this.prefMap.get(name)
      await pref.put(key, value)
      await pref.flush()
      console.log(`保存 preferences[${name}] 成功`)
    } catch (e) {
      console.log(`保存 preferences[${name}] 失败`, JSON.stringify(e))
    }
  }

  async getPreferenceValue<T extends preferences.ValueType>(name: string, key: string, defaultValue: T) {
    if (!this.checkPref(name)) return;

    try {
      const pref = this.prefMap.get(name)

      const value = await pref.get(key, defaultValue)
      console.log(`读取 preferences[${name}.${key}=${value}] 成功`)
      return value
    } catch (e) {
      console.error(`读取 preferences[${name}] 失败`, JSON.stringify(e))
    }
  }

  async deletePreferenceValue(name: string, key: string) {
    if (!this.checkPref(name)) return;

    try {
      const pref = this.prefMap.get(name)
      await pref.delete(key)
      console.log(`删除 preferences[${name}] 成功`)
    } catch (e) {
      console.error(`删除 preferences[${name}] 失败`, JSON.stringify(e))
    }
  }
}

const preferenceUtils = new PreferencesUtils()

export default preferenceUtils as PreferencesUtils
