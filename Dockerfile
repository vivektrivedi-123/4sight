FROM node:13 AS testing
WORKDIR /app
RUN apt-get update && apt-get install sudo nano
COPY . .
RUN adduser node sudo
RUN echo '%node ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER node
RUN sudo npm i && sudo npm run build
RUN sudo chown -R 1000:1000 build

FROM nginx:latest
WORKDIR /usr/share/nginx/html
COPY --from=testing /app/build .
COPY start.sh .
RUN chmod +x start.sh
ENTRYPOINT sh start.sh && bash
