import Flutter
import UIKit
import AVFoundation

public class CompressorPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "video_compression", binaryMessenger: registrar.messenger())
        let instance = CompressorPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "compressVideo":
            handleCompressVideo(call, result: result)
        case "trimVideo":
            handleTrimVideo(call, result: result)
        case "exportCover":
            handleExportCover(call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func handleCompressVideo(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let inputPath = args["inputPath"] as? String,
              let outputPath = args["outputPath"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
            return
        }

        VideoCompressor.compressVideo(inputPath: inputPath, outputPath: outputPath) { compressedPath, error in
            DispatchQueue.main.async {
                if let compressedPath = compressedPath {
                    result(compressedPath)
                } else {
                    result(FlutterError(code: "COMPRESSION_FAILED", message: error?.localizedDescription, details: nil))
                }
            }
        }
    }

    private func handleTrimVideo(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let inputPath = args["inputPath"] as? String,
              let outputPath = args["outputPath"] as? String,
              let startTime = args["startTime"] as? Double,
              let endTime = args["endTime"] as? Double else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
            return
        }

        VideoCompressor.trimVideo(inputPath: inputPath, outputPath: outputPath, startTime: startTime, endTime: endTime) { trimmedPath, error in
            DispatchQueue.main.async {
                if let trimmedPath = trimmedPath {
                    result(trimmedPath)
                } else {
                    result(FlutterError(code: "TRIM_FAILED", message: error?.localizedDescription, details: nil))
                }
            }
        }
    }

    private func handleExportCover(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let inputPath = args["inputPath"] as? String,
              let outputPath = args["outputPath"] as? String,
              let coverTime = args["coverTime"] as? Double else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
            return
        }

        VideoCompressor.exportCover(inputPath: inputPath, outputPath: outputPath, coverTime: coverTime) { coverPath, error in
            DispatchQueue.main.async {
                if let coverPath = coverPath {
                    result(coverPath)
                } else {
                    result(FlutterError(code: "EXPORT_COVER_FAILED", message: error?.localizedDescription, details: nil))
                }
            }
        }
    }
}

class VideoCompressor {
    static func compressVideo(inputPath: String, outputPath: String, completion: @escaping (String?, Error?) -> Void) {
        let asset = AVURLAsset(url: URL(fileURLWithPath: inputPath))
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetMediumQuality) else {
            completion(nil, NSError(domain: "VideoCompressor", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to create export session"]))
            return
        }

        exportSession.outputURL = URL(fileURLWithPath: outputPath)
        exportSession.outputFileType = .mp4
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                completion(outputPath, nil)
            case .failed, .cancelled:
                completion(nil, exportSession.error)
            default:
                break
            }
        }
    }

    static func trimVideo(inputPath: String, outputPath: String, startTime: Double, endTime: Double, completion: @escaping (String?, Error?) -> Void) {
        let asset = AVURLAsset(url: URL(fileURLWithPath: inputPath))
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough) else {
            completion(nil, NSError(domain: "VideoCompressor", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to create export session"]))
            return
        }

        let start = CMTime(seconds: startTime, preferredTimescale: 600)
        let duration = CMTime(seconds: endTime - startTime, preferredTimescale: 600)
        let timeRange = CMTimeRange(start: start, duration: duration)

        exportSession.timeRange = timeRange
        exportSession.outputURL = URL(fileURLWithPath: outputPath)
        exportSession.outputFileType = .mp4
        exportSession.exportAsynchronously {
            switch exportSession.status {
            case .completed:
                completion(outputPath, nil)
            case .failed, .cancelled:
                completion(nil, exportSession.error)
            default:
                break
            }
        }
    }

    static func exportCover(inputPath: String, outputPath: String, coverTime: Double, completion: @escaping (String?, Error?) -> Void) {
        let asset = AVURLAsset(url: URL(fileURLWithPath: inputPath))
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true

        let time = CMTime(seconds: coverTime, preferredTimescale: 600)
        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            let uiImage = UIImage(cgImage: cgImage)
            if let data = uiImage.jpegData(compressionQuality: 0.8) {
                try data.write(to: URL(fileURLWithPath: outputPath))
                completion(outputPath, nil)
            } else {
                completion(nil, NSError(domain: "VideoCompressor", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unable to create JPEG data"]))
            }
        } catch {
            completion(nil, error)
        }
    }
}
