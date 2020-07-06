//
//  LinkedList.swift
//  LinkedList
//
//  Created by Exlinct on 7/30/16.
//  Copyright © 2016 Framgia, Inc. All rights reserved.
//

import Foundation

public class LinkedList<T: Equatable> {
    // Tao node head
    private var head: Node<T> = Node<T>()
    
    // Them 1 node vao cuoi danh sach
    func addLink(_ data: T) {
        
        if (head.data == nil) {
            head.data = data
            return
        }
        
        
        // Lay node head
        var current: Node? =  head
        
        
        while (current != nil) {
            // Kiem tra xem node hien tai co tro den nil ko
            // Neu node hien tai tro den nil tuc la da o cuoi danh sach
            if current?.next == nil {
                
                let newNode: Node = Node<T>()
                
                newNode.data = data
                current!.next = newNode
                break
            }
            // Neu chua phai node cuoi danh sach lay node tiep theo de kiem tra
            else {
                current = current?.next
            }
        }
    }
    
    // Them 1 node vao vi tri index trong danh sach
    func addLinkAtIndex(_ data: T, index: Int) {
        
        //Kiem tra xem danh do co node head ko
        if (head.data == nil) {
            head.data = data
            return
        }
        
        // Bat dau duyet tu node head
        var currentNode: Node<T>? = head
        var previousNode: Node<T>?
        var currentIndex: Int = 0
        
        // Neu node hien tai khong tro den nil tuc la chua den cuoi danh sach
        while (currentNode != nil) {
            
            // kiem tra index
            if (currentIndex == index) {
                
                // tao node moi
                let newNode: Node = Node<T>()
                newNode.data = data
                
                // tro node moi link den node hien tai
                newNode.next = currentNode
                
                // kiem tra xe previous node co ton tai ko
                if let previousNode = previousNode {
                    previousNode.next = newNode
                }

                // them node moi vao vi tri dau tien gan lai head vao node moi
                if (index == 0) {
                    head = newNode
                }
                
                break
            }
            
            // luu lai node truoc do
            previousNode = currentNode
            
            // tro node hien tai den node ke tiep
            currentNode = currentNode?.next
            
            // tang index len
            currentIndex += 1
        }
    }
    
    func removeLastNode() {
        // Kiem tra xem danh do co node head ko
        if head.data == nil {
            return
        }
        
        var currentNode: Node<T>? = head
        
        // duyet mang
        while currentNode != nil {
            // lay node tiep theo cua current node
            let nextNode = currentNode?.next
            
            // kiem tra xem node tiep theo cua nextNode co nil ko, neu cos nextNode la node cuoi danh sach
            if nextNode?.next == nil {
                currentNode?.next = nil
                break
            }
            else {
                currentNode = nextNode
            }
        }
    }
    
    func removeLinkAtIndex(_ index: Int) {
        
        // Kiem tra xem danh do co node head ko
        if head.data == nil {
            return
        }
        
        var currentNode: Node<T>? =  head
        var previousNode: Node<T>?
        var currentIndex = 0
        
        
        // neu xoa node dau danh sach thi gan node tiep theo ve node dau danh sach
        if (index == 0) {
            currentNode = currentNode?.next
            head = currentNode!
            return
        }
        
        // duyet mang
        while (currentNode != nil) {
            
            // tim dc dung index
            if (currentIndex == index) {
                
                // tro next cua node truoc do vao next node hien tai
                previousNode!.next = currentNode?.next
                currentNode = nil
                break
                
            }
            
            // tro toi node tiep theo tang index
            previousNode = currentNode
            currentNode = currentNode?.next
            currentIndex += 1
            
        }
    }
    
    func printAllNode() {
        // Lấy node head
        var current: Node! = head
        
        // Duyệt mảng
        
        while current != nil {
            print("Node : \(current.data!)")
            current = current.next
        }
        
    }
}
