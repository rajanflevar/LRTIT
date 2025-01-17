FROM node:14.17.0 AS compile-image
WORKDIR /opt/ng
ENV PATH="./node_modules/.bin:$PATH" 
RUN apt update && apt install -y python3 python3-dev  build-essential
COPY . ./
EXPOSE 4200
RUN npm install
RUN ng build --configuration production
FROM nginx:1.19.2-alpine
COPY nginx/nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /usr/share/nginx/html/.well-known
COPY nginx/apple-developer-merchantid-domain-association.crt /usr/share/nginx/html/.well-known/apple-developer-merchantid-domain-association
COPY --from=compile-image /opt/ng/dist/lift-frontend /usr/share/nginx/html
