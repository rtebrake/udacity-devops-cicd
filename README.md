# udacity-devops-cicd

![Python application test with Github Actions](https://github.com/rtebrake/udacity-devops-cicd/workflows/Python%20application%20test%20with%20Github%20Actions/badge.svg)

# Overview

This project consists of a Python-based Machine learning application using the Flask web framework. The basis is a pre-trained *sklearn* model that has been trained to predict housing prices in Boston. To expose the data from this model a Python flask app is used to serve out predictions through API calls. 


## Project Plan

The following planning and tracking tools are used: 

Trello: https://trello.com/b/0kHJAXdS/udacity-devops-cicd  
Excel sheet: https://1drv.ms/x/s!AnsZwmusT5D--zvw8992Hw9N78gL?e=LALX6O (Note: the Excel sheet 'pm-udacity-devops-cicd.xlsx' can also be found in this Repository)


## Instructions

Note the following Architectural diagram for an overview of how the system works:
![archdiagram](https://user-images.githubusercontent.com/23208470/106151773-fdfd3180-617c-11eb-9560-69cafd3b1e92.JPG)

The Azure webapp is hosted at https://rtb-udacity-devops-cicd.azurewebsites.net as can also be seen from the following screenshot

![appservice](https://user-images.githubusercontent.com/23208470/106152364-a57a6400-617d-11eb-9818-b756ec65fb21.JPG)

The Github repository has been cloned into Azure Cloud Shell:
![1 Git-clone](https://user-images.githubusercontent.com/23208470/106152664-01dd8380-617e-11eb-862d-c8ed16b2453d.JPG)

When running the 'make all' command, all tests pass:
![2 make_all](https://user-images.githubusercontent.com/23208470/106152775-1d488e80-617e-11eb-842e-cdc40c417a73.JPG)

Using Github Actions we can build,test and lint the code:
![3 Github_Actions_build](https://user-images.githubusercontent.com/23208470/106152901-3ea97a80-617e-11eb-9691-8b453b082e36.JPG) 

Azure Pipelines is used to do the deployment of the code, the pipeline can be seen in the screenshot below:
![azure pipeline](https://user-images.githubusercontent.com/23208470/106153339-bbd4ef80-617e-11eb-92ca-90878602e4c2.JPG)

The pipeline consists of 2 stages, a build and deploy stage:
![pipeline stages](https://user-images.githubusercontent.com/23208470/106153465-deff9f00-617e-11eb-8a2d-7cd3f71781ee.JPG)

Using the Azure Pipeline logs, one can verify the sucessful deployment of the webapp, as the following log snippet shows

```2021-01-28T13:41:55.3002176Z ==============================================================================
2021-01-28T13:41:55.3002546Z Task         : Azure Web App
2021-01-28T13:41:55.3002868Z Description  : Deploy an Azure Web App for Linux or Windows
2021-01-28T13:41:55.3003171Z Version      : 1.168.3
2021-01-28T13:41:55.3003549Z Author       : Microsoft Corporation
2021-01-28T13:41:55.3004081Z Help         : https://aka.ms/azurewebapptroubleshooting
2021-01-28T13:41:55.3004433Z ==============================================================================
2021-01-28T13:41:55.7515617Z Got service connection details for Azure App Service:'rtb-udacity-devops-cicd'
2021-01-28T13:41:58.5905192Z Package deployment using ZIP Deploy initiated.
2021-01-28T13:47:08.3804449Z Deploy logs can be viewed at https://rtb-udacity-devops-cicd.scm.azurewebsites.net/api/deployments/0038eeadc571422fbf235777bd76661f/log
2021-01-28T13:47:08.3805429Z Successfully deployed web package to App Service.
2021-01-28T13:47:12.2553605Z Successfully updated deployment History at https://rtb-udacity-devops-cicd.scm.azurewebsites.net/api/deployments/141611841629981
2021-01-28T13:47:12.5728161Z App Service Application URL: https://rtb-udacity-devops-cicd.azurewebsites.net
2021-01-28T13:47:13.3265282Z ##[section]Finishing: Deploy Azure Web App : rtb-udacity-devops-cicd
```

For verification purposes, the ML model can be queried for a prediction using Azure Cloud Shell.
![b AzureCloudShell_Prediction](https://user-images.githubusercontent.com/23208470/106153552-f50d5f80-617e-11eb-8268-950b3c247949.JPG)

Viewing the log files of the application can be done in different ways, for instance using the Azure Cloud shell. The command to do this for this deployment is the following:
```
az webapp log tail --resource-group robin_rg_linux_centralus --name rtb-udacity-devops-cicd
```
Further information regarding the *az webapp log tail* command can be found here: https://docs.microsoft.com/en-us/azure/app-service/troubleshoot-diagnostic-logs#in-cloud-shell

Running this command in Azure Cloud Shell should produce results similar to the screenshot below. 

![logtail](https://user-images.githubusercontent.com/23208470/106155258-c2646680-6180-11eb-92f5-2a5529594253.JPG)


## Enhancements

Various enhancement can be considered for the future:
* Azure Pipelines can be replaced with Github Actions
* Currently it only serves one Machine Learning model, additional ML models could be implemented for different use-cases
* The API can be enhanced to allow for different scenarios, including exposing this to 3rd parties. This would require further investigation how to properly authorize and authenticate those 3rd parties. 

## Demo 

<TODO: Add link Screencast on YouTube>





## Screenshots 

![3 Github_Actions_build](https://user-images.githubusercontent.com/23208470/105635427-0561c980-5e63-11eb-87cc-7fe5ece5cf85.JPG)
