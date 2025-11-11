FROM node:18-alpine

# set working directory
WORKDIR /app

# copy package.json and install dependencies
COPY package.json .
RUN npm install --production=false

# copy application source
COPY . .

# expose port (adjust if your app uses a different port)
EXPOSE 3000

# start command
CMD ["npm", "start"]
