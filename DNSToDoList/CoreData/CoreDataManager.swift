import Combine
import CoreData

protocol ToDoServiceProtocol {
    func fetchToDos() -> AnyPublisher<[ToDo], Error>
    func saveToDos(_ toDos: [ToDo])
}

final class CoreDataManager: ToDoServiceProtocol {
    
    let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func fetchToDos() -> AnyPublisher<[ToDo], Error> {
        let request = NSFetchRequest<ToDoCoreDataModel>(entityName: String(describing: ToDoCoreDataModel.self))
        
        return Future { promise in
            do {
                let objects = try self.coreDataStack.managedObjectContext.fetch(request)
                let newOb = objects.compactMap { todo -> ToDo? in
                    guard let toDo = todo.toDo,
                        let desc = todo.desc,
                        let status = todo.status,
                        let date = todo.dateAndTimeTheToDoWasCreated else { return nil }
                    return ToDo(id: Int(todo.id), toDo: toDo, description: desc, status: ToDo.Status(rawValue: status)!, dateAndTimeTheToDoWasCreated: date)
                }
                promise(.success(newOb))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func saveToDos(_ toDos: [ToDo]) {
        toDos.forEach { toDoToSave in
            let request = NSFetchRequest<NSManagedObject>(entityName: String(describing: ToDoCoreDataModel.self))
            let predicate = NSPredicate(format: "id == %d", Int32(toDoToSave.id))
            request.predicate = predicate
            let objects = try! coreDataStack.managedObjectContext.fetch(request).first
            if objects == nil {
                coreDataStack.backgroundContext.perform {
                    let savingToDo = ToDoCoreDataModel(context: self.coreDataStack.backgroundContext)
                    savingToDo.id  = Int32(toDoToSave.id)
                    savingToDo.toDo = toDoToSave.toDo
                    savingToDo.desc = toDoToSave.description
                    savingToDo.status = toDoToSave.status.rawValue
                    savingToDo.dateAndTimeTheToDoWasCreated = toDoToSave.dateAndTimeTheToDoWasCreated
                    self.coreDataStack.saveChanges()
                }
            }
        }
    }
}


