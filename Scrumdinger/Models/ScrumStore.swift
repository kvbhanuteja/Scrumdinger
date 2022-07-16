//
//  ScrumStore.swift
//  Scrumdinger
//
//  Created by Bhanuteja KOTA VENKATA on 09/06/22.
//

import Foundation
import SwiftUI

class ScrumStore: ObservableObject {
    @Published var scrums: [DailyScrumModel] = []
    
    static func fileurl() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false).appendingPathComponent("Scrum.data")
    }
    
    static func loadData(completion: @escaping (Result<[DailyScrumModel], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileUrl = try fileurl()
                guard let file = try? FileHandle(forReadingFrom: fileUrl) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let data = try JSONDecoder().decode([DailyScrumModel].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func load() async throws -> [DailyScrumModel] {
        await withCheckedContinuation { continuation in
            loadData { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error as! Never)
                case .success(let data):
                    continuation.resume(returning: data)
                }
            }
        }
    }
    
    static func saveData(scrums: [DailyScrumModel], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileurl = try fileurl()
                let data = try JSONEncoder().encode(scrums)
                try data.write(to: fileurl)
                DispatchQueue.main.async {
                    completion(.success(scrums.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    @discardableResult
    static func saveData(scrums: [DailyScrumModel]) async throws -> Int {
        await withCheckedContinuation { continuation in
            saveData(scrums: scrums) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error as! Never)
                case .success(let data):
                    continuation.resume(returning: data)
                }
            }
        }
    }
}
