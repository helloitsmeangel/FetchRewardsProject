# FetchRewardsProject

## Summary: Include screen shots or a video of your app highlighting its features
![PortraitMain](https://github.com/user-attachments/assets/3c7f3062-3840-4ebf-8031-f45ab04f603f)
![PortraitSources](https://github.com/user-attachments/assets/fce7c1ab-85f3-49e1-a0dd-a33910401a10)
![LandscapeMain](https://github.com/user-attachments/assets/06ead389-ba01-4058-9897-6bf416e362b4)

## Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?

A big portion of the project was getting the NetworkClient to function properly and be testable. I made sure create protocols that the NetworkClient would conform to. Allowing me to pass in my NetworkClient in my project, while allowing me to pass in a Mock NetworkClient in my tests. This was important for me to focus on because that's the backbone of the app, if the NetworkClient is built well, it will be pretty easy to add more to it in the future without a massive refactor. I also made sure to add error handling, so that if something does go wrong we aren't crashing out of the app. We instead would receive an alert with what the error was.

## Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?

About 3 hours every day after work, so about 20 hours total. Time was allocated between UI, Network calls, testing, and caching.

I spent a bit of time creating a starter UI, so when I was building out my NetworkClient I could see that data was either coming through cleanly or if I was hitting errors. After that, some time was spent on testing my RecipeViewModel to make sure my getRecipe() call was functioning correctly. Caching came after everything to make the app more efficient!

## Trade-offs and Decisions: Did you make any significant trade-offs in your approach?

One decision I made was to create 2 protocols that NetworkClient will conform to. One was for generic NetworkClient functions like fetch, which would include posts, puts, etc. if they were necessary. And the other protocol was for recipe specific API calls. The reason for this change was because I was thinking about future features like an Account screen, and a Bookmarks screen. Being able to pass in a specific screen's network service protocol would allow us to hide unnecessary functions from the view model. For example, we wouldn't need a getRecipes() call in the future Accounts screen. The trade off to this, though, is that we would need to implement all of these functions in one NetworkClient class which would make the file pretty large in larger projects. We could also create different NetworkClients for each service, but that would mean we'd have to potentially create many files if we have a lot of API services to support.

## Weakest Part of the Project: What do you think is the weakest part of your project?

The weakest part of the project is the caching system. The directions said to save to disk, so I wanted to use CoreData, but I was working in a purely SwiftUI project and wanted to utilize SwiftData. I found out later that SwiftData is only usable in iOS 17+ though and this project's minimum version was 16. I definitely still could've gone for CoreData but in the interest of time I decided to just save directly to the file system.

I'd say this is a pretty bad decision in general because the file system really isn't a place to store cached images, but given time constraints and the requirement stating we weren't allowed to use URLSession's default caching or URLCache this is what I came up with. It saves the images to the documents directory when downloaded. When we try to retrieve an image with this name again, it will check the cache first.

Given more time, I definitely would swap this out to use CoreData instead since this is a great use case for it.

## Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.

I liked the creativity portion of the UI, being able to lay it out in any way as long as it listed recipes with some key information was a fun challenge! I used a paged tab view, and had to play around with GeometryReader to be usable in both portrait and landscape.
