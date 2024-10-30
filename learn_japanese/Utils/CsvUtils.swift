//
//  CsvUtils.swift
//  learn_japanese
//
//  Created by Hưng Hà Quang on 30/10/24.
//


import Foundation
import SwiftCSV

class CsvUtils {
    var csv: CSV<Named>?

    // Khởi tạo với đường dẫn file CSV
    init(fileName: String) {
        do {
            // Tạo đối tượng CSV từ file
            self.csv = try CSV<Named>(name: fileName)
        } catch {
            print("Error reading CSV file: \(error)")
        }
    }

    func filterRows(byColumn column: String, value: String) -> [[String: String]]? {
        guard let rows = csv?.rows else { return nil }
        return rows.filter { $0[column] == value }
    }

    // Lấy giá trị của một cột cụ thể từ hàng
    func getValue(atRow rowIndex: Int, column: String) -> String? {
        guard let rows = csv?.rows, rowIndex < rows.count else { return nil }
        return rows[rowIndex][column]
    }
}
