FROM eddelbuettel/r2u:20.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    pandoc \
    pandoc-citeproc \
    curl \
    gdebi-core \
    && rm -rf /var/lib/apt/lists/*

RUN install.r \
    shiny \
    ggplot2 \
    quarto

ARG QUARTO_VERSION="1.4.553"
RUN curl -o quarto-linux-amd64.deb -L https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb
RUN gdebi --non-interactive quarto-linux-amd64.deb

CMD ["bash"]

COPY test.qmd .

EXPOSE 8080

CMD ["quarto", "serve", "test.qmd", "--port", "8080", "--host", "0.0.0.0"]