// MARK: - Module Dependency

import AVFAudio
import Combine
import SwiftUI
import Spectrum
import Agent
import Director
import Plate
import PrimeEvent

// MARK: - Context

@MainActor fileprivate let primeEventDirector = GlobalEntity.Director.primeEvent
fileprivate let logDirector = GlobalEntity.Director.log

// MARK: - Body

@main
struct AppApp: App {

    private let primeEventSubscriber = PrimeEventSubscriber()
    @State private var appearanceModel = AppAppearanceStateModel.shared
    @State private var isRunning = false

    init() {
        primeEventSubscriber.start()

        NotificationCenter.default.addObserver(
            forName: AVAudioSession.interruptionNotification,
            object: nil,
            queue: .main
        ) { notification in
            guard
                let info = notification.userInfo,
                let typeRaw = info[AVAudioSessionInterruptionTypeKey] as? UInt,
                let type = AVAudioSession.InterruptionType(rawValue: typeRaw)
            else { return }

            switch type {
            case .began:
                Task { @MainActor in
                    await primeEventDirector.receive(.audioSessionInterruptionBegan)
                }
            case .ended:
                Task { @MainActor in
                    await primeEventDirector.receive(.audioSessionInterruptionEnded)
                }
            @unknown default: break
            }
        }

        NotificationCenter.default.addObserver(
            forName: AVAudioSession.routeChangeNotification,
            object: AVAudioSession.sharedInstance(),
            queue: .main
        ) { note in
            Task { @MainActor in
                await primeEventDirector.receive(.audioSessionRouteChanged)
            }
        }

        NotificationCenter.default.addObserver(
            forName: AVAudioSession.mediaServicesWereResetNotification,
            object: AVAudioSession.sharedInstance(),
            queue: .main
        ) { _ in
            Task { @MainActor in
                await primeEventDirector.receive(.audioSessionMediaServicesWereReset)
            }
        }

        Task { @MainActor in
            await primeEventDirector.receive(.appLaunched)
        }
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                PlateStackWindow(windowModel: PlateStackWindowModel.shared)
#if DEBUG
                LogWindow(windowModel: LogWindowModel.shared)
                PrimeEventWindow(windowModel: PrimeEventWindowModel.shared)
                ObservationToggleWindow()
#endif
                ShareWindow(windowModel: ShareWindowModel.shared)
                GameCenterWindow(windowModel: GameCenterWindowModel.shared)
            }
            .preferredColorScheme(
                {
                    switch appearanceModel.colorScheme {
                    case .unspecified: .none
                    case .light: .light
                    case .dark: .dark
                    }
                }()
            )
            .onAppear {
                isRunning = true
                Task {
                    await runLoop()
                }
            }
            .onDisappear {
                isRunning = false
            }
        }
    }

    private func runLoop() async {
        while isRunning {
            await primeEventDirector.receive(.timeElapsed(now: Date.now))
            try? await Task.sleep(nanoseconds: 8_333_333) // 약 1/120초
        }
    }
}
