import Foundation

struct ToDo: Identifiable {
    var id: Int?
    let toDo: String
    let description: String
    let status: Status
    let dateAndTimeTheToDoWasCreated: Date
    
    // TODO: Должно быть тут?
    enum Status: String {
        case newToDo = "Новая задача"
        case inWork = "В работе"
        case completed = "Выполнена"
    }
}



extension ToDo {
    static let mock: [ToDo] = [
        ToDo(toDo: "Нарубить дров", description: "Взять деревья из леса, распилить их и нарубить", status: .inWork, dateAndTimeTheToDoWasCreated: Date.now),
        ToDo(toDo: "Сходить в магазин", description: "Купить: молоко, яйца, сыр, колбасу, квас, картошку, хлеб", status: .inWork, dateAndTimeTheToDoWasCreated: Date.now),
        ToDo(toDo: "Погулять с собакой", description: "Надеть ошейник собаке, пристегнуть поводок и выйти на улицу", status: .completed, dateAndTimeTheToDoWasCreated: Date.now),
        ToDo(toDo: "Полить цветы", description: "Взять кувшин и пройтись по комнатам наливая воду в цветочные горшки", status: .newToDo, dateAndTimeTheToDoWasCreated: Date.now),
        ToDo(toDo: "Посмотреть фильм", description: "Фильмы на выбор: Начало, Матрица, Собачье сердце", status: .completed, dateAndTimeTheToDoWasCreated: Date.now)
    ]
}
