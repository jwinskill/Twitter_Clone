// Playground - noun: a place where people can play

import UIKit

class Stack {
    
    var stackArray = [String]()
    
    func push(string: String) {
        self.stackArray.append(string)
    }
    
    func pop () -> String? {
        if !self.stackArray.isEmpty {
            var stringToReturn = self.stackArray.last
            self.stackArray.removeLast()
            return stringToReturn
        } else {
            return nil
        }
    }
    
    func peak() -> String? {
        if !self.stackArray.isEmpty {
            return self.stackArray.last
        } else {
            return nil
        }
    }
}

var snackAttack = Stack()
snackAttack.push("pringles")
snackAttack.push("oreos")
snackAttack.push("ritz crackers")

snackAttack.pop()
snackAttack.pop()
snackAttack.peak()



class Queue {
 
    var queueArray = [String]()
    
    func enqueue(stringToEnqueue : String) {
        self.queueArray.insert(stringToEnqueue, atIndex: 0)
    }
    
    func dequeue () -> String? {
        if !self.queueArray.isEmpty {
            var dequeuedString = queueArray.last
            queueArray.removeLast()
            return dequeuedString
        } else {
            return nil
        }
    }
    
    func peak() -> String? {
        if !self.queueArray.isEmpty {
            return queueArray.last
        } else {
            return nil
        }
    }
    
}

var lineUp = Queue()
lineUp.enqueue("Tea")
lineUp.enqueue("Biscuits")
lineUp.enqueue("TheQueen")

lineUp.dequeue()
lineUp.dequeue()
lineUp.peak()

