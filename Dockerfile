# create a docker file to build a customised docker image
# for node and .js https://docs.docker.com/language/nodejs/build-images/

# choose a base image
# FROM node

# # label the image (optional)
# LABEL MAINTAINER="Anson"

# # set the environment in which the application will run in
# ENV NODE_ENV=production

# # migrate/transfer/cp/move data from localhost to our container
# WORKDIR /usr/src/app
# COPY sg_application_from_aws/app/ .

# # RUN npm install --production
# RUN npm install

# # expose port 80
# EXPOSE 80
# EXPOSE 3000

# # launch the app run this command at the end
# CMD ["node", "app.js", "daemon off;"]



# Shahrukh's version
# # For dev
# FROM node

# For production
FROM node as app

WORKDIR /usr/src/app

COPY sg_application_from_aws/app/package*.json ./

RUN npm install -g npm@latest

RUN npm install express

# # for seeding the database
#RUN seeds/seed.js

COPY sg_application_from_aws/app/ .

EXPOSE 3000

CMD ["node", "app.js"]

###
# if the application works in development
# let's build a multi-stage production ready image
# use a smaller size image

# lightweight image
FROM node:alpine

WORKDIR /usr/src/app

COPY sg_application_from_aws/app/package*.json ./

RUN npm install -g npm@latest
RUN npm install express

# the below is to compress the image

# copy from our dev container - data in /usr/src/app path 
# to the prod container - put data in /usr/src/app path
COPY --from=app /usr/src/app /usr/src/app

EXPOSE 3000

CMD ["node", "app.js"]