
class List<T> {
    
    class Node {
        
        var value: T
        var next: Node?
        
        init(value: T) {
            self.value = value
        }
    }
    
    var head: Node?
    var tail: Node?
    
    func appendTo(head element: T) {
        if head == nil {
            head = Node(value: element)
            tail = head
        } else {
            let node = Node(value: element)
            node.next = head
            head = node
        }
    }
    
    func appendTo(tail element: T) {
        if tail == nil {
            tail = Node(value: element)
            head = tail
        } else {
            let node = Node(value: element)
            tail?.next = node
            tail = node
        }
    }
}

