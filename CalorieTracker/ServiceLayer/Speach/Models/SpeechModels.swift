//
//  SpeechModels.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 18.11.2022.
//

import Speech

enum SpeechRecognizerAuthorizationStatus {
    case notDetermined
    case denied
    case restricted
    case authorized
}

struct SpeechAudioBufferRecognitionRequest {
    let shouldReportPartialResults: Bool

    init(shouldReportPartialResults: Bool = true) {
        self.shouldReportPartialResults = shouldReportPartialResults
    }
}

struct SpeechRecognitionResult: Equatable {
    let bestTranscription: Transcription
    let isFinal: Bool
    let transcriptions: [Transcription]
}

struct Transcription: Equatable {
    let formattedString: String
    let segments: [TranscriptionSegment]
}

struct TranscriptionSegment: Equatable {
    let alternativeSubstrings: [String]
    let confidence: Float
    let duration: TimeInterval
    let substring: String
    let timestamp: TimeInterval
}

struct VoiceAnalytics: Equatable {
    let jitter: AcousticFeature
    let pitch: AcousticFeature
    let shimmer: AcousticFeature
    let voicing: AcousticFeature
}

struct AcousticFeature: Equatable {
    let acousticFeatureValuePerFrame: [Double]
    let frameDuration: TimeInterval
}

// MARK: - Speech framework bridge. Inits

extension SpeechRecognizerAuthorizationStatus {
    init(_ speechRecognizerAuthorizationStatus: SFSpeechRecognizerAuthorizationStatus) {
        switch speechRecognizerAuthorizationStatus {
        case .notDetermined:
            self = .notDetermined
        case .denied:
            self = .denied
        case .restricted:
            self = .restricted
        case .authorized:
            self = .authorized

        @unknown default:
            assertionFailure("Unknown case")
            self = .notDetermined
        }
    }
}

extension SFSpeechAudioBufferRecognitionRequest {
    convenience init(_ speechAudioBufferRecognitionRequest: SpeechAudioBufferRecognitionRequest) {
        self.init()
        self.shouldReportPartialResults = speechAudioBufferRecognitionRequest.shouldReportPartialResults
    }
}

extension SpeechRecognitionResult {
    init(_ speechRecognitionResult: SFSpeechRecognitionResult) {
        self.bestTranscription = Transcription(speechRecognitionResult.bestTranscription)
        self.isFinal = speechRecognitionResult.isFinal
        self.transcriptions = speechRecognitionResult.transcriptions.map(Transcription.init)
    }
}

extension Transcription {
    init(_ transcription: SFTranscription) {
        self.formattedString = transcription.formattedString
        self.segments = transcription.segments.map(TranscriptionSegment.init)
    }
}

extension TranscriptionSegment {
    init(_ transcriptionSegment: SFTranscriptionSegment) {
        self.alternativeSubstrings = transcriptionSegment.alternativeSubstrings
        self.confidence = transcriptionSegment.confidence
        self.duration = transcriptionSegment.duration
        self.substring = transcriptionSegment.substring
        self.timestamp = transcriptionSegment.timestamp
    }
}

extension VoiceAnalytics {
    init(_ voiceAnalytics: SFVoiceAnalytics) {
        self.jitter = AcousticFeature(voiceAnalytics.jitter)
        self.pitch = AcousticFeature(voiceAnalytics.pitch)
        self.shimmer = AcousticFeature(voiceAnalytics.shimmer)
        self.voicing = AcousticFeature(voiceAnalytics.voicing)
    }
}

extension AcousticFeature {
    init(_ acousticFeature: SFAcousticFeature) {
        self.acousticFeatureValuePerFrame = acousticFeature.acousticFeatureValuePerFrame
        self.frameDuration = acousticFeature.frameDuration
    }
}
