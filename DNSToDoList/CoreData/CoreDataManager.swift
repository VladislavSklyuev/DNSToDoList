import Combine
import CoreData

protocol ToDoServiceProtocol {
    func fetchToDos() -> AnyPublisher<[ToDo], Error>
    func saveToDos(_ toDos: [ToDo])
    func deleteToDo(withId id: Int)
    func updateTodo(_ todo: ToDo)
}

final class CoreDataManager: ToDoServiceProtocol {
    
    let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    // MARK: - Получение сущностей
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
    // MARK: - Сохранение сущностей
    func saveToDos(_ toDos: [ToDo]) {
        toDos.forEach { toDoToSave in
            let request = NSFetchRequest<ToDoCoreDataModel>(entityName: String(describing: ToDoCoreDataModel.self))
            let predicate = NSPredicate(format: "id == %d", Int32(toDoToSave.id))
            request.predicate = predicate
            do {
                let objects = try coreDataStack.backgroundContext.fetch(request).first
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
            } catch {
                print("Error saving")
            }
        }
    }
    
    // MARK: - Удаление сущностей
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
    
    // MARK: - Обновление сущностей
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
