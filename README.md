# Verifying a phone number in Swift with Nexmo's API! 

In this tutorial you learn how to verify a user's phone number Nexmo's API.

# Overview - what are we going to learn and build

While Nexmo supports verification with both SMS & Push Notification, we will focus exclusively on SMS verification here. We'll throw in a link for verification via Push Notification down at the bottom!

In terms of SMS verification alone there are two ways to integrate Nexmo into your iOS app. You can integrate Nexmo verification through its iOS SDK or through its API. Since verification throught its iOS SDK is straightforward, we'll focus on its API.  

In this tutorial you will learn how to program requests for hitting two of Nexmo's API endpoints with Alamofire. 

# Before you begin - prerequisites  

## Nexmo Setup
You need to setup an account with Nexmo. You can start the sign up here: https://dashboard.nexmo.com/sign-up

1. Create an account 
2. Make an app for Verify
3. Grab your `applicationId` & `sharedSecretKey` 

> Note: The `applicationId` & `sharedSecretKey` display differently in different browsers. In Safari the `applicationID` & `sharedSecretKey` display **after** pressing a `+` sign next to the app's name; in Firefox, however, there is no need to press a `+` sign, since both of these details display automatically. Let us know what happens in Chrome or Opera! 

![alt text](/Users/applocalization/Desktop/YourApps_in_Safari.png)

## Environment setup 

- Download the starter project, a single view application called memo: 
``` 
git clone https://www.github.com/ericgiannini/memo.git
```

- Add a CocoaPods file to its root directory, and install the pod after modifying its podfile to include the following: 

```
platform :ios, '10.0'
   use_frameworks!
   target 'memo' do
      pod 'Alamofire'
   end
```

- Make sure to have an iPhone with a SIM card handy

> Note: If you are unfamiliar with Xcode, then try out Apple's own **Intro to App Development with Swift**: https://itunes.apple.com/us/book/intro-to-app-development-with-swift/

#Building the UI

With the setup out of the way let's focus on building the user interface for verification. 

1. Add a ViewController to the start project's `Main.storyboard`. 

2. Add a CocoaTouch file called VerifyViewController that is a subclass of UIViewController; assign this scene to VerifyViewController as its custom class. 

3. Add a TextField, control dragging from it to VerifyViewController to create an outlet called `inputNumberTextField`.

4. Add a Button, control dragging from it to the VerifyViewController to create an action called `verifyTelephoneNumber`. 

5. Add a Button, control dragging from it to the PinViewController to create an action called `verifyPin`. 

6. Finally, control drag from the VerifyViewController's yellow circle of life to the starter code's NotesController, creating a segue called `presentNotes`. 

> Note: You are free to set the constraints for the TextFields, Buttons, or Labels however you would like! 


# Programming the UI: 

Nexmo's API for verification is two links. The first one is: https://api.nexmo.com/verify/json. This link verifies the user's telephone number. The second link is: https://api.nexmo.com/verify/check/json. This link verifies that the user is in possession of the device by sending an SMS with a pin. To hit these two API endpoints we will use an SDK called `Alamofire`.

### First Link : Telephone Number 

1. At the top of `VerificationViewController` include the following lines: `import Alamofire`. 
2. Within the scope of `VerificationViewController`'s class declaration add the following line: `var responseId = String()`. We are empty initiliazing a string where we will hold a reference to our `responseId`.
3. In the `@IBAction` for `verifyTelephoneNumber` add the following line: `self.verifyViaAPI()`, which is a function we will program to hit the first link. 
4. Create a function called `verifyViaAPI()` with the following code: 
 
```Swift
    func verifyViaAPI()
    {
        //Sending SMS
        let param = ["api_key": "15e6e999",
                     "api_secret": "40dc484c5365259f",
                     "number": inputTextField.text!,
                     "brand": "Notes"]
        
        Alamofire.request("https://api.nexmo.com/verify/json", parameters: param).responseJSON { response in
            
            print("--- Sent SMS API ----")
            print("Response: \(response)")
            
            if let json = response.result.value as? [String:AnyObject] {
                
                self.responseId = json["request_id"] as! String
            }
        }
    }
```
Inside of the body of the function we program the four required parameters for hitting the API endpoint, capturing the telephone number the user punches into the `inputTextField`. We pass that into the parameters along with the `api_key` & `api_secret` that we grabbed earlier. 

After the call is made, we analyze the response data to parse out the response request. We save the parsed value of `json["request_id"]` as a `String` value in our `responseId`. 

### Second Link : SMS 

1. In the `@IBAction` for `verifyPin` add the following line: `self.verifyPinViaAPI()`, which is a function we will program to hit the second link. 
2. Create a function called `verifyPinViaAPI()` with the following code: 

```Swift
func verifyPinViaAPI() {
        let param = ["api_key": "15e6e999",
                      "api_secret": "40dc484c5365259f",
                      "request_id": self.responseId,
                      "code": inputTextField.text!]
        
        Alamofire.request("https://api.nexmo.com/verify/check/json", parameters: param).responseJSON { response in
            
            print("--- Verify SMS API ----")
            print("Response: \(response)")
            
            if let json = response.result.value as? [String:AnyObject] {
                print(json)

                var status = Int()
                status = Int(json["status"] as! String)!
                print(status)
                
                if status == 0 {
                    self.performSegue(withIdentifier: "presentNotes", sender: nil)
                    
                    
                }
                
            }
            
        }
    }
```
The code is similiar to the first request. In this code snippet we parse the response for a successful verification. If the status returned in the response is zero, we present the user with his or her notes. If not, then the user must start all over again. 

### Testing 

The user inputs his or her telephone number into the text field, pressing the button to verify. If all goes well, the user receives a text message on their phone; the text message contains the pin. The user inputs the pin into the text field, pressing the button to verify the pin. If the verification is successful, the users' notes appear.


# Conclusion - What's been achieved and learned?

You now have a verified number & double checked that your user is in possession of the device's number and you do this with Nexmo's API! You built a User Interface for verification & your programmed it and you hit two of Nexmo's API endpoints with Alamofire in Swift! 

With this implementation you only know from the client side that the number is verified. In a real world app, you would need to tell your backend that the number is verified. You could accomplish that in two ways. Either calling that update on the success flow from the client. Or your own callbacks.

If you struggled with any aspect of the code, then you can download the completed project [here](https://www.dropbox.com/s/b0x9hcun7b0021p/memo%202.zip?dl=0).

> Much of the code is not programmed defensively to prevent bugs. Imagine, for instance, a user who forgets to enter his or her area code in the `inputTextField` but presses the `Verify` button anyway. Imagine the user presses the button without any text at all in the label, let alone numbers. How would you program this button defensively? How would you program the other button defensively? 

# What's next? 

Congratulations! You're all set now for SMS verification. If you want to push ahead to a more complex integration with Push Notifications, then check out these [docs](https://docs.nexmo.com/verify/verify-sdk-for-iOS/integrating-push)! 





