# LORECO: Using web technologies to create an application recommending locations for a restaurant

Development Environment:

•	Processor: Intel(R) Core (TM) i7-8750H CPU @ 2.20GHz   2.21 GHz
•	Memory: 16GB
•	GPU: NVIDIA GeForce GTX 1060
•	Operating System: Windows 10
•	Ruby version: “2.7.2”
•	Rails version: “6.1.4.1”
•	Python interpreter version: “3.7.9”
•	IDE: Microsoft Visual Studio Code


To have the Rails application installed locally, please install the corresponding Ruby and Rails version

1.	Please extract or decompress the zip file being downloaded and locate in directory “zl00628_COM3001_Project” in the IDE, to have the folder set as the project folder.
2.	Change directory to “Loreco” and modify the path in the “Gemfile” for the line from the absolute path used in local machine development environment to the absolute path or relative path copied for the directory of “backpedal-master” in the “gem_mod” folder.

gem 'backpedal', :path => "E:\\zl00628_COM3001_Project\\gem_mod\\backpedal-master" 
This path needs to be changed to your own path to the dir.

3.	Install all gems in the gemfile through running “bundle install”
4.	In the generated “application.yml” file under the config folder, add the API credentials to allow Foursquare and Google Maps API to be used.
Please register your own Rapid API key, Google API key, Foursquare API key (FOURSQUARE_TOKEN, FOURSQUARE_CLIENT_ID and FOURSQUARE_CLIENT_SECRET) and fill in as following formatting:

API_KEY: [YOUR RAPID API KEY]
GOOGLE_API_KEY: [YOUR GOOGLE MAPS API KEY]
FOURSQUARE_TOKEN: [YOUR FOURSQUARE TOKEN]
FOURSQUARE_CLIENT_ID: [YOUR FOURSQUARE CLIENT ID]
FOURSQUARE_CLIENT_SECRET: [YOUR FOURSQUARE CLIENT ID]

5.	Run “rake db:migrate” in the terminal to have all migrations running and database constructed.
6.	Run “rake db:seed” in the terminal to have all initialised data populated for the database.
(All previous steps are performed in [terminal 1])

In case the instructions does not function for rake:db migrate when installing the files, the table should be all dropped and re-created first through:

rake db:drop:_unsafe

rake db:create:all

rake db:migrate

rake db:seed

7.	Open a new window for terminal [call it terminal 2], and change directory into “flask-restful-heroku” under the Loreco directory through command “cd flask-restful-heroku”.
8.	In [terminal 2], continue activating the virtual environment to have flask app running through command “.\venv\Scripts\activate”.
9.	In [terminal 2], run command “flask run” to have the Python script for ABSA awaiting to run in the background. There might be compatible issues with CUDA required for the Python script to perform transformer model training and predicting, hence it is not ensured the function would work every time. Wait until the terminal have the environment and script loaded with command being printed on the terminal:

“2022-05-22 03:26:17.486494: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1418] Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 4624 MB memory) -> physical GPU (device: 0, name: NVIDIA GeForce GTX 1060, pci bus id: 0000:01:00.0, compute capability: 6.1)
* Running on http://127.0.0.1:5000 (Press CTRL+C to quit)”

10.	Return back to [terminal 1], and run command “rails s” to start the server.
11.	The window size for some elements might vary according to your screen resolutions as it has not been programmed to adapt dynamically due to time constraints. Hence some UI might not be as optimally displayed.
12.	Congratulations! You are ready to go. And please make sure not to have too many API calls being requested through using the “nearby_result” and “explore google restaurant” feature.
