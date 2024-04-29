# quarto_dockerfile
Build a dockerfile that'll help you deploy a Quarto doc

References:
https://learn.microsoft.com/windows/wsl/install
https://quarto.org/docs/dashboards/
https://github.com/eddelbuettel/r2u

1) Build a Quarto doc (in this case, a Dashboard) in an RStudio project. 

2) From a terminal with Ubuntu or another linux distro (could use WSL2 if running Windows), go to project directory and run:

```{bash}
docker build -f Dockerfile -t test:v1 .

docker run -p 8080:8080 test:v1
```
