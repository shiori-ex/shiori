<img src="https://raw.githubusercontent.com/shiori-ex/graphics/master/rendered/banner-bg-4477x1000.png" width="100%" />

shiori is a web application to simply store, manage and search through links by meta variables like description or tags. [MeiliSearch](https://www.meilisearch.com/) is used therefore as high-performance full-text search database to provide blazingly fast search results even in huge datasets. The dataset will be accessable over a REST API via web or CLI application.

---

# REST API

This project hosts the server application which connects to the meilisearch database and provides the REST API to connect to from the front end applications. For simplicity and performance, this application is written in elixir using [plug](https://github.com/elixir-plug/plug) and [cowboy](https://github.com/ninenines/cowboy) as web server and [meilisearch-elixir](https://github.com/robottokauf3/meilisearch-elixir) as MeiliSearch client.
