# RxMyCoordinator
An example showing how to handle complex coordination using RxSwift.

There are a lot of IMHO rather complex coordination systems around that use RxSwift and I have been asked to provide an example of my own.

## Notes
* You don't need a coordinator object for every view controller. If a view controller has a view model, then it doesn't need a coordinator. You only need coordinators for view controllers that _don't_ have view models. Generally, this means Split, Tab, and Navigation controllers, but you could also use a coordinator for custom containers.

* Actually, you don't need a coordinator _object_ at all. You will see in this code I don't have any Coordinator classes or structs. Instead I simply have a function that does work.

* Testability comes with `flow`s. You will see that (almost) every coordinator has an associated flow function. Flows are to Coordinators as ViewModels are to ViewControllers. By placing the logic in a seperate function from the effects, you have a simple way to unit test your logic. This is good architecture 101. You will probably notice that I don't have a flow for all coordinators. Sometimes all the logic is in the View Models so there is nothing left for the coordinator apart from effects.

* There are lots of different ways to make flows. You will see that some flows are extensions on `ObservableType` and some are function, some return an Observable containing an `enum` while others return a Flow `struct`. This is to show the various ways to make flows.

* View Controllers know nothing about the hierarchy. Notice that view controllers have no idea how they are presented, nor do they even know which buttons will cause a transition. If you need to re-arrange or remove a view controller from a particluar presentation chain, you only need to go into the flow function and possibly the coordinator. You don't have to touch a bunch of view controllers.

* Dependencies are passed in as escaping functions. Throughout the code base, you will see that I am passing dependencies in as escaping functions instead of creating protocols. For all practical purposes, a protocol with one function is the same as an escaping function, and a protocol with _more_ than one function is probably too heavy. Remember, these dependencies should be as lightweight as possible and contain only side effects, not logic.

Lastly... I know you are going to ask, "where are the dispose bags?" I'm not using dispose bags in my coordinators because there is no sense of the coordinator being able to cancel a view presentation. Instead I wait for the view models to complete, which they will naturally do when the view controller leaves scope.

### I hope you enjoy the code and if you have any questions, by all meanss open an issue or ask me on the RxSwift slack channel.
