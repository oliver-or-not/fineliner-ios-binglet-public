// MARK: - Module Dependency

import UIKit
import AVFoundation
import Universe
import Spectrum
import Director
import AgentBase

// MARK: - Context

fileprivate let logDirector = GlobalEntity.Director.log

fileprivate typealias Constant = SoundAgentConstant

// MARK: - Body

extension GlobalEntity.Agent {

    public static let soundAgent: SoundAgentInterface = SoundAgent(
        activationLevel: .inactive
    )
}

public protocol SoundAgentInterface: GlobalEntity.Agent.Interface, Sendable {

    func getIsBackgroundMusicOn() async -> Bool
    func getIsSoundEffectOn() async -> Bool
    func getBackgroundMusicVolume() async -> Float
    func getSoundEffectVolume() async -> Float

    func setIsBackgroundMusicOn(_ isBackgroundMusicOn: Bool) async
    func setIsSoundEffectOn(_ isSoundEffectOn: Bool) async
    func setBackgroundMusicVolume(_ volume: Float) async
    func setSoundEffectVolume(_ volume: Float) async

    func playBackgroundMusic(_ key: BackgroundMusicKey) async
    func stopBackgroundMusic() async
    func pauseBackgroundMusic() async
    func recover() async
    func strongRecover() async

    func playSoundEffect(_ key: SoundEffectKey) async
}

