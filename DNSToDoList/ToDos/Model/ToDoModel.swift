import Foundation

struct ToDo: Identifiable, Equatable {
    let id: Int
    let toDo: String
    let description: String
    var status: Status
    let dateAndTimeTheToDoWasCreated: Date
    
    // TODO: Должно быть тут?
    enum Status: String {
        case newToDo = "Новая задача"
        case inWork = "В работе"
        case completed = "Выполнена"
    }
}

extension ToDo {
    static var mock: ToDo {
        ToDo(id: 0, toDo: "Нарубить дров", description: "Взять деревья из леса, распилить их и нарубить", status: .inWork, dateAndTimeTheToDoWasCreated: Date.now)
    }
}
