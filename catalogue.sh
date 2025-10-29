#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
W="\e[0m"


LOGS_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
MONGODB_HOST=mongodb.anitha.fun
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
#------NODEJS------#
dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "disabling nodejs"
dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? "enabling nodejs"
dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? "installing nodejs"
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
VALIDATE $? "creating system user"
mkdir /app 
VALIDATE $? "creating app directory"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue-v3.zip &>>$LOG_FILE
VALIDATE $? "creating catalogue application"
cd /app 
VALIDATE $? "changeing the app directory"
unzip /tmp/catalogue.zip &>>$LOG_FILE
VALIDATE $? "unzip catalogue"
npm install &>>$LOG_FILE
VALIDATE $? "install dependencies"
cp catalogue.service /etc/systemd/system/catalogue.service
VALIDATE $? "copy systemctl service"
systemctl daemon-reload
systemctl enable catalogue &>>$LOG_FILE
VALIDATE $? "enable catalogue"
cp mongo.repo /etc/yum.repos.d/mongo.repo 
VALIDATE $? "copy mongo repo"
dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "install mongodb client"
mongosh --host $MONGODB_HOST </app/db/master-data.js &>>$LOG_FILE
VALIDATE $? "load catalogue products"
systemctl reatart catalogue
VALIDATE $? "restarted catalogue"




