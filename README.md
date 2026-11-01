# 简易倒计时

# 开发实践汇总

## 如何在Xcode中配置github?
- Xcode > Settings > Accounts，点左下角 +，选择Github,填写github账号和PAT（Personal Access Token)
- PAT生成：github网站 > 头像 > Settings > （左侧导航栏最下方）Developer Setting > Personal access tokens > Tokens (classic) > Generate new token


## 如何让app在手机上进行调试？
要在 iPhone 上调试你写的倒计时 App，核心是完成 Xcode 签名配置 和 iPhone 端的开发者模式与信任设置。使用免费的 Apple ID 就足够了，不需要付费开发者账号。

### 完整操作步骤
 1. 准备工作：连接与添加账号
     - 用数据线把 iPhone 连上 Mac，手机上弹出“信任此电脑”时点信任。
     - 然后打开 Xcode 菜单 Xcode > Settings > Accounts，点左下角 + 登录你的普通 Apple ID。登录后，你的账号旁会显示 (Personal Team)。

 2. 配置项目签名
    在 Xcode 左侧点击项目名称，选中你的 App Target，进入 Signing & Capabilities 标签页：
     - 勾选 Automatically manage signing。
     - 在 Team 下拉菜单中，选择你的名字 (Personal Team)。
     - 检查 Bundle Identifier，确保它是一个唯一的字符串（比如 com.你的名字.CountdownAlarm），不要用默认的 com.example 开头，否则可能签名失败。

 3. 在 iPhone 上开启开发者模式（iOS 16+ 必做）
    进入 iPhone 的 设置 > 隐私与安全性 > 开发者模式，打开开关，手机会要求重启。重启后按提示确认开启即可。如果不开启，Xcode 运行时会报错。

 4. 选择真机并运行
    在 Xcode 顶部的运行目标选择器中，把模拟器切换成你连接的 iPhone。点击运行按钮（或按 Cmd + R）。首次运行时，Mac 可能会弹窗请求钥匙串访问权限，点“允许”即可。

 5. 在 iPhone 上信任开发者证书
    App 会安装到手机，但首次点开图标时，系统会提示“未受信任的开发者”。这时需要：
     - 打开 iPhone 设置 > 通用 > VPN 与设备管理。
     - 在“开发者 App”下找到你的 Apple ID 邮箱，点击进入，选择 “信任”。
    完成后，你的倒计时 App 就能正常打开并接受 Xcode 的调试了。

### 需要注意的关键点
- 7天有效期：免费 Apple ID 签名的 App 只有 7 天有效期。到期后 App 会闪退或打不开，把手机连回 Mac，在 Xcode 里重新运行一次即可自动续期，数据不会丢失。
- 通知权限：你的倒计时 App 需要通知权限。首次运行时，手机弹出通知授权请求时，记得点“允许”，否则倒计时结束不会有任何提示。
