# Zalo Assignment

## Introduce

An iOS app written in Swift that fetch data from the [Unsplash Image API](https://unsplash.com/developers) to show [Unsplash](https://unsplash.com/)'s top popular images.
This is an assignment project with minimal required features:

- [x] Authentication
- [x] Fetch photos from the [Unsplash Image API](https://unsplash.com/developers) with **pagination**
- [x] Like/Unlike photo

## App Architecture

This application uses **MVVM** as an architecture. **MVVM** in iOS helps ViewControllers reduce the file complexity, make it more expressive to the developers and easier to maintain the app.

- **Model**: the data that the app works on, for this application, the models are UserModel, PhotoModel,... files that can be found in the model directory.
- **View**: the application user interfaces.
- **ViewModel**: handle updating views, UI's logic and data bindings from the models.

This application also that advantages of other patterns like: *delegate pattern*, *singleton patterns*. Also implemented a simple caching mechanism using Swift `Dictionary`

## Feature implementations

### Authentication

Follow the [User Authentication Workflow](https://unsplash.com/documentation/user-authentication-workflow#authorization-workflow) from Unsplash, Authentication for this app uses `ASWebAuthenticationSession` to open a webview returns a `code` after we have the `code` then we process token call the `token` API to get `access_token` that represent the logged in user.

Since `access_token` has no expiration, we don't need to handle expired token. However, we do need to store `access_token` some where to handle auto login and call others API with an `Authorization` field in the `HTTP Header`. So, we store it in iOS's `UserDefaults` - a key-value storage that is very easy to implement and use.

***Note***: It is a **very bad** practice to store `access_token` with `UserDefaults`, since this app is not going public, we can accept storing credentials with `UserDefaults`. By practices, `access_token` or any secret credentials like `password` should be store in `Keychain`. Since `UserDefaults` provides no secure to the application, and `Keychain` does provide a system encryption that protects the stored values.

### Fetch photos

Based on the [List Photos endpoint](https://unsplash.com/documentation#list-photos) , we can implement a simple fetching of list photos. The parameters are:

Name  | Value
------------- | -------------
`page`  | Page number to retrieve. (Optional; default: 1)
`per_page`  | Number of items per page. (Optional; default: 10)
`order_by`| How to sort the photos. Optional. (Valid values:  `latest`,  `oldest`,  `popular`; default:  `latest`)

In this demo app, we uses the `page` parameter to specify the page we need for pagination, `per_page` is required to be `20`, and `order_by` is set to `popular`.  For pagination, the `page` parameter increments by 1 until the response list is `< per_page`, means that we have reached the end of the list, there is no more items to be fetch, so not fetching anymore is a good idea. For pull-to-refresh, the `page` parameter is set back to `1` then we can call the API again.

We also have a simple cache mechanism implemented with `Dictionary`, for each photos, we store the pair `url`: `UIImage` in order not to have the image re-download after reuse. 

### Like/Unlike images

We use the [Like Photo endpoint](https://unsplash.com/documentation#like-a-photo) and [Unlike Photo endpoint](https://unsplash.com/documentation#unlike-a-photo) to handle liking and unliking features. The parameters are:

Name  | Value
------------- | -------------
`id`| The photo’s ID. Required.

***Note***: To have good user experience. Since an API request take time due to networking, battery conditioning and bandwidth, we should update UIs when user tap like/unlike button, then we shall proceed to send request to the API. If the response is success, we keep the UI, else we revert the UI. It is good practice for user to see the UI feedback immediately after inputs.

## Installation

1. Clone or download zip file from: [Github Repo](https://github.com/vietmy1711/ZA-assignment/) branch `main`
2. Extract zip if downloaded zip file in local machine
3. Make sure local machine has installed latest Xcode 13 and install Simulator 
4. Go to main project dictionary, open `ZA-assignment.xcodeproj`
5. Choose target Simulator, and click `Build`
6. After build succeeded, click `Run` to see on Simulator

## Requirements

- Xcode 13, MacOS Monterey
- Swift 5.0
- iOS 15.2
- An iPhone or Simulator

## Author

- Nguyen Viet My - zzvietmyzz@gmail.com
