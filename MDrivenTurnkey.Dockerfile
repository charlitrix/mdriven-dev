# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine

RUN apk add --upgrade --no-cache \
        curl \
        unzip \
        xmlstarlet \
        musl-locales \
        libgdiplus \
    && cd /usr/lib \
    && ln -s libgdiplus.so.0 gdiplus.dll


ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

RUN locale -a

WORKDIR /app

ARG TK_VERSION

RUN curl -O https://mdriven.net/PublicDownloads/MDrivenTurnkeyOnCoreVersion.xml \
    && TK_VERSION=$(xmlstarlet sel -t -v "//root/date" MDrivenTurnkeyOnCoreVersion.xml) \
    && rm -f MDrivenTurnkeyOnCoreVersion.xml \
    && curl -O "https://mdriven.net/PublicDownloads/MDrivenTurnkeyCoreLinuxMUSL_${TK_VERSION}.zip" \
    && unzip "MDrivenTurnkeyCoreLinuxMUSL_${TK_VERSION}.zip" \
    && rm -f "MDrivenTurnkeyCoreLinuxMUSL_${TK_VERSION}.zip"



COPY ./turnkey-settings ./App_Data



ENTRYPOINT ["dotnet", "StreaminAppCoreWebApp.dll", "-port=5020", "-nohttps"]