fileprivate final actor SoundAgent: SoundAgentInterface {

    // MARK: - Reference

    private let engine = AVAudioEngine()
    private let bgmMixer = AVAudioMixerNode()
    private let sfxMixer = AVAudioMixerNode()
    private let bgmPlayer = AVAudioPlayerNode()
    // 효과음은 동시에 여러 개 재생될 수 있으니, 플레이어 노드를 풀(pool)로 여러 개 둔다.
    private var sfxChannels: [SfxChannel] = []

    private var sfxBufferCache: [String: AVAudioPCMBuffer] = [:]

    // MARK: - Constant

    nonisolated let designation: AgentDesignation = .sound

    // MARK: - State

    var activationLevel: GlobalEntity.Agent.ActivationLevel
    private var backgroundMusicState: BackgroundMusicState
    private var backgroundMusicVolume: Float
    private var playingBackgroundMusic: BackgroundMusicKey?
    private var isSoundEffectOn: Bool
    private var soundEffectVolume: Float

    // MARK: - Lifecycle

    init(
        activationLevel: GlobalEntity.Agent.ActivationLevel
    ) {
        self.activationLevel = activationLevel
        backgroundMusicState = .off
        backgroundMusicVolume = 0
        playingBackgroundMusic = nil
        isSoundEffectOn = false
        soundEffectVolume = 0

        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
    }

    // MARK: - SoundAgentInterface

    func setActivationLevel(_ activationLevel: GlobalEntity.Agent.ActivationLevel) async {
        self.activationLevel = activationLevel
        if activationLevel == .active {
            engine.attach(bgmPlayer)
            engine.attach(bgmMixer)

            engine.connect(bgmPlayer, to: bgmMixer, format: nil)
            engine.connect(bgmMixer, to: engine.mainMixerNode, format: nil)

            engine.attach(sfxMixer)
            for _ in 0..<Constant.sfxPlayerCount {
                let p = AVAudioPlayerNode()
                engine.attach(p)
                engine.connect(p, to: sfxMixer, format: nil)
                sfxChannels.append(SfxChannel(node: p))
            }
            engine.connect(sfxMixer, to: engine.mainMixerNode, format: nil)

            engine.mainMixerNode.outputVolume = 1.0
            bgmMixer.outputVolume = 0.5
            sfxMixer.outputVolume = 0.5

            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            } catch {
                await logDirector.agentLog(
                    .sound,
                    .error,
                    "Failed to set category of session. error: \(error)"
                )
            }
            do {
                try session.setActive(true)
            } catch {
                await logDirector.agentLog(
                    .sound,
                    .error,
                    "Failed to set session active. error: \(error)"
                )
            }
            if !engine.isRunning {
                do {
                    try engine.start()
                } catch {
                    await logDirector.agentLog(
                        .sound,
                        .error,
                        "Failed to start engine. error: \(error)"
                    )
                    // stop 후 재시도 1회
                    engine.stop()
                    do {
                        try engine.start()
                    } catch {
                        await logDirector.agentLog(
                            .sound,
                            .error,
                            "Failed to start engine again. error: \(error)"
                        )
                    }
                }
            }
        }
    }

    func getIsBackgroundMusicOn() async -> Bool {
        backgroundMusicState.isOnOrPaused
    }

    func getIsSoundEffectOn() async -> Bool {
        isSoundEffectOn
    }

    func getBackgroundMusicVolume() async -> Float {
        bgmMixer.outputVolume
    }

    func getSoundEffectVolume() async -> Float {
        sfxMixer.outputVolume
    }

    func setIsBackgroundMusicOn(_ isBackgroundMusicOn: Bool) async {
        /*
        guard backgroundMusicState.isOnOrPaused != isBackgroundMusicOn else {
            return
        }
        self.backgroundMusicState = isBackgroundMusicOn ? .on : .off
        let session = AVAudioSession.sharedInstance()
        // 배경음을 끄고 켤 때 효과음이 끊기는 것은 감안한다.
        if isBackgroundMusicOn { // 켜기
            do {
                try session.setActive(false)
            } catch {
                await logDirector.agentLog(
                    .sound,
                    .error,
                    "Failed to set session inactive. error: \(error)"
                )
            }
            do {
                try session.setCategory(.soloAmbient, mode: .default)
            } catch {
                await logDirector.agentLog(
                    .sound,
                    .error,
                    "Failed to set category of session. error: \(error)"
                )
            }
            do {
                try session.setActive(true)
            } catch {
                await logDirector.agentLog(
                    .sound,
                    .error,
                    "Failed to set session active. error: \(error)"
                )
            }
            if !engine.isRunning {
                do {
                    try engine.start()
                } catch {
                    await logDirector.agentLog(
                        .sound,
                        .error,
                        "Failed to start engine. error: \(error)"
                    )
                    // stop 후 재시도 1회
                    engine.stop()
                    do {
                        try engine.start()
                    } catch {
                        await logDirector.agentLog(
                            .sound,
                            .error,
                            "Failed to start engine again. error: \(error)"
                        )
                    }
                }
            }
            if let playingBackgroundMusic {
                guard let url = Bundle.module.url(
                    forResource: playingBackgroundMusic.rawValue,
                    withExtension: playingBackgroundMusic.ext
                ) else {
                    await logDirector.agentLog(
                        .sound,
                        .error,
                        "Failed to get background music URL."
                    )
                    return
                }
                do {
                    let file = try AVAudioFile(forReading: url)
                    do {
                        if let buffer = try readEntireFileToBuffer(file) {
                            await fadeBackgroundMusicVolume(from: backgroundMusicVolume, to: 0, duration: Constant.fastFadeTimeInterval)
                            bgmPlayer.stop() // 스케줄 전에 안전하게 정지
                            // 옵션 [.loops]: 버퍼가 끝나면 자동으로 처음부터 재생(무한루프)
                            bgmPlayer.scheduleBuffer(buffer, at: nil, options: [.loops], completionHandler: nil)
                            bgmPlayer.play()
                            await fadeBackgroundMusicVolume(from: 0, to: backgroundMusicVolume, duration: Constant.fadeTimeInterval)
                        } else {
                            await logDirector.agentLog(
                                .sound,
                                .error,
                                "Buffer is nil."
                            )
                        }
                    } catch {
                        await logDirector.agentLog(
                            .sound,
                            .error,
                            "Failed to read entire file to buffer. error: \(error)"
                        )
                    }
                } catch {
                    await logDirector.agentLog(
                        .sound,
                        .error,
                        "Failed to get AVAudioFile from URL. error: \(error)"
                    )
                }
            }
        } else { // 끄기
            if bgmPlayer.isPlaying {
                await fadeBackgroundMusicVolume(from: backgroundMusicVolume, to: 0, duration: Constant.fadeTimeInterval)
                bgmPlayer.stop()
            }
            do {
                // .ambient 로 전환할 것이므로 앱 외부에 비활성화 신호를 준다.
                try session.setActive(false, options: [.notifyOthersOnDeactivation])
            } catch {
                await logDirector.agentLog(
                    .sound,
                    .error,
                    "Failed to set session inactive. error: \(error)"
                )
            }
            do {
                try session.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            } catch {
                await logDirector.agentLog(
                    .sound,
                    .error,
                    "Failed to set category of session. error: \(error)"
                )
            }
            do {
                try session.setActive(true)
            } catch {
                await logDirector.agentLog(
                    .sound,
                    .error,
                    "Failed to set session active. error: \(error)"
                )
            }
            if !engine.isRunning {
                do {
                    try engine.start()
                } catch {
                    await logDirector.agentLog(
                        .sound,
                        .error,
                        "Failed to start engine. error: \(error)"
                    )
                    // stop 후 재시도 1회
                    engine.stop()
                    do {
                        try engine.start()
                    } catch {
                        await logDirector.agentLog(
                            .sound,
                            .error,
                            "Failed to start engine again. error: \(error)"
                        )
                    }
                }
            }
        }
         */
    }

    func setIsSoundEffectOn(_ isSoundEffectOn: Bool) async {
        /*
        self.isSoundEffectOn = isSoundEffectOn
         */
    }

    func setBackgroundMusicVolume(_ volume: Float) async {
        /*
        bgmMixer.outputVolume = min(max(0, volume), 1)
        backgroundMusicVolume = min(max(0, volume), 1)
         */
    }

    func setSoundEffectVolume(_ volume: Float) async {
        /*
        sfxMixer.outputVolume = min(max(0, volume), 1)
        soundEffectVolume = min(max(0, volume), 1)
         */
    }

    func playBackgroundMusic(_ key: BackgroundMusicKey) async {
        /*
        playingBackgroundMusic = key
        guard backgroundMusicState == .on else { return }
        guard let url = Bundle.module.url(forResource: key.rawValue, withExtension: key.ext) else {
            await logDirector.agentLog(
                .sound,
                .error,
                "Failed to get background music URL."
            )
            return
        }
        if !engine.isRunning {
            do {
                try engine.start()
            } catch {
                await logDirector.agentLog(
                    .sound,
                    .error,
                    "Failed to start engine. error: \(error)"
                )
                // stop 후 재시도 1회
                engine.stop()
                do {
                    try engine.start()
                } catch {
                    await logDirector.agentLog(
                        .sound,
                        .error,
                        "Failed to start engine again. error: \(error)"
                    )
                }
            }
        }
        do {
            let file = try AVAudioFile(forReading: url)
            do {
                if let buffer = try readEntireFileToBuffer(file) {
                    await fadeBackgroundMusicVolume(from: backgroundMusicVolume, to: 0, duration: Constant.fastFadeTimeInterval)
                    bgmPlayer.stop() // 스케줄 전에 안전하게 정지
                    // 옵션 [.loops]: 버퍼가 끝나면 자동으로 처음부터 재생(무한루프)
                    bgmPlayer.scheduleBuffer(buffer, at: nil, options: [.loops], completionHandler: nil)
                    bgmPlayer.play()
                    await fadeBackgroundMusicVolume(from: 0, to: backgroundMusicVolume, duration: Constant.fadeTimeInterval)
                } else {
                    await logDirector.agentLog(
                        .sound,
                        .error,
                        "Buffer is nil."
                    )
                }
            } catch {
                await logDirector.agentLog(
                    .sound,
                    .error,
                    "Failed to read entire file to buffer. error: \(error)"
                )
            }
        } catch {
            await logDirector.agentLog(
                .sound,
                .error,
                "Failed to get AVAudioFile from URL. error: \(error)"
            )
        }
         */
    }

    func stopBackgroundMusic() async {
        /*
        playingBackgroundMusic = nil
        if bgmPlayer.isPlaying {
            await fadeBackgroundMusicVolume(from: backgroundMusicVolume, to: 0, duration: Constant.fadeTimeInterval)
            bgmPlayer.stop()
        }
         */
    }

    func pauseBackgroundMusic() async {
        /*
        guard backgroundMusicState == .on else { return }
        backgroundMusicState = .paused
        guard bgmPlayer.isPlaying else { return }
        await fadeBackgroundMusicVolume(from: backgroundMusicVolume, to: 0, duration: Constant.fastFadeTimeInterval)
        bgmPlayer.pause()
         */
    }

    /// pause 상태 또는 외부의 방해(출력 경로 변경 등)로부터 회복한다.
    func recover() async {
        /*
        let session = AVAudioSession.sharedInstance()
        engine.stop()
        if backgroundMusicState.isOnOrPaused { // 켜기
            backgroundMusicState = .on
            do {
                try session.setActive(false)
            } catch {
                await logDirector.agentLog(
                    .sound,
                    .error,
                    "Failed to set session inactive. error: \(error)"
                )
            }
            do {
                try session.setCategory(.soloAmbient, mode: .default)
            } catch {
                await logDirector.agentLog(
                    .sound,
                    .error,
                    "Failed to set category of session. error: \(error)"
                )
            }
            do {
                try session.setActive(true)
            } catch {
                await logDirector.agentLog(
                    .sound,
                    .error,
                    "Failed to set session active. error: \(error)"
                )
            }
            if !engine.isRunning {
                do {
                    try engine.start()
                } catch {
                    await logDirector.agentLog(
                        .sound,
                        .error,
                        "Failed to start engine. error: \(error)"
                    )
                    // stop 후 재시도 1회
                    engine.stop()
                    do {
                        try engine.start()
                    } catch {
                        await logDirector.agentLog(
                            .sound,
                            .error,
                            "Failed to start engine again. error: \(error)"
                        )
                    }
                }
            }
            bgmPlayer.pause()
            bgmPlayer.play()
            await fadeBackgroundMusicVolume(from: 0, to: backgroundMusicVolume, duration: Constant.fadeTimeInterval)
        } else { // 배경음악이 꺼진 상태이므로, 배경음악을 켜는 것은 아니고 효과음 재생이 가능한 상태로 복구한다.
            backgroundMusicState = .off
            do {
                try session.setActive(false)
            } catch {
                await logDirector.agentLog(
                    .sound,
                    .error,
                    "Failed to set session inactive. error: \(error)"
                )
            }
            do {
                try session.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            } catch {
                await logDirector.agentLog(
                    .sound,
                    .error,
                    "Failed to set category of session. error: \(error)"
                )
            }
            do {
                try session.setActive(true)
            } catch {
                await logDirector.agentLog(
                    .sound,
                    .error,
                    "Failed to set session active. error: \(error)"
                )
            }
            if !engine.isRunning {
                do {
                    try engine.start()
                } catch {
                    await logDirector.agentLog(
                        .sound,
                        .error,
                        "Failed to start engine. error: \(error)"
                    )
                    // stop 후 재시도 1회
                    engine.stop()
                    do {
                        try engine.start()
                    } catch {
                        await logDirector.agentLog(
                            .sound,
                            .error,
                            "Failed to start engine again. error: \(error)"
                        )
                    }
                }
            }
        }
         */
    }

    /// 미디어 서비스 리셋으로부터 회복한다.
    func strongRecover() async {
        /*
        let session = AVAudioSession.sharedInstance()
        engine.stop()
        if backgroundMusicState.isOnOrPaused { // 켜기
            backgroundMusicState = .on
            do {
                try session.setActive(false)
            } catch {
                await logDirector.agentLog(
                    .sound,
                    .error,
                    "Failed to set session inactive. error: \(error)"
                )
            }
            do {
                try session.setCategory(.soloAmbient, mode: .default)
            } catch {
                await logDirector.agentLog(
                    .sound,
                    .error,
                    "Failed to set category of session. error: \(error)"
                )
            }
            do {
                try session.setActive(true)
            } catch {
                await logDirector.agentLog(
                    .sound,
                    .error,
                    "Failed to set session active. error: \(error)"
                )
            }
            if !engine.isRunning {
                do {
                    try engine.start()
                } catch {
                    await logDirector.agentLog(
                        .sound,
                        .error,
                        "Failed to start engine. error: \(error)"
                    )
                    // stop 후 재시도 1회
                    engine.stop()
                    do {
                        try engine.start()
                    } catch {
                        await logDirector.agentLog(
                            .sound,
                            .error,
                            "Failed to start engine again. error: \(error)"
                        )
                    }
                }
            }
            if let playingBackgroundMusic {
                guard let url = Bundle.module.url(
                    forResource: playingBackgroundMusic.rawValue,
                    withExtension: playingBackgroundMusic.ext
                ) else {
                    await logDirector.agentLog(
                        .sound,
                        .error,
                        "Failed to get background music URL."
                    )
                    return
                }
                do {
                    let file = try AVAudioFile(forReading: url)
                    do {
                        if let buffer = try readEntireFileToBuffer(file) {
                            await fadeBackgroundMusicVolume(from: backgroundMusicVolume, to: 0, duration: Constant.fastFadeTimeInterval)
                            bgmPlayer.stop() // 스케줄 전에 안전하게 정지
                            // 옵션 [.loops]: 버퍼가 끝나면 자동으로 처음부터 재생(무한루프)
                            bgmPlayer.scheduleBuffer(buffer, at: nil, options: [.loops], completionHandler: nil)
                            bgmPlayer.play()
                            await fadeBackgroundMusicVolume(from: 0, to: backgroundMusicVolume, duration: Constant.fadeTimeInterval)
                        } else {
                            await logDirector.agentLog(
                                .sound,
                                .error,
                                "Buffer is nil."
                            )
                        }
                    } catch {
                        await logDirector.agentLog(
                            .sound,
                            .error,
                            "Failed to read entire file to buffer. error: \(error)"
                        )
                    }
                } catch {
                    await logDirector.agentLog(
                        .sound,
                        .error,
                        "Failed to get AVAudioFile from URL. error: \(error)"
                    )
                }
            }
        } else { // 배경음악이 꺼진 상태이므로, 배경음악을 켜는 것은 아니고 효과음 재생이 가능한 상태로 복구한다.
            backgroundMusicState = .off
            do {
                try session.setActive(false)
            } catch {
                await logDirector.agentLog(
                    .sound,
                    .error,
                    "Failed to set session inactive. error: \(error)"
                )
            }
            do {
                try session.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            } catch {
                await logDirector.agentLog(
                    .sound,
                    .error,
                    "Failed to set category of session. error: \(error)"
                )
            }
            do {
                try session.setActive(true)
            } catch {
                await logDirector.agentLog(
                    .sound,
                    .error,
                    "Failed to set session active. error: \(error)"
                )
            }
            if !engine.isRunning {
                do {
                    try engine.start()
                } catch {
                    await logDirector.agentLog(
                        .sound,
                        .error,
                        "Failed to start engine. error: \(error)"
                    )
                    // stop 후 재시도 1회
                    engine.stop()
                    do {
                        try engine.start()
                    } catch {
                        await logDirector.agentLog(
                            .sound,
                            .error,
                            "Failed to start engine again. error: \(error)"
                        )
                    }
                }
            }
        }
         */
    }

    func playSoundEffect(_ key: SoundEffectKey) async {
        /*
        guard isSoundEffectOn else { return }
        guard let url = Bundle.module.url(forResource: key.rawValue, withExtension: key.ext) else {
            await logDirector.agentLog(
                .sound,
                .error,
                "Failed to get sound effect URL."
            )
            return
        }
        let cacheKey = key.rawValue
        let buffer = try? loadSfxBuffer(url: url, cacheKey: cacheKey)
        guard let buffer else { return }
        if !engine.isRunning {
            do {
                try engine.start()
            } catch {
                await logDirector.agentLog(
                    .sound,
                    .error,
                    "Failed to start engine. error: \(error)"
                )
                // stop 후 재시도 1회
                engine.stop()
                do {
                    try engine.start()
                } catch {
                    await logDirector.agentLog(
                        .sound,
                        .error,
                        "Failed to start engine again. error: \(error)"
                    )
                }
            }
        }
        let index = nextSfxChannelIndex()
        let channel = sfxChannels[index]
        channel.workCount += 1
        let player = channel.node
        player.volume = 1.0
        player.scheduleBuffer(buffer, at: nil, options: [], completionHandler: nil)
        if !player.isPlaying { player.play() }
         */
    }

    private func loadSfxBuffer(url: URL, cacheKey: String) throws -> AVAudioPCMBuffer {
        if let cached = sfxBufferCache[cacheKey] { return cached }
        let file = try AVAudioFile(forReading: url)
        guard let buffer = try readEntireFileToBuffer(file) else {
            throw SoundAgentError.failedToReadFile
        }
        sfxBufferCache[cacheKey] = buffer
        return buffer
    }

    private func readEntireFileToBuffer(_ file: AVAudioFile) throws -> AVAudioPCMBuffer? {
        let format = file.processingFormat
        let capacity = AVAudioFrameCount(file.length)
        guard let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: capacity) else { return nil }
        try file.read(into: buf)
        return buf
    }

    private func nextSfxChannelIndex() -> Int {
        var index: Int = 0
        var minimumWorkCount: Int = Int.max
        for i in 0..<sfxChannels.count {
            if sfxChannels[i].workCount <= minimumWorkCount {
                index = i
                minimumWorkCount = sfxChannels[i].workCount
            }
        }
        return index
    }

    private func fadeBackgroundMusicVolume(
        from startValue: Float,
        to endValue: Float,
        duration: TimeInterval
    ) async {
        let fps: Double = 30
        let steps = max(1, Int(duration * fps))
        bgmMixer.outputVolume = startValue
        if steps == 1 {
            bgmMixer.outputVolume = endValue
            return
        }
        for i in 1...steps {
            let t = Double(i) / Double(steps)
            let v = startValue + Float(t) * (endValue - startValue)
            bgmMixer.outputVolume = v
            try? await Task.sleep(nanoseconds: UInt64(1_000_000_000.0 / fps))
        }
        bgmMixer.outputVolume = endValue
    }

    private class SfxChannel {

        let node: AVAudioPlayerNode
        var workCount: Int

        init(node: AVAudioPlayerNode, workCount: Int = 0) {
            self.node = node
            self.workCount = workCount
        }
    }
}
