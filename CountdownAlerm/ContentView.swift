
import Foundation
import SwiftUI

struct ContentView: View {
    private let totalDuration: TimeInterval = 60 * 60

    private let cream = Color(red: 0.96, green: 0.93, blue: 0.86)
    private let gold = Color(red: 0.89, green: 0.70, blue: 0.36)

    @State private var endDate: Date?

    var body: some View {
        ZStack {
            background

            VStack(spacing: 0) {
                header

                Spacer(minLength: 24)

                timerRing

                Spacer(minLength: 24)

                controls

                Text("给自己片刻，只做一件事。")
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundStyle(cream.opacity(0.32))
                    .padding(.top, 18)
            }
            .padding(.horizontal, 24)
            .padding(.top, 18)
            .padding(.bottom, 14)
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Sections

    private var header: some View {
        VStack(spacing: 9) {
            HStack(spacing: 8) {
                Circle()
                    .fill(gold)
                    .frame(width: 6, height: 6)

                Text("Simple Countdown Timer")
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .tracking(3)
                    .foregroundStyle(cream.opacity(0.5))
            }

            Text("简易倒计时")
                .font(.system(size: 30, weight: .semibold, design: .rounded))
                .foregroundStyle(cream)
        }
        .frame(maxWidth: .infinity)
    }

    private var timerRing: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            let remaining = remainingTime(at: context.date)

            ZStack {
                Circle()
                    .stroke(cream.opacity(0.08), lineWidth: 16)

                Circle()
                    .trim(from: 0, to: progress(for: remaining))
                    .stroke(
                        AngularGradient(
                            colors: [gold, cream, gold],
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 16, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: progress(for: remaining))

                VStack(spacing: 10) {
                    Text("剩余时间")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .tracking(3)
                        .foregroundStyle(cream.opacity(0.42))

                    Text(timeString(remaining))
                        .font(.system(size: 52, weight: .semibold, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(cream)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .contentTransition(.numericText(countsDown: true))

                    Text(statusText(for: remaining))
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .tracking(2)
                        .foregroundStyle(statusColor(for: remaining))
                }
                .padding(.horizontal, 36)
            }
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: 320)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(accessibilityText(for: remaining))
        }
    }

    private var controls: some View {
        Button(action: toggleTimer) {
            HStack(spacing: 9) {
                Image(systemName: endDate == nil ? "play.fill" : "arrow.counterclockwise")
                    .font(.system(size: 14, weight: .bold))

                Text(endDate == nil ? "开始" : "复位")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
            }
            .foregroundStyle(endDate == nil ? Color(red: 0.09, green: 0.17, blue: 0.16) : cream)
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background {
                if endDate == nil {
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [gold, Color(red: 0.78, green: 0.58, blue: 0.27)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: gold.opacity(0.25), radius: 18, y: 9)
                } else {
                    Capsule()
                        .fill(cream.opacity(0.04))
                        .overlay {
                            Capsule()
                                .stroke(cream.opacity(0.18), lineWidth: 1)
                        }
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityHint(endDate == nil ? "启动倒计时" : "停止倒计时并恢复")
    }

    private var background: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.11, blue: 0.13),
                    Color(red: 0.08, green: 0.20, blue: 0.19)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            Circle()
                .fill(gold.opacity(0.12))
                .frame(width: 380, height: 380)
                .blur(radius: 90)
                .offset(x: 180, y: -320)

            Circle()
                .fill(Color(red: 0.20, green: 0.55, blue: 0.46).opacity(0.16))
                .frame(width: 420, height: 420)
                .blur(radius: 110)
                .offset(x: -200, y: 330)
        }
        .ignoresSafeArea()
    }

    // MARK: - Timer logic

    private func toggleTimer() {
        withAnimation(.easeInOut(duration: 0.25)) {
            if endDate == nil {
                endDate = Date().addingTimeInterval(totalDuration)
            } else {
                endDate = nil
            }
        }
    }

    private func remainingTime(at date: Date) -> TimeInterval {
        guard let endDate else {
            return totalDuration
        }
        return max(0, endDate.timeIntervalSince(date))
    }

    private func progress(for remaining: TimeInterval) -> Double {
        guard endDate != nil else {
            return 1
        }
        return min(max(remaining / totalDuration, 0), 1)
    }

    private func timeString(_ remaining: TimeInterval) -> String {
        let totalSeconds = max(0, Int(ceil(remaining)))
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    private func statusText(for remaining: TimeInterval) -> String {
        guard endDate != nil else {
            return "准备开始"
        }
        return remaining > 0 ? "专注中" : "时间到"
    }

    private func statusColor(for remaining: TimeInterval) -> Color {
        guard endDate != nil else {
            return cream.opacity(0.42)
        }
        return remaining > 0 ? cream.opacity(0.62) : gold
    }

    private func accessibilityText(for remaining: TimeInterval) -> String {
        guard endDate != nil else {
            return "倒计时，准备开始"
        }
        guard remaining > 0 else {
            return "倒计时结束"
        }
        let totalSeconds = Int(ceil(remaining))
        return "剩余 \(totalSeconds / 60) 分 \(totalSeconds % 60) 秒"
    }
}

#Preview {
    ContentView()
}
