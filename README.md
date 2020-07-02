# docker-kubectl-awscli

A Docker image with kubectl, kubesec and awscli. The basis for this image is Python2 of the Alpine flavour, still full-featured but without the cruft.

## Versions

- ``v1.9.3`` - tagged release automatically building version **1.9.3** of ``kubectl``, **0.6.1** of `kubesec` and the latest **awscli**.
- ``v1.11.2`` - tagged release automatically building version **1.11.2** of ``kubectl``, **0.6.1** of `kubesec` and the latest **awscli**.
- ``v1.18.5`` - tagged release automatically building version **1.18.5** of ``kubectl`` and **1.18.92** of **awscli**

* Removed Kubesec
* Removed Helm
* Removed Promtool

## Build new version

Build
`docker build -t expert360/kubectl-awscli:v1.18.5 .`

Run
`docker run -it expert360/kubectl-awscli:v1.18.5 bash`

Push
`docker push expert360/kubectl-awscli:v1.18.5`
