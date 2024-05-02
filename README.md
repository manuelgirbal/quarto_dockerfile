# quarto_dockerfile

Using your terminal and RStudio, build a dockerfile that'll help you deploy an interactive Quarto doc in a container:

1)  Create an RStudio project

2)  Build a Quarto doc in the root directory of the project (in this case, I used a Dashboard example). It should contain some interactive elements, so that you can't just use an static web hosting. You should check if the documents is rendering ok by running it in the RStudio IDE before continuing with step 3.

3)  Build a dockerfile like the one displayed in this repository. Let's break it down:

    -   **`FROM eddelbuettel/r2u:20.04`**: sets the base image for the Docker container. In this case this image already has r-base installed on an Ubuntu OS.

    -   **`RUN apt-get update && apt-get install -y --no-install-recommends ...`**: runs commands inside the container during the build process. It updates the package lists and then installs several packages. The packages being installed are **`pandoc`**, **`pandoc-citeproc`**, **`curl`**, and **`gdebi-core`**. The **`--no-install-recommends`** flag tells **`apt-get`** to skip installing recommended packages. Finally, **`rm -rf /var/lib/apt/lists/*`** removes temporary files created during the package installation to reduce the size of the Docker image.

    -   **`RUN install.r shiny ggplot2 quarto`**: runs the **`install.r`** script to install R packages. It installs **`shiny`**, **`ggplot2`**, and **`quarto`**.

    -   **`ARG QUARTO_VERSION="1.4.553"`**: defines a build argument named **`QUARTO_VERSION`** with a default value of **`"1.4.553"`**.

    -   **`RUN curl -o quarto-linux-amd64.deb -L ...`**: downloads the Quarto CLI package for Linux (**`quarto-linux-amd64.deb`**) from the GitHub releases page. The version of Quarto being downloaded is determined by the value of the **`QUARTO_VERSION`** argument.

    -   **`RUN gdebi --non-interactive quarto-linux-amd64.deb`**: installs the Quarto CLI package (**`quarto-linux-amd64.deb`**) using **`gdebi`**, a tool for installing **`.deb`** packages. The **`--non-interactive`** flag tells **`gdebi`** not to prompt for user input during the installation process.

    -   **`CMD ["bash"]`**: sets the default command to run when the Docker container starts. It specifies to run the **`bash`** shell.

    -   **`COPY test.qmd .`**: copies a file named **`test.qmd`** (your Quarto doc) from the Docker build context into the root directory of the Docker image. The Docker build context is the set of files and directories located at the specified build path.

    -   **`EXPOSE 8080`**: informs Docker that the container listens on port **`8080`** at runtime.

    -   **`CMD ["quarto", "serve", "test.qmd", "--port", "8080", "--host", "0.0.0.0"]`**: sets another default command to run when the Docker container starts. It specifies to run the Quarto CLI command **`quarto serve test.qmd --port 8080 --host 0.0.0.0`**, which serves the **`test.qmd`** file as a Quarto document on port **`8080`** and binds to all network interfaces.

4)  From a terminal with Ubuntu or another linux distro (could use WSL2 if running Windows), go to project directory (using the `cd` command) and run this two commands to:

    a)  Build the image from the Dockerfile ("-t" adds a name and tag to the image and "." indicates the path to the directory containing the files needed to build the image)

    b)  Run a Docker container from the image created (it maps port 8080 on the host to port 8080 in the container, allowing external access to services running inside the container)

```{bash}

docker build -f Dockerfile -t test:v1 .

docker run -p 8080:8080 test:v1

```

5.  You should now be able to see your interactive doc hosted. Go to <http://localhost:8080/> in your web browser. If your IP is accessible on your LAN (or the network you want), and port 8080 is exposed, other users in that network will be able to see your work.

### References

-   <https://www.docker.com/>

-   [RStudio Projects](https://support.posit.co/hc/en-us/articles/200526207-Using-RStudio-Projects)

-   <https://quarto.org/>

-   [https://learn.microsoft.com/windows/wsl/](https://learn.microsoft.com/es-mx/windows/wsl/){.uri}

-   <https://github.com/eddelbuettel/r2u>
