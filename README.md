# AQI - Assignment

This is an iOS App which shows live AQI (Air quality index) data for different cities using Web-socket.

## Screenshots

![Simulator Screen Shot - iPhone 13 - 2021-12-29 at 19 11 18](https://user-images.githubusercontent.com/96768526/147670281-4c3ddeb7-a47d-40d7-89c4-db9fbb906d17.png)
![Simulator Screen Shot - iPhone 13 - 2021-12-29 at 19 12 11](https://user-images.githubusercontent.com/96768526/147670351-53dafff4-ecfb-4b0b-84e4-3b6023d5b870.png)
![Simulator Screen Shot - iPhone 13 - 2021-12-29 at 19 13 45](https://user-images.githubusercontent.com/96768526/147670450-2f4a4447-030c-4f2f-9c97-8fb3df3c1c74.png)
![Simulator Screen Shot - iPhone 13 - 2022-01-03 at 18 55 35](https://user-images.githubusercontent.com/96768526/147935956-4274ce82-b89d-4876-9e5c-e75f884cdb16.png)
![Simulator Screen Shot - iPhone 13 - 2021-12-29 at 19 44 30](https://user-images.githubusercontent.com/96768526/147671252-a44aab8f-3342-46ae-8e81-0477eeff4c76.png)

## Basic details
- Deployment target: **iOS 13.0**
- Supported device: **iPhone & iPad**
- Code architecture: **MVVM**

## Features
- Live AQI data for 12 cities.
- Detail screen which show live AQI chart for selected city.
- History data upto 20 records.
- Good chart data visulization & Zoom-in function.
- Reconnection to Socket once user comes from App Background mode.
- Dark mode support.
- Error handling for Socket connection. 

## Note
- For the sake of assignment, history is kept upto 20 records.
- Suppose AQI value is *50.23* which lies between *Good* and *Satisfactory* Categoty. In that case, it is consider to be in *Good* category. We can change this logic as required.
- Swift Packgae Manager (SPM) is used to manage project dependencies.

## Architecture
- MVVM code architecture pattern is used.

- City list
    - *ViewModel* of City list connects to the web socket and listens to the callbacks.
    - It creates *CityModel* if it doesn't already exist (using city name) and adds *AQIModel* in aqi history array. If city already exist, it just adds *AQIModel*.
    - Once datasource is prepared, *ViewModel* updates *View* using delegate to refresh the table.
    - If there is error in socket connection, it updates *View* and user is promoted with error message with *Retry* button.

- AQI chart for city
    - Once user select any city, it will pass *CityModel* to the detail screen. As data is shared among two screen, *Class* is used so it automatically refresh the chart.
    - *View* will ask *ViewModel* to prepare datasource based on history data and after Chart data is prepared, it will updates *View* using delegate to refresh the chart.
    - If there is an AQI update for selected city, *ViewModel* of City list will update *ViewModel* of chart view, which will updated the chart datasource and will update to *View* to refresh the chart.

## Logic
- Create city list
    - Response array is looped through and existing datasource is checked whether it contains a city with *cityName*. If not, new instance is created for city and AQI record is added to history. 
    - AQICategory Enum is created based on the AQI value and each category is assigned Title and Color. 

- Create chart data
    - AQI history is looped through and array of *ChartDataEntry* is created and then **Data set** is created. 
    - X-Axis time values are assigned through *dataPoints* array. 
    - For the sake of demo and for better chart UI, only 20 records are stored for AQI history.

- Reconnect Socket
    - Observers for *didEnterBackgroundNotification* and *willEnterForegroundNotification* are used to open and close the connection to Web-socket. If not used reconnection logic, iOS system will stop getting Socket updates while coming back from App background mode.

## Time taken
- Choose socket library and its use: 2 Hours
- UI Design: 4 Hours
- Prepare datasource / Different logic etc: 4 hours
- Detail screen: 2 hours
- Chart library integration / Chart datasource / UI configuration: 4 hours
- Error handling and UI: 1 hour
- Dark mode support: 1 hour

