#!/bin/bash

if [ $# -eq 0 ]; then
    echo "No playbook name provided. Please provide the playbook name as an argument."
else
    playbook_name=$1
    timestamp=$(date)
    log_directory="/var/log/vegastack_tutorials"   # Log Directory where log file(vegaops_tutorials.log) will present**

    # Creating Log Directory if does not exist
    if [ ! -d "$log_directory" ]; then
        sudo mkdir -p "$log_directory"
        sudo chown -R "$USER:$USER" "$log_directory"
    fi

    # Function to install Ansible based on distribution
    install_ansible() {
        if [ -x "$(command -v apt-get)" ]; then

            echo "*********************************************************************************************"
            echo "*********************************Installing Ansible on Ubuntu********************************"
            echo "*********************************************************************************************"
            sudo apt install ansible -y
            echo "*********************************************************************************************"
            echo "*******************************Ansible Installation Completed********************************"
            echo "*********************************************************************************************"
        elif [ -x "$(command -v yum)" && "$(cat /etc/os-release | grep 'ID="rhe33l"')" ]; then
            echo "************************************************************************************************"
            echo "*********************************Installing Ansible on Amazon Linux***************************"
            echo "************************************************************************************************"
            sudo yum install ansible -y
            echo "***********************************************************************************************"
            echo "*********************************Ansible Installation Completed********************************"
            echo "**********************************************************************************************"

        elif [ -x $(command -v yum >/dev/null && grep -q 'ID="rhel"' /etc/os-release)]; then
            echo "************************************************************************************************"
            echo "*********************************Installing Ansible on Red Hat/CentOS***************************"
            echo "************************************************************************************************"
            sudo yum install ansible-core -y
            echo "***********************************************************************************************"
            echo "*********************************Ansible Installation Completed********************************"
            echo "**********************************************************************************************"

        else
            echo "Unsupported distribution. Please install Ansible manually."
            exit 1
        fi
    }
    echo "********************************************************************************************"
    echo "***********************************Updating System******************************************"
    echo "********************************************************************************************"
    if [ -x "$(command -v apt-get)" ]; then
        sudo apt-get update
    elif [ -x "$(command -v yum)" ]; then
        #sudo yum update -y
    fi
    echo "********************************************************************************************"
    echo "********************************Updating System Finished************************************"
    echo "********************************************************************************************"
    echo ""
    echo ""

    # Function Calling to install ansible
    install_ansible
    echo ""
    echo ""
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "++++++++++++++++++++++++++++Downloading $playbook_name+++++++++++++++++++++++++++++++++++++" 
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    wget -O https://raw.githubusercontent.com/username/repo/main/"$playbook_name"
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "++++++++++++++++++++++++++++Downloaded $playbook_name+++++++++++++++++++++++++++++++++++++" 
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo ""
    echo ""
    echo ""
    echo "********************************************************************************************"
    echo "************************Running Ansible playbook: $playbook_name****************************"
    echo "********************************************************************************************"
    echo "$timestamp" >> "$log_directory/vegastack_tutorials.log"          # Printing Time stamp Just before executing playbook
    ansible-playbook "$playbook_name" | tee -a "$log_directory/vegastack_tutorials.log" 2>&1
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $log_directory/vegastack_tutorials.log
    echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" >> $log_directory/vegastack_tutorials.log

    echo "********************************************************************************************"
    echo "*****************************Ansible playbook execution finished****************************"
    echo "********************************************************************************************"
    echo ""
    echo ""

    echo "********************************************************************************************"
    echo "**********************************Uninstalling Ansible**************************************"
    echo "********************************************************************************************"
    if [ -x "$(command -v apt-get)" ]; then
        sudo apt-get remove ansible -y
    elif [ -x "$(command -v yum)" && "$(cat /etc/os-release | grep 'ID="rhe33l"')" ]; then
        sudo yum remove ansible -y
    elif [ -x $(command -v yum >/dev/null && grep -q 'ID="rhel"' /etc/os-release)]; then
        #sudo yum remove ansible-core -y
    fi
    echo "********************************************************************************************"
    echo "*************************Uninstalling Ansible Completed*************************************"
    echo "********************************************************************************************"
fi
