# BuildIt-Assignment-iOS
Interview assignment submission to BuildIt @ Wipro digital by Siddharth Paneri, for the position of Senior iOS Engineer.

## Assignment details:
Please build an app displaying the 5 day weather forecast for a location of your choice.
1. Build a native iOS or Android app (your choice).
2. Use the <a href="http://openweathermap.org/forecast5" target= "_blank">OpenWeatherMap 5 day weather forecast API</a> to retrieve the current 5 day weather forecast.
3. Give some thought to what will make a decent user experience. We would like to see something readable but with no need to go all out on sleek and flashy UI elements.
4. Use any supporting technologies, package management, build systems, component libraries that you are familiar with and feel are appropriate.


### App architecture
<img src = "https://github.com/siddharth-paneri/BuildIt-Assignment-iOS/blob/master/Images/Architecture.png" width="600"/>


### Features implemented
1. Included the cities json file in bundle.
2. Cities data is read from json file once per launch and stored in RAM for later use.
3. Implemented find city using search controller.
4. Fetch Weather data from API using city Id.
5. Display forecast data accordingly in charts or list as per user's selection.
6. Catching forecast data in SQLite using CoreData.
7. Fetching new data only after a bufffer period (3 hours in our case).
8. App works offline for buffer period (3 hours) until new data is required.
9. Landscape orientation allowed only in charts view.


### App screenshots -
<img src = "https://github.com/siddharth-paneri/BuildIt-Assignment-iOS/blob/master/Images/IMG_1590.PNG" width="200"/>    <img src = "https://github.com/siddharth-paneri/BuildIt-Assignment-iOS/blob/master/Images/IMG_1592.PNG" width="200"/>    <img src = "https://github.com/siddharth-paneri/BuildIt-Assignment-iOS/blob/master/Images/IMG_1593.PNG" width="200"/>    <img src = "https://github.com/siddharth-paneri/BuildIt-Assignment-iOS/blob/master/Images/IMG_1594.PNG" width="200"/>
 


### Future Improvements
1. Fetching such a large chunk of data of cities takes time, So we can use some API to fetch the cities search result.
2. Display current weather data in cities view, in front of city
3. Display wind degrees with relevant direction signs like, NW, NE, SW, etc
4. Display Rain and snow data.
5. Fetch timezone details of selected city/country to show relevant timestring in front of forecast date-time.
6. Plottim Min/Max temperature values on same chart where temperature is plotted.
