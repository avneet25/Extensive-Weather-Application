# Amazing-Weather-App

NewsApp is an iOS mobile application designed to bring up-to-date news to the user based on their personalised choice in language, country(s) and categories.
<br/> - Complete: User selection in various categories integrated with API response
<br> - Pending: WebView of extended article, Bookmarking favourite/certain articles for future reference

# 🚩 Table of contents
1. [App Screenshots](#part1)
2. [Features and Libraries used](#part2)
3. [What I have Learnt](#part3)

## App Screenshots <a name="part1"></a>

<img width="250" alt="Screen Shot 2022-02-04 at 2 48 01 PM" src="https://user-images.githubusercontent.com/82283086/153292267-f7ffdc4d-fbad-44df-9144-72278f867d07.png"><img width="250
" alt="Screen Shot 2022-02-04 at 2 48 01 PM" src="https://user-images.githubusercontent.com/82283086/153292272-fcff5747-5bfc-4a76-8f6e-19d83fd89f32.png"><img width="250
" alt="Screen Shot 2022-02-04 at 2 48 42 PM" src="https://user-images.githubusercontent.com/82283086/153292275-78188d20-ef3e-4d04-80bc-330b4b81d068.png"><img width="250
" alt="Screen Shot 2022-02-04 at 2 49 04 PM" src="https://user-images.githubusercontent.com/82283086/153292278-e0ac98e3-1ca8-4680-af5d-c1cceb63e311.png"><img width="250" alt="Screen Shot 2022-02-04 at 2 52 02 PM" src="https://user-images.githubusercontent.com/82283086/153292280-7b8187b5-a1d0-4829-8baf-89daf4124acd.png">

## Features and Libraries used <a name="part2"></a>

* Used [mediastack API](https://mediastack.com) (Free, Simple REST API for Live News & Blog Articles).
* It offers extensive options in various categories. For NewsApp I have provided 13 Languages (single select), 52 countries (select upto three) and 6 categories with "general" set as the default (multiselect).
* Searchbar option provided for finding language/country of choice
* [StepSlider](https://github.com/spromicky/StepSlider) to create slider for different times
* [Alamofire](https://github.com/Alamofire/Alamofire) for API response
* [SDWebImage](https://github.com/SDWebImage/SDWebImage) for displaying article images from url
* [MSCircularSlider](https://github.com/ThunderStruct/MSCircularSlider) to create semi-circular slider to show day progression
* MapKit - To display map 
* CoreLocation - Device's location

___

## What I have Learnt <a name="part3"></a>

* (array_name).filter [$0]
* Data in JSON (Dictionaries and arrays)
* Search bar delegates
* override func prepare(for segue: ...) to pass data between screens
