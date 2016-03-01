# StackOverflowChallenge
Stackoverflow challenge is a coding challenge to retrieve stack exchange v2.2 Users api and display user details in TableView.

## Functional Details ##
It uses apimanager SOCApiRequestManager class inherited from __NSURLSession__.
Json parsing is done on separate thread usinng NSOperationQueue.
User's display name, badges and gravater are saved in CoreData object graph once.
Data is fetched from Core Data object graph using FetchedResultsController and displayed in TableView in offline/online mode.
SDWebImage is used for caching of gravatar.
Test target runs unit tests to validate response from server and loading of TableView.
Project uses CocoaPods to install SDWebImage library.
Project should be run from StackOverflowChallenge.xcworkspace rather than .xcodeproj .
Project is configured for continuous integration using Travis CI.

## Technical Details ## 
* Language: Objective-C
* OS: iOS9
* Device: iPhone 5/5s/6/6+/6s/6s+

## Third-party libraries ##
* SDWebImage
* UILoadingView

