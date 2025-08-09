# video_ott_app

A new Flutter project for Video-on-Demand OTT application.

## Getting Started

Detailed instructions on how to setup and run code:

Architecture followed: MVC

lib/
├── models/
│     ├── movie.dart
│     ├── movie_detail.dart
│     ├── video.dart
│
├── controllers/
│     ├── movie_controller.dart
│
├── services/
│     ├── api_service.dart
│     ├── api_route.dart
│     ├── video_service.dart
│
├── views/
│     ├── home_screen.dart
│     ├── listing_screen.dart
│     ├── detail_screen.dart
│     ├── video_detail_screen.dart
│     ├── widgets/
│           ├── movie_carousel.dart
│           ├── movie_rail.dart
│
├── main.dart

I have used OMDB api for data fetch.
OMDb URL: http://www.omdbapi.com/
My API Key: 79b578ff

Api urls:
Search: https://www.omdbapi.com/?apikey=79b578ff&s=movie&type=movie&y=2022
Detail: https://www.omdbapi.com/?apikey=79b578ff&i=tt0372784&plot=full
List with Pagination : https://www.omdbapi.com/?apikey=79b578ff&s=avengers&page=1

Move to dev branch and clone the git repo.
Open the project.

Use command:
Flutter pub get
Flutter run

Hope the app run is successful.



