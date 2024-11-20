import Foundation
import CoreData

//final class CoreDataManager {
//    
//    let coreDataStack: CoreDataStack
//    
//    init(coreDataStack: CoreDataStack) {
//        self.coreDataStack = coreDataStack
//    }
//    
//    func fetchToDo() -> [ToDoCD] {
//        let request = NSFetchRequest<ToDoCD>(entityName: String(describing: ToDoCD.self))
//        do {
//            let objects = try coreDataStack.managedObjectContext.fetch(request)
//            return objects
//        } catch {
//            return []
//        }
//    }
//}
//
//extension CoreDataManager {
//    func save(_ toDos: ToDoEntity) {
//        toDos.todos.forEach { toDoToSave in
//            let savedToDo = fetchToDo().first
//            if savedToDo == nil {
//                coreDataStack.backgroundContext.perform {
//                    let savingToDo = ToDoCD(context: self.coreDataStack.backgroundContext)
//                    savingToDo.id  = Int32(toDoToSave.id)
//                    savingToDo.todo = toDoToSave.todo
//                    savingToDo.completed = toDoToSave.completed
//                    savingToDo.userId = Int32(toDoToSave.userId)
//                    
//                    self.coreDataStack.saveChanges()
//                }
//            }
//        }
//    }
//}
