#! /bin/bash

source ./env

# Function to log messages
log_message() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" | tee -a "$LOGFILE"
}


error_handler (){
    local message="$1"
    echo "Error : $1"
}


install_pre_packages() {
    log_message "Updating pre package lists and installing pre required packages."
    apt update &> $LOGFILE || error_handler "Failed to update pre package lists."
    apt install -y ufw gpg ssh curl git &> $LOGFILE || error_handler "Failed to install pre packages."
    log_message "Pre Packages updated and installed."
}

install_mongo() {
    if [ "$(command -v mongod)" ]; then
        echo "command \"mongod\" exists on system"
    else
        echo "deb [ arch=amd64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://mongodb.partdp.ir/apt/debian bookworm/mongodb-org/7.0 main" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list
        curl -fsSL https://mongodb.partdp.ir/static/pgp/server-7.0.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg
        apt update ; apt install -y mongodb-org &> $LOGFILE
        systemctl start mongod &> $LOGFILE; systemctl enable mongod &> $LOGFILE
    fi
}

install_nodejs() {
    if [ "$(command -v node)" ];
    then
        echo "command \"node\" exists on system"
    else
        echo "deb [trusted=yes] http://nodejs.partdp.ir/dist/node_20.x/ bookworm main" > /etc/apt/sources.list.d/node_20.x.list
        wget -qO - http://nodejs.partdp.ir/gpgkey/nodesource.gpg.key | apt-key add -
        apt update ; apt install -y nodejs
        npm config set registry https://npm.partdp.ir &> $LOGFILE
    fi
}


config_db (){
mongosh <<EOF
use $DB_NAME;
db.createUser({
    user: "$DB_USER",
    pwd: "$DB_PASS",
    roles: [{ role: "dbOwner", db: "$DB_NAME" }]
});
EOF
}

validate_db (){
mongosh -u "$DB_USER" -p "$DB_PASS" --authenticationDatabase "$DB_NAME" --eval "db.runCommand({ ping: 1 }); exit(0);" ;
if [ $? != 0 ]; then
    echo "MongoDB connection failed"
else
    echo "MongoDB connection successful"
fi
}


setup_anchr (){
    mkdir /var/data/anchr /var/log/anchr/ -p  &> $LOGFILE
    git clone https://github.com/muety/anchr &> $LOGFILE
    cd anchr &> $LOGFILE
    cat .env.example > .env ; &> $LOGFILE 
    sed -i 's/^#*ANCHR_DB_PASSWORD=.*/ANCHR_DB_PASSWORD="1234"/' .env &> $LOGFILE 
    sed -i 's/^#*LISTEN_ADDR=localhost.*/LISTEN_ADDR=0.0.0.0/' .env &> $LOGFILE
    source env.sh &> $LOGFILE
    corepack enable &> $LOGFILE
    yarn &> $LOGFILE
    cd public && ../node_modules/.bin/bower install && cd ..
}

start_anchr (){
    yarn start &> $LOGFILE
    yarn start:frontend &> $LOGFILE
}

# 2.Making a Unit file
cat <<EOF >> /etc/systemd/system/anchr.service
[Unit]
Description=Anchr Service
After=network.target

[Service]
ExecStart=/path/to/anchr
Restart=on-failure
User=anchruser
Group=anchrgroup

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload &> $LOGFILE
systemctl restart &> $LOGFILE




# 3.publish anchr port for the firewall 
# Function to set up firewall
configure_firewall() {
    apt update &> $LOGFILE
    apt install ufw -y &> $LOGFILE || error_handler "Failed to install ufw."
    log_message "Setting up the firewall."
    ufw --force enable &> $LOGFILE || error_handler "Failed to enable the firewall."
    ufw allow ssh &> $LOGFILE || error_handler "Failed to allow SSH through the firewall."
    log_message "Firewall configured and SSH allowed."
}
