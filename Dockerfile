FROM microsoft/dotnet:sdk AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY aws-DevOps-Test/*.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY aws-DevOps-Test/. ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM microsoft/dotnet:aspnetcore-runtime
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "aws-DevOps-Test.dll"]