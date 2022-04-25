#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443
#RUN dotnet dev-certs https --trust

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["ExampleWebAPI01/ExampleWebAPI01.csproj", "ExampleWebAPI01/"]
RUN dotnet restore "ExampleWebAPI01/ExampleWebAPI01.csproj"
COPY . .
WORKDIR "/src/ExampleWebAPI01"
RUN dotnet build "ExampleWebAPI01.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ExampleWebAPI01.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ExampleWebAPI01.dll"]