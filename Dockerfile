# Base runtime image
FROM mcr.microsoft.com/dotnet/aspnet:9.0-preview AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# SDK image for build
FROM mcr.microsoft.com/dotnet/sdk:9.0-preview AS build
WORKDIR /src

# Copy .csproj file and restore
COPY ["Shoppy.csproj", "."]
RUN dotnet restore "Shoppy.csproj"

# Copy the rest of the project
COPY . .
RUN dotnet publish "Shoppy.csproj" -c Release -o /app/publish

# Final image
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "Shoppy.dll"]
