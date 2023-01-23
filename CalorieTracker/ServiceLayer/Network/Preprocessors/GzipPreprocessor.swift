//
//  GzipPreprocessor.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 10.08.2022.
//

import Alamofire
import Foundation

struct GzipDataPreprocessor: DataPreprocessor {
    func preprocess(_ data: Data) throws -> Data {
        guard data.isGzipped,
              let unzipped = try? data.gunzipped() else {
            return data
        }
        return unzipped
    }
}

extension DataPreprocessor where Self == GzipDataPreprocessor {
    static var gzipPreprocessor: GzipDataPreprocessor { GzipDataPreprocessor() }
}
