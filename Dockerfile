### STAGE 1: Build the AngularJS app ###

FROM node:8-alpine as builder
COPY package.json package-lock.json ./
RUN npm set progress=false && npm config set depth 0 && npm cache clean --force
RUN npm i && mkdir /ng-app && cp -R ./node_modules ./ng-app
WORKDIR /ng-app
COPY . .
## Production mode build
RUN $(npm bin)/ng build --env=staging --prod --build-optimizer


### STAGE 2: Add Nginx for hosting the AngularJS app ###

FROM nginx:1.13.3-alpine
## Removes the default nginx html files
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /ng-app/dist /usr/share/nginx/html
CMD ["nginx", "-g", "daemon off;"]
