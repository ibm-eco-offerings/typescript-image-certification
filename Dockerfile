FROM registry.access.redhat.com/ubi8/nodejs-12:1-52 AS builder

WORKDIR /opt/app-root/src

COPY . .

RUN ls -lA && npm install
RUN npm run build

FROM registry.access.redhat.com/ubi8/nodejs-12:1-52

COPY --from=builder /opt/app-root/src/dist dist
COPY --from=builder /opt/app-root/src/public public
COPY --from=builder /opt/app-root/src/package.json .
RUN npm install --production

LABEL name="my-image"
LABEL vendor="My Company, Inc."
LABEL version="1.0.0"
LABEL release="1234"
LABEL summary="My sample microservice"
LABEL description="This is a microservice for doing something great."

COPY ./licenses licenses

ENV HOST=0.0.0.0 PORT=3000

EXPOSE 3000/tcp

CMD npm run serve
