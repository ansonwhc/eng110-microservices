# This is for production

# first phase: build the app
FROM node:16-alpine as builder
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

# second phase: only put the required info in the production env (using nginx as base)
FROM nginx
# we take the required files from the built container and put it somewhere to serve 
COPY --from=builder /app/build /usr/share/nginx/html