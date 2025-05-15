# DevSecOps Tools Continous Integration with Github Actions and Docker Container for Go-Lang

This repository is a simple project or guide for the implementation of Security in DevSecOps (Development - Security - Operation) practices and emphasizes more on the practical implementation of CI (Continous Integration) Security such as SCA, SAST, DAST with tools / libraries that have been provided in each programming language used.

> ! Additional Information : This repository only implements Continous Integration without Stage Test, and CI is only implemented in Go-Lang projects.

The following is an explanation of each stage in CI (Continous Integration) in DevSecOps practice:

- **Unit Test (Test Stage)** : In CI (Continous Integration) Unit Test is a source code testing stage that tests each function available in the code, whether the function runs according to the expected results expected by QA with custom parameters.

- **Integration Test (Test Stage)** : Integration Test is a fairly important testing stage because a test is based on a case study such as Login which requires several other functions that are bound together so this process is quite slow, but with this test QA can ensure that whether an application flow can run well or not.

- **SCA / Sofware Composition Analysis (Security)** : Software Composition Analysis is a very important stage in CI, in this stage the quality of vulnerability / security of a package dependency of our application is tested. In project go we can usually utilize `govulncheck` to test the vulnerability level of installed dependencies to avoid application exploitation from external dependencies. For more details you can see [here](https://github.com/HaikalRFadhilahh/go-ci-devsecops/tree/master/govulncheck)

- **SAST / Security Analysis Security Testing (Security)** : SAST is the Security stage of testing where we test the vulnerability level of our project code without running our go project. In go-lang we can utilize the `gosec` package/library to test the vulnerability of our go code. For more information and how to use it can be seen [here](https://github.com/HaikalRFadhilahh/go-ci-devsecops/tree/master/gosec)

- **DAST / Dynamic Analysis Security Testing (Security)** : DAST is a stage of testing applications by simulating attacks on our running applications. After simulating the attack the tools used will provide results that we can evaluate whether there are gaps that must be corrected. To make DAST there are tools that we can use, for example _Owasp Zap Baseline_ and to do DAST our application must run first, usually testing will be directed / targeted to the testing / staging environment.

- **Build Source / Building Artifacts** : Building Artifacts is a stage where the application is built in a form that is ready to be deployed on CD (Continuous Deployment / Delivery). Artifacts Build / Artifacts Application can be in the form of binary code (Usually C++, C, Go App) or Docker Image that has been uploaded to a container registry such as (Github Container Registry, Docker Hub, Private Container Registry).

## Basic Understanding and Flow of Continous Integration Implementation on Github Actions

In this section I will explain how to implement Continous Integration in Github Actions. Like the use of CI stages and branch structures, in this project or guide I use 3 branches namely `main / master` which is the main branch or source code for production, `staging` which functions for testing and the application that runs here has a different url from prod for DAST testing and the last is `development` is a branch for developers to save code changes and will be shifted to `staging` if they want to publish but are being tested by QA.

To clarify the CI / Continous Integration process that is implemented I have created a picture that can be understood. Here is the CI Process Image:

![Continous Intergation Architecture Image](image.jpg)

Based on the picture above, there are 2 CI / Continous Integration processes, namely from dev to stag and stag to prod / master. Here's a further explanation of the 2 differences:

- **`development` -> `staging`** : In the CI process at the `development` -> `staging` stage there are several stages that are usually applied such as Project Testing (However, this time I did not exemplify the Testing stage in CI), checking the libraries that have just been installed into the project using the SCA technique and analyzing the new source code using SAST. Then besides that we also have to upload the Artifact / Deployment to the staging server / Trigger the External Tools CD.

- **`staging` -> `production`** : In the CI process, the `staging` -> `production` stage is quite crusial and important because there are several additional options, namely the implementation of DAST (Dynamic Analysis Security Testing) in CI to production. But besides that we still have to implement SCA, SAST, and Testing like CI Dev to Staging.

  <br>

  > In CI Production, the Target from DAST (Dynamic Analysis Security Testing) URL is redirected to the Staging URL and make sure it passes the test to enter the production server.

  <br>

## Continous Intergation Implementation on Github Actions

## Contributors

You can contribute to this project via Pull Request to this Repository, or you can report bugs, vulnerabilities, misinformation via the issues feature on github. 🐳

## <!-- Footer End Of The README Markdown -->

<p align="center"><b>Created By Haikal and Contributors with ☕️ and ❤️ </b></p>
