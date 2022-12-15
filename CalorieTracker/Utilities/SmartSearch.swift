//
//  SmartSearch.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 15.12.2022.
//

import Foundation

struct SmartSearch {
    
    private(set) var searchTokens: [String.SubSequence]
    
    init(_ searchString: String) {
        searchTokens = searchString
            .split(whereSeparator: { $0.isWhitespace })
            .sorted { $0.count > $1.count }
    }
    
    func matches(_ candidateString: String) -> Bool {
        guard !searchTokens.isEmpty else { return true }
        
        var candidateStringTokens = candidateString
            .split(whereSeparator: { $0.isWhitespace })
        
        for searchToken in searchTokens {
            var matchedSearchToken = false
            
            for (candidateStringTokenIndex, candidateStringToken) in candidateStringTokens.enumerated() {
                if let range = candidateStringToken
                    .range(
                        of: searchToken,
                        options: [.caseInsensitive, .diacriticInsensitive]
                    ),
                   range.lowerBound == candidateStringToken.startIndex {
                    matchedSearchToken = true
                    candidateStringTokens.remove(at: candidateStringTokenIndex)
                    break
                }
            }
            guard matchedSearchToken else { return false }
        }
        return true
    }
}
