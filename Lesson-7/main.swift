import Foundation

struct Credentials {
    let fio: String
    let pin: Int
    var money: Double
}

class CashMachine {
    var bank = [
        "Иванов Иван Иванович": Credentials(fio: "Иванов Иван Иванович", pin: 1111, money: 100),
        "Сидоров Сидор Сидорович": Credentials(fio: "Сидоров Сидор Сидорович", pin: 2222, money: 200),
        "Петров Петор Петрович":Credentials(fio: "Петров Петор Петрович", pin:3333, money: 300)
    ]
    
    
    func moneyTakeOff(person fio: String, pin: Int, cash: Double) -> Credentials? {
        
        let depositChange: Double = cash
        
        guard let cred = bank[fio] else {
            return nil
        }
        
        guard cred.pin == pin else {
            return nil
        }
        
        guard cred.money >= depositChange else {
            return nil
        }
        
        var ourmoney = cred
        ourmoney.money -= depositChange
        bank[fio] = ourmoney
        print("Остаток на счете \(ourmoney.money)")
        return bank[fio]
    }
}

let cashMachine = CashMachine()
cashMachine.moneyTakeOff(person: "Иванов Иван Иванович", pin: 1111, cash: 510)
cashMachine.moneyTakeOff(person: "Сидоров Сидор Сидорович", pin: 1111, cash: 510)
cashMachine.moneyTakeOff(person: "Иванов Иван Иванович", pin: 1211, cash: 510)

enum CashMachineError: Error {
    
    case invalidFio
    case invalidPin
    case outOfMoney
    
    var Descriprion: String {
        switch self {
        case .invalidFio:
            return "Неверное ФИО"
        case .invalidPin:
            return "Неверный PIN"
        case .outOfMoney:
        return "Недостаточно денег на счете"
        }
    }
}

extension CashMachine {
    func correctMoneyTakeOff(person fio: String, pin: Int, cash: Double) throws -> Credentials? {
        
        let depositChange: Double = cash
        
        guard let cred = bank[fio] else {
            throw CashMachineError.invalidFio
        }
        
        guard cred.pin == pin else {
            throw CashMachineError.invalidPin
        }
        
        guard cred.money >= depositChange else {
            throw CashMachineError.outOfMoney
        }
        
        var ourmoney = cred
        ourmoney.money -= depositChange
        bank[fio] = ourmoney
        print("Остаток на счете \(ourmoney.money)")
        return bank[fio]
    }
}

do {
    let take = try cashMachine.correctMoneyTakeOff(person: "Иванов Иван Иванович", pin: 1111, cash: 510)
} catch CashMachineError.invalidPin {
    print("Неверный PIN")
} catch CashMachineError.outOfMoney {
    print("Недостаточно денег на счете")
} catch let error {
    print(error)
}
