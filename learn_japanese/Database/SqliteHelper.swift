import Foundation
import SQLite

typealias Expression = SQLite.Expression

class SQLiteHelper {
    static let shared = SQLiteHelper()
    var db: Connection!
    
    private init() {
        guard let storeURL = Bundle.main.url(forResource: "quizDB", withExtension: "db") else {
            fatalError("Failed to locate quizDB.db in bundle.")
        }
        
        do {
            db = try Connection(storeURL.path)
        } catch {
            print("Không thể mở cơ sở dữ liệu: \(error)")
        }
    }
}
