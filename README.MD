# rongcloud-ios-imdemo-voicetotext

rongcloud-ios-imdemo-voicetotext 是基于融云 IMKit SDK 的语音转文字功能，使用了融云最新的 4.0 SDK。


# 使用步骤

## 参数配置

开发者需填写 `RCSConfig` 的 `Appkey` 和 `Token`，

[AppKey 获取地址](https://developer.rongcloud.cn/app/appkey/0vMK99Huzz-qw40Ybv4NDA)

[Token 获取地址](https://developer.rongcloud.cn/apitool/Mw8EsJmV43kZBugTMSAZXg)

## 前置条件

1. 开发者需要自行导入语音识别库，例如“科大讯飞”

2. 在运行项目之前，需要先执行

   ```
   pod repo update
   pod install
   ```

3. 新用户默认是空的会话列表，是无法进入会话页面的。开发者可在 [开发者后台 - 服务管理 - API 调用 - 消息服务](https://developer.rongcloud.cn/apitool/kNUDHRczlPHkECa0SJ8X3Q)  中调用对应接口给当前用户发送消息。

   发送成功后，接收方的会话列表展示此会话。

## 功能实现

发送语音消息，长按发送的语音消息点击“转文字”，使用语音识别库（需要自行集成）对语音消息中的音频数据做识别，将识别结果使用自定义的 cell 展示。


# 更多

[融云官网](https://www.rongcloud.cn/)

[融云文档](https://docs.rongcloud.cn/v3/)
