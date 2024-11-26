import Combine
import CoreData

final class CoreDataManager: ToDoServiceProtocol {
    
    private let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    // MARK: - Получение задач
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
}

extension CoreDataManager {
    // MARK: - Сохранение задач
    func saveToDo(_ toDo: ToDo) {
            let request = NSFetchRequest<ToDoCoreDataModel>(entityName: String(describing: ToDoCoreDataModel.self))
            let predicate = NSPredicate(format: "id == %d", Int32(toDo.id))
            request.predicate = predicate
            do {
                let object = try coreDataStack.backgroundContext.fetch(request).first
                if object == nil {
                    coreDataStack.backgroundContext.perform {
                        let savingToDo = ToDoCoreDataModel(context: self.coreDataStack.backgroundContext)
                        savingToDo.id  = Int32(toDo.id)
                        savingToDo.toDo = toDo.toDo
                        savingToDo.desc = toDo.description
                        savingToDo.status = toDo.status.rawValue
                        savingToDo.dateAndTimeTheToDoWasCreated = toDo.dateAndTimeTheToDoWasCreated
                        self.coreDataStack.saveChanges()
                    }
                }
            } catch {
                print("Error saving")
            }
        
    }
    
    // MARK: - Удаление задач
    func deleteToDo(withId id: Int) {
        let request = NSFetchRequest<ToDoCoreDataModel>(entityName: String(describing: ToDoCoreDataModel.self))
        let predicate = NSPredicate(format: "id == %d", Int32(id))
        request.predicate = predicate
        
        do {
            let results = try coreDataStack.backgroundContext.fetch(request)
            
            if let itemToDelete = results.first {
                coreDataStack.backgroundContext.delete(itemToDelete)
                coreDataStack.saveChanges()
                print("Item with ID \(id) deleted successfully.")
            } else {
                print("No item found with ID \(id).")
            }
        } catch {
            print("Error fetching or deleting item: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Обновление задач
    func updateTodo(_ todo: ToDo) {
        let request = NSFetchRequest<ToDoCoreDataModel>(entityName: String(describing: ToDoCoreDataModel.self))
        let predicate = NSPredicate(format: "id == %d", Int32(todo.id))
        request.predicate = predicate
        
        do {
            let results = try coreDataStack.backgroundContext.fetch(request)
            if let toDoEntity = results.first {
                toDoEntity.status = todo.status.rawValue
                coreDataStack.saveChanges()
                print("Обновление сущности успешно")
            }
        } catch {
            print("Ошибка при обновлении: \(error.localizedDescription)")
        }
    }
}
