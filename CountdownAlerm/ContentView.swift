//
//  ContentView.swift
//  CountdownAlerm
//
//  Created by ryan on 2026/10/31.
//

import SwiftUI
import AlarmKit

// 请求闹钟权限
func requestAlarmPermission() async -> Bool {
    do {
        let state = try await AlarmManager.shared.requestAuthorization()
        return state == .authorized
    } catch {
        print("授权失败: \(error)")
        return false
    }
}

// 创建一个倒计时闹钟（例如 5 分钟后响铃）
func scheduleCountdownAlarm(minutes: Int) {
    // 1. 定义倒计时时长（AlarmKit 允许设置提醒前和贪睡后的时长）
    let duration = Alarm.CountdownDuration(
        preAlert: TimeInterval(minutes * 60), // 倒计时总时长
        postAlert: nil // 可选：贪睡时长
    )
    
    // 2. 配置闹钟的界面表现（标题、停止按钮等）
    let alertContent = AlarmPresentation.Alert(
        title: "倒计时结束",
        stopButton: .stopButton
    )
    let presentation = AlarmPresentation(alert: alertContent)
    
    // 3. 构建闹钟配置
    let configuration = AlarmManager.AlarmConfiguration(
        countdownDuration: duration,
        presentation: presentation
    )
    
    // 4. 调度闹钟
    Task {
        do {
            try await AlarmManager.shared.schedule(configuration)
        } catch {
            print("调度失败: \(error)")
        }
    }
}