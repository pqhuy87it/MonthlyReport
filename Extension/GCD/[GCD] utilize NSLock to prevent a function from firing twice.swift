https://stackoverflow.com/questions/45202663/how-to-utilize-nslock-to-prevent-a-function-from-firing-twice

var checkOne = false
var checkTwo = false

//create the lock
let lock = NSLock()

func functionOne(){
    //async stuff
    //acquire the lock
    lock.lock()
    checkOne = true
    if checkOne == true && checkTwo == true{
        functionThree()//will only run if both functionOne and functionTwo have been completed
    }
    //release the lock
    lock.unlock()
}

func functionTwo(){
    //async stuff
    lock.lock()
    checkTwo = true
    if checkOne == true && checkTwo == true{
        functionThree()//will only run if both functionOne and functionTwo have been completed
    }
    lock.unlock()
}

func functionThree(){
    //stuff
}


override func viewDidLoad() {

    functionOne()
    functionTwo()
}

---------------------------------------------------------------------------------

var checkOne = false
var checkTwo = false

//Create a serial dispatch queue
let queue = DispatchQueue(label: "name of queue")

func functionOne(){
    //async stuff

    //Add a task to the queue, and execute it synchronously (i.e. wait for it to finish.)
    //You can also use async to execute a task asynchronously,
    //but sync is slightly more efficient unless you need it to be asynchronous.
    queue.sync {
        checkOne = true
        if checkOne == true && checkTwo == true{
            functionThree()//will only run if both functionOne and functionTwo have been completed
        }
    }
}

func functionTwo(){
    //async stuff
    queue.sync {
        checkTwo = true
        if checkOne == true && checkTwo == true{
           functionThree()//will only run if both functionOne and functionTwo have been completed
        }
    }
}

func functionThree(){
    //stuff
}


override func viewDidLoad() {

    functionOne()
    functionTwo()
}

-------------------------------------------------------------------------------------------------

class ViewController: UIViewController {

    let group = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()

        group.enter()
        functionOne()

        group.enter()
        functionTwo()

        group.notify(queue: .global(qos: .default), execute: { [weak self] in
            self?.functionThree()
        })
    }

    func functionOne() {
        //async stuff

        group.leave()
    }

    func functionTwo() {
        //async stuff

        group.leave()
    }

    func functionThree() {
        //stuff
    }
}
