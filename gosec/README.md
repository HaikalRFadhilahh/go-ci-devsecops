# GoSec Docker Image Configuration for SAST (Static Analysis Security Testing)

SAST (Software Analysis Security Testing) is a technique to test the quality of our application code / source code without having to run the application itself. With the SAST technique, we can find out whether our code has loopholes that can be exploited or not.

Golang Security Checke (gosec) is a tool that can perform SAST on go project source code. gosec has many capabilities in analyzing code such as setting confidence analysis, setting the severity level, and exporting code analysis results into files with various formats. For gosec, it can be implemented in CI without installation, we will still use docker.

## Requirements

- Docker Engine
- Internet Connection

## How To Use

In this case I will use docker to run `gosec` so there is no need to install locally. But before using there are several steps that are required before you can use `gosec` following are the steps to use `gosec` for local and CI/CD implementations:

**1. Retrieve or download the latest gosec docker image from the github container registry :**

```bash
docker pull ghcr.io/haikalrfadhilahh/gosec:latest
```

Or you can download or retrieve a gosec image with a specific version such as v2.22.4 or others. You can download in the following ways :

```bash
docker pull ghcr.io/haikalrfadhilahh/gosec:version_gosec_image
```

Example download docker image gosec version v2.22.4, or you can view the available versions at this [gosec image version](https://github.com/HaikalRFadhilahh/go-ci-devsecops/pkgs/container/gosec):

```bash
docker pull ghcr.io/haikalrfadhilahh/gosec:2.22.4
```

**2. Running `gosec` with docker container**

If you are reading this, make sure you have downloaded the docker image according to the guide above or earlier so that you can run SAST / `gosec` without problems.

**Basic Concept:**
In testing in a docker container, all your source code files will be binded using docker volume / `-v` arg so that your source code can be tested by `gosec` in the container. After testing the file results can be exported via `-out` param in the `/app/result` folder and you can automatically access the test results at `${path_folder_to_your_project}/result/name_test_file_result.ext`, then after that you can upload via artifact or Vulnerability Management Applications such as DefectDojo.

Here's the basic pattern for running the gosec docker container:

Enter your golang project folder, Make sure you are already in your golang project folder:

```bash
cd your_project_path
```

Run `gosec` via docker run command (example):

```bash
docker run --rm -v $(pwd):/app ghcr.io/haikalrfadhilahh/gosec:2.22.4 gosec -stdout -sort -severity medium -nosec -fmt text -color -confidence medium -out /app/result/result-gosec.txt ./...
```

**Command Explanation:**
In order to further understand the above command I will provide an explanation of the commands and params used for testing SAST `gosec`:

**Explanation of Docker Command :**

- `docker run` : The `docker run` command serves to run the docker container of the selected image

- `--rm` : The `--rm` param of `docker run` is an additional command to not save the docker container history. So that after the test runs, the docker container will be deleted automatically (This also happens when success / failure, whatever the exit condition the container will always be deleted)

- `-v $(pwd):/app` : Param `-v $(pwd):/app` serves to bind our source code to the docker container `/app` so that the source code can be tested in SAST through the docker container without having to create a volume explicitly. This also binds the test results that go into the `results/name_file_export_testing.extension` folder to our local.

- `ghcr.io/haikalrfadhilahh/gosec:2.22.4` : The last and mandatory argument is to specify which image to use. This can be customized according to your needs either changing the image source or the version of the gosec image.

**Explanation about gosec command :**

- `gosec` : The main command to perform a SAST vulnerability check using the gosec tool.

- `-stdout` : The `-stdout` paramater serves to still provide the results of the SAST test results to the Standard Output or CLI even though we save the results to a file with the `-out` option so we will still get output in the terminal.

- `-sort` : The `-sort` paramater serves to sort by severity from HIGH to LOW so as to help developers handle vulnerabilities from highest to lowest.

- `-severity medium` : The `-severity` parameter serves to select the minimum level of vulnerability that will be displayed, for example: in the command above using `-severity medium` means that the SAST test results will only display vulnerabilities that are medium to high and those that are low are not displayed.

- `-nosec` : The `-nosec` paramater serves to ignore lines of code above which there is a `#nosec` tag so that even though the code has a vulnerability if the `-nosec` option is used, the code gets special treatment by not being checked by gosec.

- `-color ` : Prints the text format report with colorization when it goes in the stdout.

- `-confidence medium` : paramater `-confidence` serves to display analysis results with a certain level when we use `-confidence medium` then only medium to High analysis levels will be displayed, low analysis results / with a minimum level of truth (can indicate False Positive) will be ignored.

- `-fmt text` : `-fmt text` paramater to set the type of output file to be generated. For other types see `gosec --help`.

- `-out /app/result/result-gosec.txt` : The `-out` paramater serves to save the SAST test results into a file. You can also save the file to a specific path with the following paramater saved to `/app/result/name_result_test_name.extension` (exp: `-out /app/result/result-gosec.txt`)

- `./...` : Specifies the directory to be scanned, including all subdirectories recursively.

**Example of output results from SAST testing with gosec :**

```txt
Results:


[/app/internal/server/server.go:62] - G114 (CWE-676): Use of net/http serve function that has no support for setting timeouts (Confidence: HIGH, Severity: MEDIUM)
    61: 	fmt.Println("Server Running On :", s.ListenAndServeString)
  > 62: 	log.Fatalln(http.ListenAndServe(s.ListenAndServeString, r))
    63: }

Autofix:

Summary:
  Gosec  : dev
  Files  : 20
  Lines  : 1129
  Nosec  : 0
  Issues : 1
```

**💡 Tips : View the Golang Security Checker (gosec) Usage Guide with docker :**

If you need information related to the use of `gosec` you can use this docker image to see how to use, what parameters can be used to what arguments should be sent. The following command can be used to view the `gosec` guide:

```bash
docker run --rm ghcr.io/haikalrfadhilahh/gosec:2.22.4 gosec --help
```

After you run the above command you will get output in the form of explanations, guidelines, and parameters that can be utilized in `gosec`. The following output is generated by the `gosec --help` command:

```txt
gosec - Golang security checker

gosec analyzes Go source code to look for common programming mistakes that
can lead to security problems.

VERSION: dev
GIT TAG:
BUILD DATE:

USAGE:

	# Check a single package
	$ gosec $GOPATH/src/github.com/example/project

	# Check all packages under the current directory and save results in
	# json format.
	$ gosec -fmt=json -out=results.json ./...

	# Run a specific set of rules (by default all rules will be run):
	$ gosec -include=G101,G203,G401  ./...

	# Run all rules except the provided
	$ gosec -exclude=G101 $GOPATH/src/github.com/example/project/...


OPTIONS:

  -ai-api-key string
    	Key to access the AI API
  -ai-api-provider string
    	AI API provider to generate auto fixes to issues.
    	Valid options are: gemini
  -ai-endpoint string
    	Endpoint AI API.
    	This is optional, the default API endpoint will be used when not provided.
  -color
    	Prints the text format report with colorization when it goes in the stdout (default true)
  -concurrency int
    	Concurrency value (default 8)
  -conf string
    	Path to optional config file
  -confidence string
    	Filter out the issues with a lower confidence than the given value. Valid options are: low, medium, high (default "low")
  -enable-audit
    	Enable audit mode
  -exclude value
    	Comma separated list of rules IDs to exclude. (see rule list)
  -exclude-dir value
    	Exclude folder from scan (can be specified multiple times)
  -exclude-generated
    	Exclude generated files
  -fmt string
    	Set output format. Valid options are: json, yaml, csv, junit-xml, html, sonarqube, golint, sarif or text (default "text")
  -include string
    	Comma separated list of rules IDs to include. (see rule list)
  -log string
    	Log messages to file rather than stderr
  -no-fail
    	Do not fail the scanning, even if issues were found
  -nosec
    	Ignores #nosec comments when set
  -nosec-tag string
    	Set an alternative string for #nosec. Some examples: #dontanalyze, #falsepositive
  -out string
    	Set output file for results
  -quiet
    	Only show output when errors are found
  -r	Appends "./..." to the target dir.
  -severity string
    	Filter out the issues with a lower severity than the given value. Valid options are: low, medium, high (default "low")
  -show-ignored
    	If enabled, ignored issues are printed
  -sort
    	Sort issues by severity (default true)
  -stdout
    	Stdout the results as well as write it in the output file
  -tags string
    	Comma separated list of build tags
  -terse
    	Shows only the results and summary
  -tests
    	Scan tests files
  -track-suppressions
    	Output suppression information, including its kind and justification
  -verbose string
    	Overrides the output format when stdout the results while saving them in the output file.
    	Valid options are: json, yaml, csv, junit-xml, html, sonarqube, golint, sarif or text
  -version
    	Print version and quit with exit code 0
```

With the guiding information above you can hopefully utilize gosec to test SAST Your golang application becomes more secure.

## Credits

Thanks to securego and Comunity for creating gosec as a library / module to perform SAST (Static Analysis Security Testing) testing in the Go-Lang application.

- You can see the Official Package gosec page [here](https://pkg.go.dev/github.com/securego/gosec/v2)
- You can visit the official gosec project repository and guide package at [this link](https://github.com/securego/gosec)

## Contributors

You can contribute to this project through Pull Requests to this Repository, or you can report bugs or vulnerabilities through the issues feature on github. 🐳

<p align="center"><b>Created by Haikal and Contributors with ❤️ </b></p>
