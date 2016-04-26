Core Data/Other Options
=======================

There are many other options for managing consistency including Core Data, a popular option. These other options aren't bad, and you should definitely consider them for your app. However, we've decided that for many use cases, it is not the best option.

- Core Data can be a beast to manage, especially in large apps. Keeping it performant can be difficult.
- Core Data is also known to be difficult to keep stable. Most apps using Core Data report multiple crashes in the Core Data framework.
- The coding model for many other solutions usually requires KVO or NSNotifications to keep things in sync. If you change something on one screen, you need to know to reload a different screen.
- Mutable models makes code harder to reason about. Immutability also makes it easier to write more performant code since models will be thread safe.

Facebook has given a good overview as to why they moved away from Core Data to a similar pattern to this consistency manager: https://code.facebook.com/posts/340384146140520/making-news-feed-nearly-50-faster-on-ios/

There isn't one solution for all your problems. You should consider all your options before deciding.
