
[![License][license-image]][license-url]
[![Swift Version][swift-image]][swift-url]
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](https://www.apple.com)

# CryptoTracker with MVVM

An application for viewing the rate of cryptocurrency. Written using the MVVM design pattern, it interacts with the Coingecko service API. Written without using Storyboards. In the absence of the Internet, an alert appears asking you to check the Internet connection. The ability to search by coins and the ability to add coins to favourites for a more convenient view of the course. Data about the fact of adding a coin to favourites is stored in CoreData. In the coin card, you can see more detailed information about selected cryptocurrencies. The coin card is animated: the animation starts when the card appears, it is closed, and when you tap on the card, it flips with the animation.

![ScreenShot][gif-url]

## Features

- [x] Developed using the MVVM pattern
- [x] Use Grand Central Dispatch
- [x] Added internet connection check
- [x] Working with Coingecko Service API
- [x] Saving a list of favorite coins in CoreData
- [x] Not used by Storyboards (verst by code)
- [x] On the general list, drag down to update the data about the coins
- [x] Animation of the coin card when it appears, closes, when taped, the card is animatedly flipped, blurred background

## Requirements

- iOS 15.3+
- Xcode 13.4.1

## Installation

Open file CryptoTrackerV2.xcodeproj and run project

## Meta

Distributed under the GPL-2.0 license. See ``LICENSE`` for more information.

[https://github.com/TwinkleFoxy/github-link](https://github.com/TwinkleFoxy/)

[swift-image]:https://img.shields.io/badge/swift-5.0-orange.svg
[swift-url]: https://swift.org/
[license-url]: https://github.com/TwinkleFoxy/CryptoTracker_with_MVVM/blob/main/LICENSE
[license-image]: https://img.shields.io/github/license/TwinkleFoxy/CryptoTracker_with_MVVM?color=brightgreen
[license-url]: https://github.com/TwinkleFoxy/Test/blob/main/LICENSE
[gif-url]: https://github.com/TwinkleFoxy/CryptoTracker_with_MVVM/blob/main/GIF/GIF.gif
