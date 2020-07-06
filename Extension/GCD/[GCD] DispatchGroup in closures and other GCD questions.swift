https://stackoverflow.com/questions/57324405/weak-dispatchgroup-in-closures-and-other-gcd-questions

func asyncTasksInOrder(onDone: @escaping (String?) -> Void)
{
    let thread = DispatchQueue(label: "my thread", qos: .userInteractive, autoreleaseFrequency: .workItem)
    thread.async {       

        //Get username async first
        self.getUsername { [weak self] possUsername in
            guard let self = self else { onDone(nil); return }

            //Now get bday async
            self.getBirthdate(using: possUsername) { possBday in

               //Now call the return callback
                onDone(possBday)
            } 
        }
    }
}
