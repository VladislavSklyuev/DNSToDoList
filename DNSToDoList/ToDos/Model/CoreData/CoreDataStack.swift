import CoreData

final class CoreDataStack {
    
    private lazy var persistentContainer: NSPersistentContainer = {
        $0.loadPersistentStores { description, error in
            if let error {
                fatalError("Core data: \(error), \(error.localizedDescription)")
            }
        }
        return $0
    }(NSPersistentContainer(name: "DNSToDoList"))
    
    var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private(set) lazy var backgroundContext = persistentContainer.newBackgroundContext()
    
    func saveChanges() {
        backgroundContext.performAndWait {
            if backgroundContext.hasChanges {
                do {
                    try backgroundContext.save()
                } catch let error {
                    print("Core data: \(error)")
                }
            }
        }
    }
}
