/*:
## Exercise - Methods
 
 A `Book` struct has been created for you below. Add an instance method on `Book` called `description` that will print out facts about the book. Then create an instance of `Book` and call this method on that instance.
 */
struct Book {
    var title: String
    var author: String
    var pages: Int
    var price: Double
    
    init(title: String, author: String, pages: Int, price: Double){
        self.title=title
        self.author=author
        self.pages=pages
        self.price=price
    }
    
    func description(){
        print("Details: \(title) \(author) \(pages) \(price)")
    }
    
}
var b1 = Book(title:"Hari Puttar",author:"JK",pages:200,price:99.9)
b1.description();


//:  A `Post` struct has been created for you below, representing a generic social media post. Add a mutating method on `Post` called `like` that will increment `likes` by one. Then create an instance of `Post` and call `like()` on it. Print out the `likes` property before and after calling the method to see whether or not the value was incremented.
struct Post {
    var message: String
    var likes: Int
    var numberOfComments: Int
    
    init(message: String, likes: Int, numberOfComments: Int){
        self.message=message
        self.likes=likes
        self.numberOfComments=numberOfComments
    }
    
    mutating func increment(){
        likes+=1
    }

}
var p1=Post(message: "hello", likes: 21, numberOfComments: 2)
print(p1.likes)
p1.increment()
print(p1.likes)


/*:
[Previous](@previous)  |  page 5 of 10  |  [Next: App Exercise - Workout Functions](@next)
 */
