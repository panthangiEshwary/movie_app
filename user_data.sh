// user_data.sh
#!/bin/bash
apt update -y
apt install -y docker.io
systemctl start docker
systemctl enable docker


# Install Flask and other Python packages
sudo apt install python3-pip git -y
pip3 install flask flask-mysql flask-cors
git clone https://github.com/panthangiEshwary/movie_app.git
cd movie-app/backend
pip3 install -r requirements.txt

# Start the Flask app in background
nohup python3 app.py > app.log 2>&1 &











# ECR Login and run container
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 186543874090.dkr.ecr.us-east-1.amazonaws.com
docker pull 186543874090.dkr.ecr.us-east-1.amazonaws.com/movie-backend:latest
docker run -d -p 5000:5000 186543874090.dkr.ecr.us-east-1.amazonaws.com/movie-backend:latest

