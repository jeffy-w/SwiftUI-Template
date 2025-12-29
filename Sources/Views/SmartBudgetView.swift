import Features
import SwiftUI

struct SmartBudgetView: View {
    @State private var feature = SmartBudgetFeature()

    var body: some View {
        ZStack {
            // 1. Background
            BackgroundView()

            VStack(spacing: 30) {
                // 2. Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Smart Budget Analysis")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundStyle(.white)

                    Text("Financial Overview")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 60)

                // 3. Central Glass Orb / Chart
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
                    OrbChartView()
                }
                .frame(width: 320, height: 320)

                Spacer()

                // 4. Bottom Buttons
                HStack(spacing: 12) {
                    ForEach(SmartBudgetFeature.Category.allCases) { category in
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                feature.selectCategory(category)
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: category.icon)
                                Text(category.rawValue)
                            }
                            .font(.system(size: 14, weight: .medium))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background {
                                if feature.selectedCategory == category {
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
                .padding(.bottom, 40)
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Subviews

struct BackgroundView: View {
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

struct OrbChartView: View {
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

            // Concentric Rings
            Group {
                // Outer Blue Ring
                Circle()
                    .trim(from: 0.2, to: 0.9)
                    .stroke(
                        LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .frame(width: 220, height: 220)
                    .rotationEffect(.degrees(rotateAnimation ? 360 : 0))
                    .animation(.linear(duration: 20).repeatForever(autoreverses: false), value: rotateAnimation)

                // Middle Green/Yellow Ring
                Circle()
                    .trim(from: 0.1, to: 0.7)
                    .stroke(
                        LinearGradient(colors: [.green, .yellow], startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .frame(width: 160, height: 160)
                    .rotationEffect(.degrees(rotateAnimation ? -360 : 0))
                    .animation(.linear(duration: 15).repeatForever(autoreverses: false), value: rotateAnimation)

                // Inner Purple Ring
                Circle()
                    .trim(from: 0.4, to: 0.8)
                    .stroke(
                        LinearGradient(colors: [.purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 15, lineCap: .round)
                    )
                    .frame(width: 110, height: 110)
                    .rotationEffect(.degrees(135))
            }
            .shadow(color: .white.opacity(0.1), radius: 10)

            // Central Sphere
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.white.opacity(0.8), .blue.opacity(0.3), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 40
                    )
                )
                .frame(width: 60, height: 60)
                .overlay(
                    Circle()
                        .stroke(.white.opacity(0.5), lineWidth: 1)
                )

            // Orbiting Ring (Thin)
            Ellipse()
                .stroke(.white.opacity(0.3), lineWidth: 1)
                .frame(width: 260, height: 80)
                .rotationEffect(.degrees(-30))

            // Bar Chart at Bottom
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(0..<10, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(
                            LinearGradient(
                                colors: [
                                    index % 2 == 0 ? .cyan : .pink,
                                    (index % 2 == 0 ? Color.cyan : .pink).opacity(0.3),
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 4, height: CGFloat.random(in: 20...60))
                }
            }
            .offset(y: 100)
        }
        .onAppear {
            rotateAnimation = true
        }
    }
}

#Preview {
    SmartBudgetView()
}
