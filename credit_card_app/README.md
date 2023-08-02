# Credit Card App

This project is a Flutter application that allows users to submit and validate credit card details. It provides the functionality to capture Card Number, infer Card Type, CVV, and Issuing Country. The app also checks if the specified issuing country exists in a list of banned countries before storing the credit card details.

## Getting Started

If this is your first time working with Flutter, you can follow these resources to get started:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab) - A step-by-step guide to create your first Flutter app.
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook) - A collection of useful Flutter code samples and best practices.

For more comprehensive information and guidance on Flutter development, you can refer to the [online documentation](https://docs.flutter.dev/), which provides tutorials, samples, and a full API reference.

## Features

- Capture and validate credit card details, including Card Number, Card Type (inferred), CVV, and Issuing Country.
- Check the specified country against a configurable list of banned countries.
- Store valid credit cards locally using `shared_preferences`.
- Display all captured credit cards during the session.
- Avoid capturing the same card twice.
- Scan credit cards using the `credit_card_scanner` package and pre-populate Card Number and inferred Card Type.

## References

During the development of this app, the following resources were used for learning and implementing various features:

- [pub.dev](https://pub.dev/) - A package repository for Flutter, where packages like `shared_preferences` and `credit_card_scanner` were found and utilized.
- YouTube Videos - Various YouTube tutorials were followed to gain insights into specific aspects of Flutter development.
- Udemy Course: "2022 Complete Guide to Flutter Development" - A comprehensive course that provided a deep understanding of Flutter and guided the development process.

Feel free to explore, customize, and build upon this project for your specific needs in Flutter app development. If you have any questions or need further assistance, please refer to the official Flutter documentation or community resources. Happy coding!