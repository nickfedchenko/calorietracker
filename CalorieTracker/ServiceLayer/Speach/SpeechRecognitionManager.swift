//
//  SpeechClient+Live.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 18.11.2022.
//

import Speech

enum SpeechRecognitionManagerError: Error {
    case couldntConfigureAudioSession
    case unsuportedLocale
    case taskError
    case couldntStartAudioEngine
}

actor SpeechRecognitionManager {
    func start(request: SpeechAudioBufferRecognitionRequest) -> AsyncThrowingStream<SpeechRecognitionResult, Error> {
        return AsyncThrowingStream { continuation in
            guard configureAudioSession() else {
                continuation.finish(throwing: SpeechRecognitionManagerError.couldntConfigureAudioSession)
                return
            }

            guard let speechRecognizer = makeSpeechRecognizer() else {
                continuation.finish(throwing: SpeechRecognitionManagerError.unsuportedLocale)
                return
            }

            let request = SFSpeechAudioBufferRecognitionRequest(request)
            let task = speechRecognizer.recognitionTask(with: request) { result, error in
                switch (result, error) {
                case let (.some(result), _):
                    continuation.yield(SpeechRecognitionResult(result))
                case (_, .some):
                    continuation.finish(throwing: SpeechRecognitionManagerError.taskError)
                case (.none, .none):
                    assertionFailure("It should not be possible to have both a nil result and nil error.")
                }
            }

            guard let audioEngine = makeAudioEngine(block: { buffer, _ in
                request.append(buffer)
            }) else {
                continuation.finish(throwing: SpeechRecognitionManagerError.couldntStartAudioEngine)
                return
            }

            continuation.onTermination = { _ in
                _ = speechRecognizer
                audioEngine.stop()
                audioEngine.inputNode.removeTap(onBus: Consts.inputNodeBus)
                task.finish()
            }

            self.audioEngine = audioEngine
            self.recognitionTask = task
        }
    }

    func finish() {
        audioEngine?.stop()
        audioEngine?.inputNode.removeTap(onBus: Consts.inputNodeBus)
        recognitionTask?.finish()

        audioEngine = nil
        recognitionTask = nil
    }

    func set(locale: Locale) {
        self.locale = locale
    }

    static func requestAuthorization() async -> SpeechRecognizerAuthorizationStatus {
        await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: SpeechRecognizerAuthorizationStatus(status))
            }
        }
    }

    // MARK: - Private

    private enum Consts {
        static let inputNodeBus: AVAudioNodeBus = 0
        static let inputNodeBufferSize: AVAudioFrameCount = 1024
    }

    private var audioEngine: AVAudioEngine?
    private var recognitionTask: SFSpeechRecognitionTask?

    private var locale: Locale = Locale.current

    private func configureAudioSession() -> Bool {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            return true
        } catch {
            return false
        }
    }

    private func makeSpeechRecognizer() -> SFSpeechRecognizer? {
        let speechRecognizer = SFSpeechRecognizer(locale: self.locale)
        return speechRecognizer
    }

    private func makeAudioEngine(block tapBlock: @escaping AVAudioNodeTapBlock) -> AVAudioEngine? {
        let audioEngine = AVAudioEngine()

        let outputFormat = audioEngine.inputNode.outputFormat(
            forBus: Consts.inputNodeBus
        )
        audioEngine.inputNode.installTap(
            onBus: Consts.inputNodeBus,
            bufferSize: Consts.inputNodeBufferSize,
            format: outputFormat,
            block: tapBlock
        )

        audioEngine.prepare()

        do {
            try audioEngine.start()
        } catch {
            return nil
        }
        
        return audioEngine
    }
}
