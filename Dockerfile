# create a docker file to build a customised docker image
# for node and .js https://docs.docker.com/language/nodejs/build-images/

# choose a base image
FROM node

# label the image (optional)
LABEL MAINTAINER="Anson"

# set the environment in which the application will run in
ENV NODE_ENV=production

# migrate/transfer/cp/move data from localhost to our container
# WORKDIR /sg_application_from_aws/app
COPY sg_application_from_aws/app/ .

# RUN npm install --production
RUN npm install

# expose port 80
EXPOSE 80
EXPOSE 3000

# launch the app run this command at the end
CMD ["node", "app.js", "daemon off;"]

# # Shahrukh's version
# FROM node

# WORKDIR /usr/src/app

# COPY package*.json ./

# RUN npm install -g npm@latest

# RUN npm install express

# # # for seeding the database
# #RUN seeds/seed.js

# COPY . .

# EXPOSE 3000

# CMD ["node", "app.js"]