//SwiftExtensions.swift
//
//Created by Preston Harrison on 2/2/16
//Copyright 2016 Inventionland, LLC. All Rights Reserved.

/* Begin Examples */

func example() {

    //Mutating/evaluating arrays

    var array = [1, 2, 3, 4, 5, 6]
    array -= 1
    
    let greaterThanThree = array.evaluateAll { $0 > 3 } /* false */
    let greaterThanOrEqualToOne = array.evaluateAll { $0 >= 1 } /* true */
    
    let field1 = UITextField()
    let field2 = UITextField()
    let field3 = UITextField()
    
    let fields = [field1, field2, field3]
    fields.forAll { $0.resignFirstResponder }
    
    
    //UISimplePicker
    
    let simplePicker = UISimplePickerView(frame: CGRect.zero, items: ["Hello", "World"])
    simplePicker.selectionHandler = { row in
    
        print("Selected row: \(row)")
    
    }
    
    
    //Int, Double
    
    let i = 4
    let b: Double = i.doubleValue()
    
    i.times {
    
        print("hello") /* prints hello 4 times */
    
    }
    
    b.after {
    
         print("hello") /* prints hello after 4.0 seconds */
    
    }
    
    
    //UIViewController
    
    let viewController = UIApplication.sharedApplication.keyWindow!.rootViewController!
    
    viewController.alert("Showing Alert", message: "Presenting UIAlertController of type Alert")
    
    /* show action sheet with image select options */
    /* delegate must conform to protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate> */
    viewController.presentImageSelectionOptions(delegate: viewController)

}

/* End Examples */

func += (inout lhs: [AnyObject], rhs: AnyObject) {

    lhs.append(rhs)

}

func -= <ObjectType: AnyObject where ObjectType: Equatable> (inout lhs: [ObjectType], rhs: ObjectType) {

    for (idx, obj) in lhs.enumerate() {
    
        if obj == rhs {
        
            lhs.removeAtIndex(idx)
            return
        
        }
    
    }

}

class UISimplePickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var items: [String] {
        
        didSet { self.pickerView.reloadAllComponents() }
        
    }
    
    var selectionHandler: (Int -> Void)?
    
    private var pickerView: UIPickerView!
    
    override init(frame: CGRect) {
        
        self.items = []
        self.pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        
        super.init(frame: frame)
        
        commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.items = []
        self.pickerView = UIPickerView(frame: aDecoder.decodeCGRectForKey("bounds"))
        
        super.init(coder: aDecoder)
        
        commonInit()
        
    }
    
    init(frame: CGRect, items: [String]) {
        
        self.items = items
        self.pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        
        super.init(frame: frame)
        
        commonInit()
        
    }
    
    private func commonInit() {
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor.clearColor()
        addSubview(pickerView)
        
    }
    
    //MARK: - Picker View
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
        
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return items.count
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return items[row]
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if let handler = selectionHandler {
            
            handler(row)
            
        }
        
    }
    
}

extension String {
    
    func length() -> Int {
        
        return characters.count
        
    }
    
    mutating func removeContentsOf(strings: [String]) {
        
        for s in strings {
            
            if containsString(s) {
                
                self = stringByReplacingOccurrencesOfString(s, withString: "")
                
            }
            
        }
        
    }
    
}

extension Array {
    
    mutating func removeWhere(predicate: Element -> Bool) {
        
        for (index, obj) in enumerate() {
            
            if predicate(obj) {
                
                removeAtIndex(index)
                removeWhere(predicate)
                
            }
            
        }
        
    }
    
    mutating func removeObject<El: Equatable>(object: El?) {
    
        for tuple in enumerate() {
            
            if tuple.element is El {
                
                if tuple.element as? El == object {
                    
                    removeAtIndex(tuple.index)
                    
                }
                
            }
            
        }
    
    }
    
    func outOfBounds(index i: Int) -> Bool {
        
        return i >= 0 && i < count
        
    }
    
    func shuffled() -> Array<Element> {
        
        if count < 3 { return self }
        
        var retarr = self
        
        for i in 0..<count {
            
            let j = Int.random() % count
            
            if i != j && !outOfBounds(index: j) {
                
                swap(&retarr[i], &retarr[j])
                
            }
            
        }
        
        return retarr
        
    }
    
    mutating func shuffleInPlace() {
        
        self = shuffled()
        
    }
    
    func evaluateAll(predicate: Element -> Bool) -> Bool {
        
        if count == 0 { return false }
        
        for (_, element) in enumerate() {
            
            if !predicate(element) {
                
                return false
                
            }
            
        }
        
        return true
        
    }
    
    func forAll(function: Element -> Void) {
        
        for (_, element) in enumerate() {
            
            function(element)
            
        }
        
    }
    
    func mutateAll(function: inout Element -> Void) {
        
        for (_, var element) in enumerate() {
            
            function(&element)
            
        }
        
    }
    
}

func + (lhs: [AnyObject], rhs: AnyObject) -> [AnyObject] {
    
    var arr = lhs
    arr.append(rhs)
    return arr
    
}

extension Double {
    
    func after(c: Void -> Void) {
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(self * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), c)
        
    }
    
    func intValue() -> Int {
        
        return Int(self)
        
    }
    
    func CGValue() -> CGFloat {
        
        return CGFloat(self)
        
    }
    
}

extension Int {
    
    static func random() -> Int {
        
        return Int(arc4random())
        
    }
    
    static func random(max val: Int) -> Int {
        
        return Int(arc4random_uniform(UInt32(val)))
        
    }
    
    func times(c: Void -> Void) {
        
        for _ in 0..<self {
            
            c()
            
        }
        
    }
    
    func times(c: Int -> Void) {
        
        for i in 0..<self {
            
            c(i)
            
        }
        
    }
    
    func doubleValue() -> Double {
        
        return Double(self)
        
    }
    
}

extension UITextField {
    
    func textExists() -> Bool {
        
        if let _ = text { return text?.characters.count > 0 } else { return false }
        
    }
    
}

extension UIViewController {
    
    func alert(title: String, message: String?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .Cancel, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func presentImageSelectionOptions(delegate del: protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>) {
        
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        controller.addAction(UIAlertAction(title: "Take Photo", style: .Default, handler: { (_) -> Void in
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = delegate
            imagePickerController.sourceType = .Camera
            imagePickerController.allowsEditing = false
            self.presentViewController(imagePickerController, animated: true, completion: nil)
            
        }))
        
        controller.addAction(UIAlertAction(title: "Choose from Gallery", style: .Default, handler: { (_) -> Void in
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = delegate
            imagePickerController.sourceType = .PhotoLibrary
            imagePickerController.allowsEditing = false
            self.presentViewController(imagePickerController, animated: true, completion: nil) 
            
        }))

        controller.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
}

extension NSDateComponents {

    class func weekdayString(fromInt: Int) -> String {
        
        switch (fromInt) {
            
        case Int.min...1: return "Sunday"
        case 2: return "Monday"
        case 3: return "Tuesday"
        case 4: return "Wednesday"
        case 5: return "Thursday"
        case 6: return "Friday"
        case 7...Int.max: return "Saturday"
            
        }
        
    }
    
    class func todayComponents() -> NSDateComponents {
        
        return NSCalendar.currentCalendar().components([.Day, .Weekday, .Month, .Year, .Hour, .Minute, .Second], fromDate: NSDate())
        
    }
    
    class func componentsForDate(date: NSDate) -> NSDateComponents {
        
        return NSCalendar.currentCalendar().components([.Day, .Weekday, .Month, .Year], fromDate: date)
        
    }
    
}
