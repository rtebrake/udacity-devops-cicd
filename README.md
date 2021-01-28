# udacity-devops-cicd

![Python application test with Github Actions](https://github.com/rtebrake/udacity-devops-cicd/workflows/Python%20application%20test%20with%20Github%20Actions/badge.svg)

# Overview

This project consists of a Python-based Machine learning application using the Flask web framework. The basis is a pre-trained *sklearn* model that has been trained to predict housing prices in Boston. To expose the data from this model a Python flask app is used to serve out predictions through API calls. 


## Project Plan

The following planning and tracking tools are used: 

Trello: https://trello.com/b/0kHJAXdS/udacity-devops-cicd  
Excel sheet: https://1drv.ms/x/s!AnsZwmusT5D--zvw8992Hw9N78gL?e=LALX6O (Note: the Excel sheet 'pm-udacity-devops-cicd.xlsx' can also be found in this Repository)


## Instructions

Note the following Architectural diagram for an overview of how the system is set up:
![archdiagram](https://user-images.githubusercontent.com/23208470/106151773-fdfd3180-617c-11eb-9560-69cafd3b1e92.JPG)

The steps below describe how this project can be deployed and used. The goal of this setup is to have an automated test and lint step using Github Actions and an automated deployment to Azure using Azure Pipelines. These steps are automatically triggered after committing new code to the Github repository.

###
Create a repository (forked of this repository), create SSH keys and upload these to your Github account  
Clone  your repository into the Azure Cloud Shell  

![1 Git-clone](https://user-images.githubusercontent.com/23208470/106152664-01dd8380-617e-11eb-862d-c8ed16b2453d.JPG)


Perform a local test by using a *make all*. All tests should pass, similar to this screenshot.

![2 make_all](https://user-images.githubusercontent.com/23208470/106152775-1d488e80-617e-11eb-842e-cdc40c417a73.JPG)


To do a remote test, we use Github Actions. Use the *pythonapp.yml* in the repository the workflow.
A build using Github Actions should look like the following screenshot.
![3 Github_Actions_build](https://user-images.githubusercontent.com/23208470/106152901-3ea97a80-617e-11eb-9691-8b453b082e36.JPG) 


An Azure Webapp is used to host the application. It is initially created using Azure CLI using the following command. The *--sku* parameter is passed to prevent a more expensive SKU from being used (by default) as it is not needed for this deployment.
```az webapp up -n rtb-udacity-devops-cicd --sku b1
```
In case the Azure Webapp was created using the GUI, note the additional step of setting *SCM_DO_BUILD_DURING_DEPLOYMENT* in the official documentation here: https://docs.microsoft.com/en-us/azure/devops/pipelines/ecosystems/python-webapp?view=azure-devops#run-the-pipeline

This specific deployment of the webapp can be found at at https://rtb-udacity-devops-cicd.azurewebsites.net as can also be seen from the following screenshot
![appservice](https://user-images.githubusercontent.com/23208470/106152364-a57a6400-617d-11eb-9818-b756ec65fb21.JPG)

For verification purposes, the ML model can be queried for a prediction using Azure Cloud Shell.
![b AzureCloudShell_Prediction](https://user-images.githubusercontent.com/23208470/106153552-f50d5f80-617e-11eb-8268-950b3c247949.JPG)


Azure Pipelines will automically trigger a deployment, this screenshot shows several of these runs as a result of committing new code:
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


Viewing the log files of the deployed application can be done in different ways, for instance using the Azure Cloud shell. The command to do this for this deployment is the following:
```
az webapp log tail --resource-group robin_rg_linux_centralus --name rtb-udacity-devops-cicd
```
Further information regarding the *az webapp log tail* command can be found here: https://docs.microsoft.com/en-us/azure/app-service/troubleshoot-diagnostic-logs#in-cloud-shell

Running this command in Azure Cloud Shell should produce results similar to the screenshot below. 

![logtail](https://user-images.githubusercontent.com/23208470/106155258-c2646680-6180-11eb-92f5-2a5529594253.JPG)


## Load testing

Load testing was done with Locust(https://locust.io). Locust was configured to run against 2 separate endpoints:
* The main page (providing the *SKLearn* output)
* The Predict API, which is a POST command, not a GET.

Querying just the main SKLearn homepage would not suffice as that will not actually prove that the API is providing results. To allow Locust to actually query the API, a POST command with a JSON payload has to specified. The sample JSON data used for the local Azure Cloud Shell tests is used in this case.

![locustfile](https://user-images.githubusercontent.com/23208470/106162698-afee2b00-6188-11eb-9e81-4f91450cd393.JPG)

The screenshot below shows Locust running against this specific deployment of the app (*HOST:*) and not failing any the tests, not against the main HTTPS page but also not against the API endpoint using the POST command and the JSON payload.

![C Locust](https://user-images.githubusercontent.com/23208470/106162211-25a5c700-6188-11eb-832b-35f0eaca65cd.JPG)


## Enhancements

Various enhancement can be considered for the future:
* Azure Pipelines can be replaced with Github Actions
* Currently it only serves one Machine Learning model, additional ML models could be implemented for different use-cases
* The API can be enhanced to allow for different scenarios, including exposing this to 3rd parties. This would require further investigation how to properly authorize and authenticate those 3rd parties. 

## Youtube link 

<TODO: Add link Screencast on YouTube>


