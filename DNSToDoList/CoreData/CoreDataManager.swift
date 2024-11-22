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
        //let request = NSFetchRequest<ToDoCoreDataModel>(entityName: String(describing: ToDoCoreDataModel.self))
        let fetchRequest: NSFetchRequest<ToDoCoreDataModel> = ToDoCoreDataModel.fetchRequest()
        
        
        return Future { promise in
            do {
                let objects = try self.coreDataStack.managedObjectContext.fetch(fetchRequest)
                let todos = objects.map {
                    ToDo(toDo: $0.toDo ?? "", description: $0.desc ?? "", status: ToDo.Status(rawValue: $0.status ?? "") ?? ToDo.Status.newToDo, dateAndTimeTheToDoWasCreated: $0.dateAndTimeTheToDoWasCreated ?? .now) }
                
                promise(.success(todos))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
        
        
    }
    
    func saveToDos(_ toDos: [ToDo]) {
        toDos.forEach { toDoToSave in
            coreDataStack.backgroundContext.perform {
                let savingToDo = ToDoCoreDataModel(context: self.coreDataStack.backgroundContext)
                savingToDo.id  = Int32(toDoToSave.id ?? 0)
                savingToDo.toDo = toDoToSave.toDo
                savingToDo.desc = toDoToSave.description
                savingToDo.status = toDoToSave.status.rawValue
                savingToDo.dateAndTimeTheToDoWasCreated = toDoToSave.dateAndTimeTheToDoWasCreated
                self.coreDataStack.saveChanges()
            }
        }
    }
}
