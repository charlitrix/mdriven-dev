# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine

RUN apk add --upgrade --no-cache \
        curl \
        unzip \
        xmlstarlet \
        libgdiplus \
    && cd /usr/lib \
    && ln -s libgdiplus.so.0 gdiplus.dll

WORKDIR /app

ARG MS_VERSION

RUN curl -O https://mdriven.net/PublicDownloads/MDrivenServerOnCoreVersion.xml \
    && MS_VERSION=$(xmlstarlet sel -t -v "//root/date" MDrivenServerOnCoreVersion.xml) \
    && rm -f MDrivenServerOnCoreVersion.xml \
    && curl -O "https://mdriven.net/PublicDownloads/MDrivenServerCoreLinux_${MS_VERSION}.zip" \
    && unzip "MDrivenServerCoreLinux_${MS_VERSION}.zip" \
    && rm -f "MDrivenServerCoreLinux_${MS_VERSION}.zip"



RUN dotnet nuget add source /mnt/c/capableobjectswush/Xternal/VistaDB --name  XternatVistaDB



ENTRYPOINT ["dotnet", "AppCompleteGenericCore.dll", "-port=5010", "-nohttps"]
