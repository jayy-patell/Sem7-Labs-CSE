/*:
## Exercise - Computed Properties and Property Observers
 
 The `Rectangle` struct below has two properties, one for width and one for height. Add a computed property that computes the area of the rectangle (i.e. width * height). Create an instance of `Rectangle` and print the `area` property.
 */
struct Rectangle {
    var width: Int
    var height: Int
    
    var area: Int{
        width*height
    }
}
var rect1=Rectangle(width: 10, height: 4)
print(rect1.area)


/*:
 In the `Height` struct below, height is represented in both inches and centimeters. However, if `heightInInches` is changed, `heightInCentimeters` should also adjust to match it. Add a `didSet` to each property that will check if the other property is what it should be, and if not, sets the proper value. If you set the value of the other property even though it already has the right value, you will end up with an infinite loop of each property setting the other.
 
 Create an instance of `Height` and then change one of its properties. Print out the other property to ensure that it was adjusted accordingly.
 */
//property observers
struct Height {
    
    var heightInInches: Double = 0 {
        willSet {
            print("About to set heightInInches to \(newValue)")
        }
        didSet {
            if heightInInches != oldValue {
            print("Changed cm height to \(heightInInches*2.54)")
            }
        }
    }
    var heightInCentimeters: Double {
        heightInInches*2.54
    }
}
var height1=Height()
height1.heightInInches=24
height1.heightInInches=32
print(height1.heightInCentimeters)




/*:
[Previous](@previous)  |  page 7 of 10  |  [Next: App Exercise - Mile Times and Congratulations](@next)
 */
