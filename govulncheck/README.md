# Golang Vulnerability Check (govulncheck) Docker Image Configuration for SCA (Software Composition Analysis)

SCA (Software Composition Analysis) is a technique that can be implemented in CI (Continous Integration) in the DevSecOps process. SCA is part of the Sec / Security stage for checking external dependencies used in the project, in this case we will use GoVulnCheck (Go Vulnerabilty and Checking) to record vulnerabilities in our application.

Govulncheck is an official package from golang to check the dependencies needed by the project. govulncheck can be installed directly with `go install` or using binary, but instead of installing I will utilize docker to check govulncheck without installation.

## Requirements

- Docker Engine
- Internet Connection

## How To Use

In this case I will use docker to run `govulncheck` so there is no need to install locally. But before using there are several steps that are required before you can use `govulncheck` following are the steps to use `govulncheck` for local and CI/CD implementations:

**1. Retrieve or download the latest govulncheck docker image from the github container registry :**

```bash
docker pull ghcr.io/haikalrfadhilahh/govulncheck:latest
```

Or you can download or retrieve a govulncheck image with a specific version such as v1.1.4 or others. You can download in the following ways :

```bash
docker pull ghcr.io/haikalrfadhilahh/govulncheck:version_govulncheck_image
```

Example download docker image govulncheck version v1.1.4, or you can view the available versions at this [govulncheck image version](https://github.com/HaikalRFadhilahh/go-ci-devsecops/pkgs/container/govulncheck):

```bash
docker pull ghcr.io/haikalrfadhilahh/govulncheck:1.1.4
```

**2. Running `govulncheck` with docker container**

If you are reading this, make sure you have downloaded the docker image according to the guide above or earlier so that you can run SCA / `govulncheck` without problems.

**Basic Concept:**
In testing in a docker container, all your source code files will be binded using docker volume / -v arg so that your source code can be tested by `govulncheck` in the container. After testing the file results can be exported via `tee` in the `/app/result` folder and you can automatically access the test results at `${path_folder_your_project_}/result/name_file_result.ext`, then after that you can upload via artifact or Vulnerability Management Applications such as DefectDojo.

Here's the basic pattern for running the govulncheck docker container:

Enter your golang project folder, Make sure you are already in your golang project folder:

```bash
cd your_project_path
```

Run `govulncheck` via docker run command (example):

```bash
docker run --rm -v $(pwd):/app ghcr.io/haikalrfadhilahh/govulncheck:1.1.4 govulncheck -scan symbol -mode source -show color,traces,version -format text ./... | tee -a result/result-govulncheck.txt
```

**Command Explanation:**
In order to further understand the above command I will provide an explanation of the commands and params used for testing SCA `govulncheck`:

**Explanation of Docker Command :**

- `docker run` : The `docker run` command serves to run the docker container of the selected image

- `--rm` : The `--rm` param of `docker run` is an additional command to not save the docker container history. So that after the test runs, the docker container will be deleted automatically (This also happens when success / failure, whatever the exit condition the container will always be deleted)

- `-v $(pwd):/app` : Param `-v $(pwd):/app` serves to bind our source code to the docker container `/app` so that the source code can be tested in SCA through the docker container without having to create a volume explicitly. This also binds the test results that go into the `results/name_file_export_testing.extension` folder to our local.

- `ghcr.io/haikalrfadhilahh/govulncheck:1.1.4` : The last and mandatory argument is to specify which image to use. This can be customized according to your needs either changing the image source or the version of the govulncheck image.

**Explanation about govulncheck command :**

- `govulncheck` : The main command to perform a vulnerability check using the govulncheck tool.

- `-scan symbol` : Used to scan specific symbols within the Go source code to check for vulnerabilities.

- `-mode source` : Specifies that the scan will be done on the source code rather than on the compiled binary.

- `-show color,traces,version` : This parameter enables showing the output in colored format, including traces of vulnerabilities and version information.

- `-format text` : Defines the output format of the vulnerability check, in this case, as plain text.

- `./...` : Specifies the directory to be scanned, including all subdirectories recursively.

- `tee -a result/result-govulncheck.txt` : The `tee` command serves to save the output results from STDOUT to the file path, and there is a param `-a` which means append to add a new vulnerability to the file if the file did not exist before.

**Example of output results from SCA testing with govulncheck :**

```txt
Go: go1.24.3
Scanner: govulncheck@v1.1.4
DB: https://vuln.go.dev
DB updated: 2025-05-13 16:39:35 +0000 UTC

=== Symbol Results ===

Vulnerability #1: GO-2025-3595
    Incorrect Neutralization of Input During Web Page Generation in x/net in
    golang.org/x/net
  More info: https://pkg.go.dev/vuln/GO-2025-3595
  Module: golang.org/x/net
    Found in: golang.org/x/net@v0.34.0
    Fixed in: golang.org/x/net@v0.38.0
```

**💡 Tips : View the Golang Vulnerability and Checking (govulncheck) Usage Guide with docker :**

If you need information related to the use of `govulncheck` you can use this docker image to see how to use, what parameters can be used to what arguments should be sent. The following command can be used to view the `govulncheck` guide:

```bash
docker run --rm ghcr.io/haikalrfadhilahh/govulncheck:1.1.4 govulncheck --help
```

After you run the above command you will get output in the form of explanations, guidelines, and parameters that can be utilized in `govulncheck`. The following output is generated by the `govulncheck --help` command:

```txt
Govulncheck reports known vulnerabilities in dependencies.

Usage:

	govulncheck [flags] [patterns]
	govulncheck -mode=binary [flags] [binary]

  -C dir
    	change to dir before running govulncheck
  -db url
    	vulnerability database url (default "https://vuln.go.dev")
  -format value
    	specify format output
    	The supported values are 'text', 'json', 'sarif', and 'openvex' (default 'text')
  -json
    	output JSON (Go compatible legacy flag, see format flag)
  -mode value
    	supports 'source', 'binary', and 'extract' (default 'source')
  -scan value
    	set the scanning level desired, one of 'module', 'package', or 'symbol' (default 'symbol')
  -show list
    	enable display of additional information specified by the comma separated list
    	The supported values are 'traces','color', 'version', and 'verbose'
  -tags list
    	comma-separated list of build tags
  -test
    	analyze test files (only valid for source mode, default false)
  -version
    	print the version information

For details, see https://pkg.go.dev/golang.org/x/vuln/cmd/govulncheck.
```

With the guiding information above you can hopefully utilize govulncheck to test SCA Your golang application becomes more secure.

## Credits

Thanks to Go & Google for creating govulncheck as a library / module to perform SCA (Software Composition Analysis) testing in the Go-Lang application.

- You can see the Official Package govulncheck page [here](https://pkg.go.dev/golang.org/x/vuln/cmd/govulncheck)
- The page for the official guide to using govulncheck you can visit [here](https://go.dev/doc/tutorial/govulncheck)
- You can visit the official govulncheck project repository at [this link](https://github.com/golang/vuln)

## Contributors

You can contribute to this project through Pull Requests to this Repository, or you can report bugs or vulnerabilities through the issues feature on github. 🐳

<p align="center"><b>Created by Haikal and Contributors with ❤️ </b></p>
