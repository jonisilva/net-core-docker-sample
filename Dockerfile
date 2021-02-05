FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 5000
# EXPOSE 443
ENV ASPNETCORE_URLS=http://*:5000


FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["net-core-docker-sample.csproj", "./"]
RUN dotnet restore "net-core-docker-sample.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "net-core-docker-sample.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "net-core-docker-sample.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "net-core-docker-sample.dll"]
