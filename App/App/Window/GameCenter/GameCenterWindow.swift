// MARK: - Module Dependency

import SwiftUI
import GameKit
import Spectrum
import Agent

// MARK: - Context

@MainActor fileprivate let primeEventDirector = GlobalEntity.Director.primeEvent

// MARK: - Body

struct GameCenterWindow: View {

    // MARK: - Reference

    @Bindable var windowModel: GameCenterWindowModel

    // MARK: - Constant

    // MARK: - State

    @State private var presenter: UIViewController?

    @State private var authenticationVc: UIViewController?
    @State private var gameCenterVc: GKGameCenterViewController?

    @State private var coordinator: Coordinator?

    @State private var isAuthenticateHandlerRegistered = false

    // MARK: - View

    var body: some View {
        ZStack {
            Color.clear

            ViewControllerPresenter { vc in
                presenter = vc
            }
            .frame(width: 0, height: 0)
            .allowsHitTesting(false)
        }
        .onChange(of: windowModel.gameCenterGraphicInterfaceRequestSignal) { _, _ in
            presentGameCenterIfNeeded()
        }
        .onAppear {
            guard !isAuthenticateHandlerRegistered else { return }
            isAuthenticateHandlerRegistered = true
            registerAuthenticateHandler()
        }
    }
}

private extension GameCenterWindow {

    @MainActor
    func presentGameCenterIfNeeded() {
        guard
            let presenter,
            gameCenterVc == nil,
            authenticationVc == nil
        else { return }

        let coordinatorInStack = Coordinator(
            onFinish: {
                Task { @MainActor in
                    dismissGameCenterIfNeeded()
                }
            }
        )
        let gameCenterVcInStack = GKGameCenterViewController()
        gameCenterVcInStack.gameCenterDelegate = coordinatorInStack

        coordinator = coordinatorInStack
        gameCenterVc = gameCenterVcInStack
        presenter.present(gameCenterVcInStack, animated: true)
    }

    @MainActor
    func dismissGameCenterIfNeeded() {
        gameCenterVc?.dismiss(animated: true)
        gameCenterVc = nil
        coordinator = nil
    }
}

private final class Coordinator: NSObject, GKGameCenterControllerDelegate {

    let onFinish: () -> Void

    init(onFinish: @escaping () -> Void) {
        self.onFinish = onFinish
    }

    func gameCenterViewControllerDidFinish(
        _ gameCenterViewController: GKGameCenterViewController
    ) {
        onFinish()
    }
}

private extension GameCenterWindow {

    @MainActor
    func registerAuthenticateHandler() {
        let player = GKLocalPlayer.local

        player.authenticateHandler = { viewController, error in
            Task { @MainActor in
                guard let presenter else { return }

                // 시스템이 요구한 인증 UI가 있는 경우.
                if let vc = viewController {
                    self.authenticationVc = vc
                    presenter.present(vc, animated: true)
                    return
                } else {
                    // 인증 완료 or 실패.
                    authenticationVc?.dismiss(animated: true)
                    authenticationVc = nil
                }
            }
        }
    }
}
