// Playground - noun: a place where people can play

import UIKit

func changeMessageBgColor(bgColorName: String) {
    var yellowColor: UIColor = UIColor(red: 250/255, green: 210/255, blue: 50/255, alpha: 1)
    var brownColor: UIColor = UIColor(red: 216/255, green: 166/255, blue: 117/255, alpha: 1)
    var greenColor: UIColor = UIColor(red: 112/255, green: 217/255, blue: 98/255, alpha: 1)
    var redColor: UIColor = UIColor(red: 235/255, green: 84/255, blue: 51/255, alpha: 1)
    switch bgColorName {
    case "yellow":
        println("yellowColor \(yellowColor)")
    case "red":
        println("redColor \(redColor)")
    default:
       println("just be grey, ok?")
    }
}

func justPrint() {
    println("justPrint!")
}


func myFunction (newNumber: Int, completion: () -> Void) {
    completion()
}

myFunction(3) { () -> Void in
   justPrint()
}

func justPush() {
    println("justPush!")
}