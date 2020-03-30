# DrdshChatSDKTest

[![CI Status](https://img.shields.io/travis/gauravgudaliya/DrdshChatSDKTest.svg?style=flat)](https://travis-ci.org/gauravgudaliya/DrdshChatSDKTest)
[![Version](https://img.shields.io/cocoapods/v/DrdshChatSDKTest.svg?style=flat)](https://cocoapods.org/pods/DrdshChatSDKTest)
[![License](https://img.shields.io/cocoapods/l/DrdshChatSDKTest.svg?style=flat)](https://cocoapods.org/pods/DrdshChatSDKTest)
[![Platform](https://img.shields.io/cocoapods/p/DrdshChatSDKTest.svg?style=flat)](https://cocoapods.org/pods/DrdshChatSDKTest)


<p align="center">
<a href="https://i.imgur.com/e1tKOoW.gif">
<img src="https://i.imgur.com/e1tKOoW.gif" height="480">
</a>
</p>



## Features

It includes such features as:


## Requirements

It includes such requirements as:


## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

``bash
$ gem install cocoapods
``

To integrate DrdshChatSDKTest into your Xcode project using CocoaPods, specify it in your ``Podfile`` :

``target '<Your Target Name>' do
pod 'DrdshChatSDKTest'
end
``

Then, run the following command:

``bash
$ pod install
``


## Usage

#### Step 1

* For access ``DrdshChatSDKTest`` you need to import Pod to your project 

``swift

    import DrdshChatSDKTest
    
    class ViewController: UIViewController {

    }
``


#### Step 2

* For open the SDK chat support you have required appSid and you need to pass that to like below with ``DrdshChatSDKConfiguration()`` object

``swift

    let sdkCongig = DrdshChatSDKConfiguration()
    sdkCongig.appSid = "5def86cf64be6d13f55f2034.5d96941bb5507599887b9c71829d5cffcdf55014"

    @IBAction func btnStartChatAction(_ sender:UIButton){
       DrdshChatSDKTest.presentChat(config: sdkCongig)
    }
``
#### Step 3

* For Open SDK you need to call below function with ``DrdshChatSDKConfiguration()`` object 

``swift
     DrdshChatSDKTest.presentChat(config: sdkCongig)
``
#### Step 4

* Below is the fully code of open SDK with dummy appSid 

``swift

    @IBAction func btnStartChatAction(_ sender:UIButton){
        let sdkCongig = DrdshChatSDKConfiguration()
        sdkCongig.appSid = "5def86cf64be6d13f55f2034.5d96941bb5507599887b9c71829d5cffcdf55014"
        DrdshChatSDKTest.presentChat(config: sdkCongig)
    }
``

#### Customize :

* This pod is easily fully customisable using ``DrdshChatSDKConfiguration()`` object  like below :

``swift

    let sdkCongig = DrdshChatSDKConfiguration()
    
    
    //if you need in Arabic langauge
    sdkCongig.local = "ar"

    //set the Background color
    sdkCongig.bgColor = "#ffffff"
    
    //set the Button Background color
    sdkCongig.buttonColor = "#6f2b91"
    
    //set the Navigation Bar color
    sdkCongig.topBarBgColor = "#6f2b91"
    
    //set the My Chat Bubble color
    sdkCongig.myChatBubbleColor = "#EEEEEE"
    
    //set the My Chat text color
    sdkCongig.myChatTextColor = "#47336b"
    
    //set the Opposite Chat Bubble color
    sdkCongig.oppositeChatBubbleColor = "#6f2b91"
    
    //set the Opposite Chat Text color
    sdkCongig.oppositeChatTextColor = "#FFFFFF"

    
``

#### Done
Thats it, you successfully integrate DrdshChatSDKTest



## Author

HTF, cto@htf.sa


### Issues

If you find an issue, please [create an issue](https://github.com/WhollySoftware/GGiOSSDK/issues).



## License

Apache License, Version 2.0. See [LICENSE](LICENSE) file.














