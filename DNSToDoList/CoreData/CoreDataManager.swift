import Foundation
import CoreData

final class CoreDataManager {
    
    let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func fetchToDo() -> [ToDoCoreDataModel] {
        let request = NSFetchRequest<ToDoCoreDataModel>(entityName: String(describing: ToDoCoreDataModel.self))
        do {
            let objects = try coreDataStack.managedObjectContext.fetch(request)
            return objects
        } catch {
            return []
        }
    }
}

extension CoreDataManager {
    func save(_ toDos: [ToDoCoreDataModel]) {
        toDos.forEach { toDoToSave in
            let savedToDo = fetchToDo().first
            if savedToDo == nil {
                coreDataStack.backgroundContext.perform {
                    let savingToDo = ToDoCoreDataModel(context: self.coreDataStack.backgroundContext)
                    savingToDo.id  = Int32(toDoToSave.id)
                    savingToDo.toDo = toDoToSave.toDo
                    savingToDo.desc = toDoToSave.description
                    savingToDo.status = toDoToSave.status
                    savingToDo.dateAndTimeTheToDoWasCreated = toDoToSave.dateAndTimeTheToDoWasCreated
                    self.coreDataStack.saveChanges()
                }
            }
        }
    }
}
