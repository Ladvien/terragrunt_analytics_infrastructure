FROM public.ecr.aws/bitnami/git:latest
LABEL Maintainer="Thomas Brittain"

# Supply at build with docker build --build-arg
ARG PROJECT_NAME

# Use supplied at build values, but can be overridden on docker run with -e
ENV PROJECT_NAME=$PROJECT_NAME

ENV ENV=dev
ENV INSTALL_PATH /usr/src/app
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

# make this cachable by first installing packages
RUN install_packages python3.9-minimal python3-pip awscli
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# and then copying the rest
COPY run_dbt.sh scripts/run_dbt.sh
COPY . .
RUN chmod -R 755 scripts/

EXPOSE 22
EXPOSE 2049
EXPOSE 2999

# we run everything through sh, so we can execute all we'd like
ENTRYPOINT [ "/bin/sh", "-c" ]
CMD ["scripts/run_dbt.sh"]
