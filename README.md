# AQI - Assignment

This is an iOS App which shows live AQI (Air quality index) data for different citie using Web-socket.

**Features**
- Live AQI data for 12 cities.
- Detail screen which show live AQI chart for selected city.
- History data upto 20 records.
- Good chart data visulization & Zoom-in.
- Reconnection to Socket once user comes from App Background mode.
- Dark mode support.
- Error handling for Socket connection. 

**Note**
- For the sake of assignment, history is kept upto 20 records.
- Suppose AQI value is *50.23* which lies between 'Good' and 'Satisfactory'. Categoty. In that case, it is consider to be in 'Good' category. We can change this logic as required.

**Architecture**
- MVVM code architecture pattern is used.
- City list
    - *ViewModel* of City list connects to the web socket and listens to the callbacks.
    - It creates *CityModel* if it doesn't already exist (using city name) and adds *AQIModel* in aqi history array. If city already exist, it just adds *AQIModel*.
    - Once datasource is prepared, *ViewModel* updates *View* using delegate to refresh the table.
    - If there is error in socket connection, it updates *View* and user is promoted with error message with *Retry* button.
