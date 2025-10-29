#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
W="\e[0m"


LOGS_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
#echo "13-logs.sh" | cut -d "." -f1
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

USERID=$(id -u)

if [ $USERID  -ne 0 ]; then
    echo -e "error :: run with root privelege"
    exit 1
fi

mkdir -p $LOGS_FOLDER
echo "script started at $(date)" | tee -a $LOG_FILE

VALIDATE(){ # dont execute by itself ,executes only when called
 if [ $1 -ne 0 ]; then
    echo -e "error::  $1  $R failure $W" | tee -a $LOG_FILE
    exit 1
 else 
    echo -e " $2 is $G success-full $W" | tee -a $LOG_FILE
fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Adding mongo repo"

dnf install mongodb-org -y &>>$LOG_FILE
VALIDATE $? "Installing MongoDB"

systemctl enable mongod &>>$LOG_FILE
VALIDATE $? "Enable MongoDB"

systemctl start mongod 
VALIDATE $? "Start MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Allowing remote connections to MongoDB"


systemctl restart mongod
VALIDATE $? "Restarted MongoDB"