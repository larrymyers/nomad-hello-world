FROM golang:1.19 as builder

# no glibc dependency means running on scratch images is easy
ENV CGO_ENABLED=0 

WORKDIR /build

COPY main.go .

RUN go build -o server main.go

FROM scratch

COPY --from=builder /build/server ./server

CMD ["/server"]
