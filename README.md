# POC_AQI
This is small POC on representing  Air Quality Monitoring data using MVVM pattern.

1. Used MVVM pattern for building the application
2. Used Starscream  for socket connection.
3. Have used Coreplot library to draw the graph. Since its simple and it provides way of customisation and used and tested by many other application.
4. AQIModel is used to store the data which we get from server.
5. AQIBaseViewModel - This class is responsible for connecting to socket and listens for the update and filter all the data and updates model and UI.
6. AQITableViewModel - This is derived from baseview model and fucntionality specific to list view is addedd here.
7. AQIGraphViewModel -This is derived from baseview model and fucntionality specific to graph view is addedd here.
8. AQIListViewController - This has the UI to show the AQI based on city. 
9. AQIDispayViewController - This class shows the graph for each selected city. x axis value is time and y- axis AQI value. Whenever we recieve data from socket we are updating the graph value.

How to run : 

1. Open AirQualityMonitoring.xcworkspace
2. Go to project directory and run pod install
3. Now run the application.


Time spent : - Spent around 12 hours.This time includes R&D on graph library as well. 


<img width="384" alt="AppIcon" src="https://user-images.githubusercontent.com/5120415/144841097-915387a9-80f7-4c01-9c91-4b3a403fd5a2.png">

