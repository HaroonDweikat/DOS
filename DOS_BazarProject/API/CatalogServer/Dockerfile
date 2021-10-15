FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["CatalogServer/CatalogServer.csproj", "CatalogServer/"]
RUN dotnet restore "CatalogServer/CatalogServer.csproj"
COPY . .
WORKDIR "/src/CatalogServer"
RUN dotnet build "CatalogServer.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "CatalogServer.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CatalogServer.dll"]
