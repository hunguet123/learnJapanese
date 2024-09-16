import RealmSwift
import FirebaseFirestoreInternal
import FirebaseDatabase

protocol RealmInitializable {
    init?(value: [String: Any])
}

class RealmDatabaseHelper {
    
    // Singleton instance
    static let shared = RealmDatabaseHelper()
    
    // Private initializer to ensure singleton
    private init() {}
    
    private var database = Firestore.firestore()
    
    // Add an object to Realm
    func addObject<T: Object>(_ object: T) {
        do {
            let realm = try Realm()
            try realm.write {
                let primaryKey = object.value(forKey: "id") as? String
                if primaryKey?.isEmpty == true {
                    return
                }
                
                if realm.object(ofType: T.self, forPrimaryKey: primaryKey) != nil {
                    if primaryKey?.isEmpty == true {
                        return
                    }
                    
                    realm.add(object, update: .modified)
                } else {
                    realm.add(object)
                }
            }
        } catch let error {
            print("Failed to add object: \(error.localizedDescription)")
        }
    }
    
    // Fetch all objects of a specific type
    func fetchObjects<T: Object>(_ objectType: T.Type) -> [T] {
        do {
            let realm = try Realm()
            print("----- realm path \(String(describing: Realm.Configuration.defaultConfiguration.fileURL))")
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
    func syncToFirestore<T: Object>(objectType: T.Type, toCollection collectionPath: String) {
        let objects = fetchObjects(objectType)
        let collectionRef = database.collection(collectionPath)
        
        let batch = database.batch()
        
        for object in objects {
            guard let dict = object.toDictionary(), let id = dict["id"] as? String else {
                print("Failed to convert object to dictionary or missing ID")
                continue
            }
            
            if id.isEmpty == true {
                return
            }
            
            let documentRef = collectionRef.document(id)
            
            batch.setData(dict, forDocument: documentRef, merge: true)
        }
        
        batch.commit { error in
            if let error = error {
                print("Failed to sync objects to Firestore: \(error.localizedDescription)")
            } else {
                print("All objects synced to Firestore successfully.")
            }
        }
    }
    
    // Sync data from Firestore to Realm
    func syncFromFirestoreToRealm<T: Object & RealmInitializable>(objectType: T.Type, fromCollection collectionPath: String) {
        let collectionRef = Firestore.firestore().collection(collectionPath)
        
        collectionRef.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let realm = try Realm()
                try realm.write {
                    for document in documents {
                        let data = document.data()
                        let documentID = document.documentID
                        
                        if let existingObject = realm.object(ofType: objectType, forPrimaryKey: documentID) {
                            for (key, value) in data {
                                if key != "id", existingObject.value(forKey: key) != nil {
                                    existingObject.setValue(value, forKey: key)
                                }
                            }
                            
                            // Thực hiện cập nhật
                            realm.add(existingObject, update: .modified)
                            realm.add(existingObject, update: .modified)
                        } else {
                            var newData = data
                            newData["id"] = documentID
                            
                            if let newObject = T(value: newData) {
                                realm.add(newObject, update: .modified)
                            }
                        }
                    }
                }
                print("Data successfully synced from Firestore to Realm.")
            } catch let error {
                print("Failed to sync data to Realm: \(error.localizedDescription)")
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
