# BSFloatListView

[![CI Status](https://img.shields.io/travis/boraseoksoon@gmail.com/BSFloatListView.svg?style=flat)](https://travis-ci.org/boraseoksoon@gmail.com/BSFloatListView)
[![Version](https://img.shields.io/cocoapods/v/BSFloatListView.svg?style=flat)](https://cocoapods.org/pods/BSFloatListView)
[![License](https://img.shields.io/cocoapods/l/BSFloatListView.svg?style=flat)](https://cocoapods.org/pods/BSFloatListView)
[![Platform](https://img.shields.io/cocoapods/p/BSFloatListView.svg?style=flat)](https://cocoapods.org/pods/BSFloatListView)

<br>
<img src="https://media.giphy.com/media/65Tofr7RHme0aecQLS/giphy.gif" width=240>
<img src="https://media.giphy.com/media/443khYj7M5YEz7s9WH/giphy.gif" width=240>
<br>

<a href="http://www.youtube.com/watch?feature=player_embedded&v=Js8BUt1Rg8c
" target="_blank"><img src="http://img.youtube.com/vi/Js8BUt1Rg8c/0.jpg" 
alt="BSFloatListView" width="240" height="180" border="10" /></a>


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
iOS 10.0+ <br>
Swift 4.2 + <br>

## How to use
<br>
First things first,<br>  
<b>Step 0. import BSFloatListView</b>
<br>
<br>

<b>Step 1. Create Instance programmatically as an instance variable </b>
<br>
Declare and create instance as an instance variable as below.
<br>
BSFloatListView is only supported in a programmatical way.
<br>

```Swift
/**
* initiating floatListView instance..
/// Used to create floatList instance from nib file to return.
///
/// - warning:  Mind whether isSticky is true or false will make difference of usage. Check detail in example source.
/// - parameter observedTouchView: a targetView to react on.
/// - parameter dataList: string array to display on the list.
/// - parameter touchDetectionMode: choose recognizer type for either short tap(.short) or long press(.long)
/// - parameter isSticky: if true, rather than floating around, stick to and show floatListView on a given observedTouchView in the first parameter.
/// - returns: BSFloatListView instance
*/

private lazy var floatListView: BSFloatListView = { [unowned self] in
  let floatListView = BSFloatListView.initialization(
    on:
      observedTouchView,  // a view to stick to and to focus on.
    with:
      dataList, // data list to show in the BSFloatListView ["Java", "Swift", "Scala", "Kotlin", "C++", "Clojure"] 
    touchDetectionMode:
      touchDetectionMode, // either .short or .long. if you want long press to invoke BSFloatListView, go for .long.  
    isSticky:
      isSticky // true
    )
    
    /// a closure for which list to choose.
    floatListView.didSelectRowAtClosure = { [unowned self] indexPath in
      print("clicked at : ", indexPath.row)
    }
  return floatListView
}()
```
<br>
isSticky is important. <br>If isSticky is true, BSFloatListView just keeps staying at CGPoint(x:0, y:0) of observedTouchView you specified regardless of which location a user tapped to use BSFloatListView within the observedTouchView frame. <br>Otherwise, BSFloatListView just follows a location a user tapped within the observedTouchView frame.
<br> 

<br>
<b>Step 1. In viewDidLoad, apply readyToUse() method to get ready to show BSFloatListView.</b>
<br>
Just like below.  
<br>


```Swift
override func viewDidLoad() {
  super.viewDidLoad()

  /**
  * Ready to use BSFloatListView
  */
  floatListView.readyToUse()
}

```

<br>
<b>That's all! Just enjoy BSFloatListView! :)</b>
<br>


## Installation

BSFloatListView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BSFloatListView'
```

## Author

boraseoksoon@gmail.com

## License

BSFloatListView is available under the MIT license. See the LICENSE file for more info.
