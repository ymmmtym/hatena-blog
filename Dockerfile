FROM golang:1.26

RUN go install github.com/x-motemen/blogsync@latest

CMD blogsync --help