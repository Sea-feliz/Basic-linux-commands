#!/bin/bash

#URL configuration
TOMCAT_URL="https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.6/bin/apache-tomcat-9.0.6.tar.gz"
TOMCAT_DIR=$(echo $TOMCAT_URL | awk -F / '{print $NF}' | sed -e 's/.tar.gz//')
JDBC_URL="https://github.com/cit-aliqui/APP-STACK/raw/master/mysql-connector-java-5.1.40.jar"
CONN_STRING='<Resource name="jdbc/TestDB" auth="Container" type="javax.sql.DataSource" maxActive="50" maxIdle="30" maxWait="10000"
username="student" password="student@1" driverClassName="com.mysql.jdbc.Driver" url="jdbc:mysql://IPADD:3306/studentapp"/>'
IPADD=$(hostname -i)
CONN_STRING=$(echo $CONN_STRING| sed -e "s/IPADD/$IPADD/")
STUDENT_URL="https://github.com/cit-aliqui/APP-STACK/raw/master/student.war"
MODJK='https://github.com/cit-astrum/project-manual/raw/master/mod_jk.so'
#functions
HEAD () {

	echo -e "\e[32m$1\e[0m"
}
##instllsation progress
PROGRESS () {

	echo -e "\t -> \e[34m$1\e[0m"
}
##instllsation status
status () {

if [ $? = 0 ];
then
	echo -e  "\t ->\e[35mCompleted\e[0m"
else
	echo "Failure, Please check the log file for errors"
fi

}
##main program

id=$(id -u)
if [ $id -ne 0 ];
then
	echo "Please login with sudo login account details"
	exit 1
fi

#DB instllsation
DBF () {
HEAD "DB Server will start installsation"
PROGRESS "DB installsation is in progress"
yum install mariadb-server -y &>>log
status $?
systemctl enable mariadb &>>log
echo -e "\t ->\e[37mDB serveice enabled\e[0m"
systemctl start mariadb &>>log
echo -e "\t ->\e[36mDB service started\e[0m"

echo "create database if not exists studentapp;
use studentapp;
    CREATE TABLE if not exists Students(student_id INT NOT NULL AUTO_INCREMENT,
        student_name VARCHAR(100) NOT NULL,
        student_addr VARCHAR(100) NOT NULL,
        student_age VARCHAR(3) NOT NULL,
        student_qual VARCHAR(20) NOT NULL,
        student_percent VARCHAR(10) NOT NULL,
        student_year_passed VARCHAR(10) NOT NULL,
        PRIMARY KEY (student_id)
    );
    grant all privileges on studentapp.* to 'student'@'%' identified by 'student@1';
    flush privileges;" >/tmp/student.sql 

mysql </tmp/student.sql
status $?

}

##webserver instllsation
WEBF () {

HEAD "Web server"
PROGRESS "instllsation is in progress"
yum install java -y &>>log
status $?
echo "java installed"
yum install httpd -y &>>log
status $?
echo "will install mod.so file"
wget $MODJK -O /etc/httpd/modules/mod_jk.so &>>log
echo "Installed mod.so file"
chmod 777 /etc/httpd/modules/mod_jk.so &>>log

echo "will create mod conf"

echo 'LoadModule jk_module modules/mod_jk.so
JkWorkersFile conf.d/worker.properties
JkMount /student local
JkMount /student/* local' >/etc/httpd/conf.d/mod-jk.conf
echo "created mod conf file"

echo "will create workes prop file"
echo 'worker.list=local
worker.local.host=localhost
worker.local.port=8009' >/etc/httpd/conf.d/worker.properties
echo "created worker prop file"
status $?

echo "server enabled"
systemctl enable httpd &>>log
status $?
echo "server started"
systemctl start httpd &>>log

}

#Application server instllsation

APPF () {

HEAD "Application server"
PROGRESS "Application server installsation in progress"
cd /opt/
wget -qO- $TOMCAT_URL | tar -xz &>>log
status $? &>>log

echo "App file downloading"
wget $STUDENT_URL -O $TOMCAT_DIR/webapps/student.war &>>log
status $?

echo "Will start downloading the JDBC connector"
wget $JDBC_URL -O $TOMCAT_DIR/lib/mysql-connector-java-5.1.40.jar &>>log
status $?

echo "will update the content xml"
sed -i -e '/TestDB/ d' -e "$ i $CONN_STRING" $TOMCAT_DIR/conf/context.xml
status $?

PROGRESS "starting Tomcat server"
sh $TOMCAT_DIR/bin/startup.sh &>>log
status $?

}

##case to select the operation to do
echo "Please select the option to perform"
read command

case $command in 
	db) DBF ;;
	app) APPF ;;
	web) WEBF ;;
	all) DBF
		 APPF
		 WEBF
		 ;;
esac
