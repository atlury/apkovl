FROM alpine

ARG apkovl
ADD ${apkovl} /
RUN ["apk", "fix"]
