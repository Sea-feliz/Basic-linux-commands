Linux:

  Basic:
    System Info:
        H/W
            - CPU
                $ cat /proc/cpuinfo
            - MEM 
                $ cat /proc/meminfo
            - DISK 
                $ sudo fdisk -l
        S/W
            - OS Vendor
            - OS Version
                $ cat /etc/*release
            - OS Arch
                $ uname -i 
                x86_64/x64              -> 64 bit 
                x86/i386,i586,i686      -> 32 bit
   
    User Notations:
      $ -> Normal User
      # -> Root User
      
    Linux Command Syntax:
        command-name {options} {inputs}
            ex: uname
                uname -i 
                cat /proc/cpuinfo

            Options:
                -(single character) , -i -x, -s
                --(single word) , --help, --verbose

            Default option for all commands : --help

    Linux Commands help:

    List files & Dir: 
        $ ls
        $ ls -l     <-- Shows long list
        
        Type of file can be determined by ls -l command and the first character denotes that.
          - -> Regular File
          d -> directory 
        Note: There are total 7 types of files, Explore them.
        
    Files:
        Create file     - touch 
        Remove file     - rm
        Rename a file   - mv
          $ mv source target
            1) If target does not exist ??
              Rename the file 
            2) If target exists ??
              Overwrite the file (1. Remove target , 2. Rename Source to target )
            3) If target exists and if it is a directory.
              Moves file into target directory 
        Copy a file     - cp

    Directories:
        Linux Directory Structure
        / -> Root Directory 
        
        (Explore linux default directories and their purpose https://www.thegeekstuff.com/2010/09/linux-file-system-structure/ )
        Switch from one directory 
          $ cd
                1) cd  -> Takes you to your home directory 
                2) cd / -> Take you to `/` directory
                3) cd - -> Takes you to previous working directory
                4) cd ..  -> Takes to parent directory (.. denotes parent directory,   . denotes present directory)
                
          $ pwd 

        Create Directory 
          $ mkdir dir-name
        Remove a Directory 
          $ rm  -r dir-name
        Rename Directory 
          $ mv dir-name new-dir-name
              1) If new-dir-name does not exist ?? 
                  It is just renaming directory 
              2) If new-dir-name already exists ??
                  It is going to move the directory into new-dir-name
                  
        Copy a Directory 
          $ cp -r source-dir remote-dir
          
        Move files from one dir to another
        Copy file from one dir to another
    
    Editor:
      ->  vi / vim / nano / gedit 
      *** vi / vim 
Image of VI Editor: image

    Search Files & Directories:
      1. Find Command.  
          $ find /etc "*.conf"
          $ find /home/ec2-user -name "*.conf" -type f
          $ find /home/ec2-user -name "*.conf" -type d
          
      2. Locate command.
         locate command will not be there by default , hence lets install and use it.
          $ sudo yum install mlocate -y
          $ sudo updatedb
          
          $ locate "*.conf"
          $ locate "*.conf" | grep /home
    Filter Commands:
      Perform this command before going with commands.
        $ sudo cp /var/log/messages .;sudo chmod 666 messages
      -> cat 
        $ cat messages
      -> wc 
        $ wc -l  messages
        $ wc -c  messages
      -> head
        $ head messages
        $ head -2 messages
      -> tail 
        $ tail messages
        $ tail -n 2 messages
      -> grep 
        $ grep yum messages 
        $ grep yum messages
      -> cut
        $ cut -d ':' -f 1 /etc/passwd
      
    Utilities:
      wget command is not there by default in linux, Hence install it.
      $ sudo yum install wget -y
      -> wget 
        $ wget http://www-eu.apache.org/dist//httpd/httpd-2.4.33.tar.gz
        
      -> curl 
        Curl is command to browse over CLI.
        $ curl <URL>
        
      -> tar 
          $ tar -xz httpd-2.4.33.tar.gz 
          
          .gz  -> Gunzip
          .bz2  -> Bunzip2 
            Bzip2 is not available in system by default, Install it using the following command.
            
          $ sudo yum install bzip2 -y
          
      -> Check size of the file 
          $ ls -lh 
          
      -> Check the size of the directory & files
          $ du  -sh *
      
      -> Pipes  (|) 
image

  Admin:
  
    Before starting any admin commands, become a root user to perform admin activities.
    
    $ sudo su - 
    
    How to stop a server:
      # init 0
      # shutdown -h 
      # halt
      
    How to restart a server:
      # init 6
      # reboot
      # shutdown -r
    
    validate system reboot by using 
      $ uptime
    
    Package Management:
      Installation of softwares are three types.
      1) RPM based installation (EXE based installation)
        Redhat package manager / RPM package manager
        # rpm <- Managing rpm's / But this is not used now.
        
        # yum <- Yellowdog Updated Modifier
        
        List Packages
          local (installed packages)
              # yum list installed
          remote (not installed, but are available to install)
              # yum list available 
          both (local & remote)
              # yum list {or} # yum list all 
         
        Install Package 
            # yum install package-name -y
            
        Remove a Package
            # yum remove pacakge-name -y
            # yum erase package-name -y
            
        Update a Package 
            # yum check-update 
            # yum update pack-name -y
            # yum upgrade pack-name -y
            
            # yum update -y
              -> This is to apply all package updates.
            
      2) Binary Installation  <- Will be discussed in project
      3) Source based Installation <- Will be discussed in project
      
    Service Management:
      CentOS7:
        # systemctl list-units -a -t service  <- To list services which are enabled
        # systemctl list-unit-files -a 
        # systemctl status service-name 
        # systemctl start service-name
        # systemctl stop service-name
        # systemctl restart service-name
        
        # systemctl enable service-name
        # systemctl disable service-name
        
      CentOS6:
        # service service-name status
        # service service-name start
        # service service-name stop
        # service service-name restart 
        
        # chkconfig --list    <- To list all the services
        # chkconfig service-name on
        # chkconfig service-name off
        
        
    User Management:
        - Groups
          # groupadd group-name
          Above command will add a group, but to verify group is added or not.. Run the following commands
          # getent group
          
          # groupdel
          # groupmod
          
        - Users
          # useradd -g devops raju 
          Check user created or not.
          # id raju
          # getent passwd 
          
          # usermod 
          # userdel
          
          To switch from one user  to another user 
          $ su - username <- It asks for password if you are normal user
          
          To set/reset the password for a user, 
          # passwd raju          
        
        - Sudoers
          # visudo
          
          rahim ALL=(ALL) NOPASSWD: ALL
        
        - File/Dir Permissions

    Disk Management:
      # fdisk -l
      # df -h
    Network Management:
      # ip a
      # netstat -lntp 
    Process Management
      # ps -ef 
      # ps -ef | grep proccess-name
      # kill <PID>
