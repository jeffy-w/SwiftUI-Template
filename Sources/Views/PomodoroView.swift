import Features
import SwiftUI

struct PomodoroView: View {
    @State private var feature = PomodoroFeature()

    var body: some View {
        ZStack {
            // 1. Background (Reused style)
            PomodoroBackgroundView()

            VStack(spacing: 30) {
                // 2. Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Focus Timer")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundStyle(.white)

                    Text("Stay Productive")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 60)

                // 3. Central Glass Orb / Timer
                ZStack {
                    // Outer Glass Container
                    RoundedRectangle(cornerRadius: 40)
                        .fill(.white.opacity(0.05))
                        .background(.ultraThinMaterial.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 40))
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [.white.opacity(0.5), .white.opacity(0.1), .white.opacity(0.05)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)

                    // Inner Content
                    OrbTimerView(feature: feature)
                }
                .frame(width: 320, height: 320)

                Spacer()

                // 4. Controls & Session Selector
                VStack(spacing: 24) {
                    // Play/Pause Controls
                    HStack(spacing: 40) {
                        Button {
                            withAnimation {
                                feature.reset()
                            }
                        } label: {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 24))
                                .foregroundStyle(.white.opacity(0.8))
                                .frame(width: 60, height: 60)
                                .background(.white.opacity(0.1))
                                .clipShape(Circle())
                        }

                        Button {
                            withAnimation {
                                feature.toggleTimer()
                            }
                        } label: {
                            Image(systemName: feature.isActive ? "pause.fill" : "play.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(.white)
                                .frame(width: 80, height: 80)
                                .background(
                                    LinearGradient(
                                        colors: [.pink, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(Circle())
                                .shadow(color: .pink.opacity(0.4), radius: 10, x: 0, y: 5)
                        }
                    }

                    // Session Type Selector
                    HStack(spacing: 12) {
                        ForEach(PomodoroFeature.SessionType.allCases) { type in
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    feature.selectedSession = type
                                }
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: type.icon)
                                    Text(type.rawValue)
                                }
                                .font(.system(size: 14, weight: .medium))
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                                .background {
                                    if feature.selectedSession == type {
                                        Capsule()
                                            .fill(.white.opacity(0.2))
                                            .overlay(
                                                Capsule()
                                                    .stroke(.white.opacity(0.3), lineWidth: 1)
                                            )
                                    } else {
                                        Capsule()
                                            .fill(.black.opacity(0.2))
                                            .overlay(
                                                Capsule()
                                                    .stroke(.white.opacity(0.1), lineWidth: 1)
                                            )
                                    }
                                }
                                .foregroundStyle(.white)
                            }
                        }
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Subviews

struct PomodoroBackgroundView: View {
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.1)  // Dark base

            // Aurora effects
            GeometryReader { proxy in
                let size = proxy.size

                // Teal/Green light
                Ellipse()
                    .fill(Color(red: 0.0, green: 0.8, blue: 0.7).opacity(0.2))
                    .frame(width: size.width * 1.2, height: size.height * 0.6)
                    .blur(radius: 80)
                    .offset(x: -size.width * 0.3, y: -size.height * 0.2)

                // Purple/Pink light
                Ellipse()
                    .fill(Color(red: 0.6, green: 0.2, blue: 0.8).opacity(0.2))
                    .frame(width: size.width * 1.0, height: size.height * 0.5)
                    .blur(radius: 80)
                    .offset(x: size.width * 0.3, y: -size.height * 0.1)

                // Bottom glow
                Ellipse()
                    .fill(Color(red: 0.0, green: 0.5, blue: 0.8).opacity(0.15))
                    .frame(width: size.width * 1.5, height: size.height * 0.4)
                    .blur(radius: 100)
                    .offset(y: size.height * 0.4)
            }
        }
    }
}

struct OrbTimerView: View {
    var feature: PomodoroFeature
    @State private var rotateAnimation = false

    var body: some View {
        ZStack {
            // Sparkles/Stars
            ForEach(0..<15, id: \.self) { _ in
                Circle()
                    .fill(.white)
                    .frame(width: CGFloat.random(in: 1...3))
                    .offset(
                        x: CGFloat.random(in: -120...120),
                        y: CGFloat.random(in: -120...120)
                    )
                    .opacity(Double.random(in: 0.3...0.8))
            }

            // Progress Ring
            Circle()
                .stroke(.white.opacity(0.1), lineWidth: 20)
                .frame(width: 220, height: 220)

            Circle()
                .trim(from: 0, to: feature.progress)
                .stroke(
                    LinearGradient(colors: [.pink, .purple], startPoint: .top, endPoint: .bottom),
                    style: StrokeStyle(lineWidth: 20, lineCap: .round)
                )
                .frame(width: 220, height: 220)
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: feature.progress)

            // Rotating Rings (Decorative)
            Group {
                Circle()
                    .trim(from: 0.1, to: 0.6)
                    .stroke(
                        LinearGradient(colors: [.cyan, .blue], startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 2, lineCap: .round)
                    )
                    .frame(width: 260, height: 260)
                    .rotationEffect(.degrees(rotateAnimation ? 360 : 0))
                    .animation(
                        feature.isActive ? .linear(duration: 10).repeatForever(autoreverses: false) : .default,
                        value: rotateAnimation)

                Circle()
                    .trim(from: 0.4, to: 0.9)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.5), .clear], startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 1, lineCap: .round)
                    )
                    .frame(width: 180, height: 180)
                    .rotationEffect(.degrees(rotateAnimation ? -360 : 0))
                    .animation(
                        feature.isActive ? .linear(duration: 15).repeatForever(autoreverses: false) : .default,
                        value: rotateAnimation)
            }

            // Central Time Display
            VStack(spacing: 4) {
                Text(feature.timeString)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .white.opacity(0.5), radius: 10)

                Text(feature.selectedSession.rawValue)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
        .onAppear {
            rotateAnimation = true
        }
        .onChange(of: feature.isActive) { _, newValue in
            if newValue {
                rotateAnimation = true
            }
        }
    }
}

#Preview {
    PomodoroView()
}
