FROM johnfosborneiii/dotnet-summit-base-rhel7:1.0

ARG source=.
WORKDIR /app
COPY $source .

RUN chmod +x /app/docker-entrypoint.sh
ENTRYPOINT ["/app/docker-entrypoint.sh"]
