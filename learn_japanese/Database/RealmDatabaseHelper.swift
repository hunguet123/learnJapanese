import RealmSwift
import FirebaseDatabase

protocol RealmInitializable {
    init?(value: [String: Any])
}

class RealmDatabaseHelper {

    // Singleton instance
    static let shared = RealmDatabaseHelper()

    // Private initializer to ensure singleton
    private init() {}

    // Add an object to Realm
    func addObject<T: Object>(_ object: T) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(object)
            }
        } catch let error {
            print("Failed to add object: \(error.localizedDescription)")
        }
    }

    // Fetch all objects of a specific type
    func fetchObjects<T: Object>(_ objectType: T.Type) -> [T] {
        do {
            let realm = try Realm()
            print("----- realm path \(Realm.Configuration.defaultConfiguration.fileURL)")
            let results = realm.objects(objectType)
            return Array(results)
        } catch let error {
            print("Failed to fetch objects: \(error.localizedDescription)")
            return []
        }
    }

    // Delete an object from Realm
    func deleteObject<T: Object>(_ object: T) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(object)
            }
        } catch let error {
            print("Failed to delete object: \(error.localizedDescription)")
        }
    }

    // Delete all objects of a specific type from Realm
    func deleteAllObjects<T: Object>(_ objectType: T.Type) {
        do {
            let realm = try Realm()
            let objects = realm.objects(objectType)
            try realm.write {
                realm.delete(objects)
            }
        } catch let error {
            print("Failed to delete objects: \(error.localizedDescription)")
        }
    }

    // Sync data from Realm to Firebase
    func syncToFirebase<T: Object>(objectType: T.Type, toPath path: String) {
        let databaseRef = Database.database().reference(withPath: path)
        let objects = fetchObjects(objectType)
        for object in objects {
            if let dict = object.toDictionary() {
                let objectRef = databaseRef.childByAutoId()
                objectRef.setValue(dict)
            }
        }
    }

    // Sync data from Firebase to Realm
    func syncFromFirebase<T: Object & RealmInitializable>(objectType: T.Type, fromPath path: String) {
        let databaseRef = Database.database().reference(withPath: path)
        databaseRef.observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else { return }
            do {
                let realm = try Realm()
                try realm.write {
                    for dict in value {
                        if let object = T(value: dict) {
                            realm.add(object, update: .modified)
                        }
                    }
                }
            } catch let error {
                print("Failed to sync from Firebase: \(error.localizedDescription)")
            }
        }
    }
}

// Extension to convert Realm objects to dictionary
extension Object {
    func toDictionary() -> [String: Any]? {
        let properties = self.objectSchema.properties.map { $0.name }
        var dict = [String: Any]()
        for property in properties {
            dict[property] = self.value(forKey: property)
        }
        return dict
    }
}
