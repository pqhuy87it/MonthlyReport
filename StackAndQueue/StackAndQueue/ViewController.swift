//
//  ViewController.swift
//  StackAndQueue
//
//  Created by Pham Quang Huy on 12/25/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let stack = Stack<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // test build stack
        buildStack()
        
        // test push stack
        pushStack()
        
        // test pop stack
        popStack()
        
        // test reverse string
        let str = reverseString("Hello world")
        print(str)
        
        calculateInfixExpression()
    }

    func buildStack() {
        let numberList = [1, 4, 7, 9, 10, 12, 20]
        
        for number in numberList {
            stack.push(number)
        }
        
        printStack()
    }
    
    func printStack() {
        var top = stack.top
		
        print(top.key)
        
		while top.next != nil {
            top = top.next
            print(top.key)
        }
    }
    
    func pushStack() {
        stack.push(40)
        
        printStack()
    }
    
    func popStack() {
        let item = stack.pop()!
        print(item)
    }
    
    func reverseString(_ stringInput: String) -> String {
        let stringStack = Stack<String>()
        
        for s in stringInput {
            stringStack.push(String(s))
        }
        
        var newString = ""
        var item = stringStack.top

        newString += item.key
        
        while item.next != nil {
            item = item.next
            newString += item.key
        }
        
        return newString
    }
    
    let operators = "+-*/"
    let numbers = "0123456789"
    
    func calculateInfixExpression() {
        let infixExpression = "(3*(((5-2)*(7+1))-6))"
        let resultStack = Stack<Int>()
        
        let postfixExpression = convertInfixToPostfixExpression(infixExpression)
        
        for s in postfixExpression {
            let x = String(s)
            
            if numbers.range(of: x) != nil {
                resultStack.push(Int(x)!)
            } else if operators.range(of: x) != nil {
                let number1 = resultStack.pop()!
                let number2 = resultStack.pop()!
				let result = calculate(number1: number1,
									   number2: number2,
									   _operator: x)
                resultStack.push(result)
            } else {
                
            }
        }
        
        print(resultStack.top.key)
    }
    
    func calculate(number1: Int, number2: Int, _operator: String) -> Int{
        switch _operator {
        case "+":
            return number2 + number1
        case "-":
            return number2 - number1
        case "*":
            return number2 * number1
        case "/":
            return number2 / number1
        default:
            return 0
        }
        
    }
    
    func convertInfixToPostfixExpression(_ infixExpression: String) -> String{
        let stackOperator = Stack<String>()
        var postfixExpression = ""
        
        for s in infixExpression {
            let x = String(s)
            
            if numbers.range(of: x) != nil {
                postfixExpression += x
            } else if operators.range(of: x) != nil {
                stackOperator.push(x)
            } else if x == ")" { // gap dau dong ngoac lay toan tu ra dua vao bieu thuc moi
                let _operator = stackOperator.pop()
                postfixExpression += _operator!
            } else { // dau mo ngoac bo qua
                
            }
        }
        
        return postfixExpression
    }
}

