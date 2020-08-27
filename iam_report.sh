#!/bin/bash
# James Permenter
# jmp@linuxmail.org

PROFILE=$1;
declare -a groups=();
declare -a users=();

#users
users()
{
    aws iam list-users --output=table --profile=$PROFILE;
    printf "\n\n\n";

}

#groups attached to users
groups()
{
    for i in $(aws iam list-users --profile=$PROFILE | grep -i arn | awk -F '/' '{print $2}' | sed 's/"//g'| sed 's/,//g')
    do
	printf "%s\n" "User: $i"; 
	printf "%s\n " "Groups:";
	groups+=( "$(aws iam list-groups-for-user --user-name $i --profile=$PROFILE | grep -i groupname | awk -F ':' '{print $2}' | sed 's/"//g' | sed 's/,//g')" );
	aws iam list-groups-for-user --user-name $i --profile=$PROFILE | grep -i groupname | awk -F ':' '{print $2}' | sed 's/"//g' | sed 's/,//g';
	printf "\n";
    done;
    printf "\n\n\n";
}

group_attached_policies()
{

       for i in $(echo "${groups[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '); 
       do      
	       printf "Policies attached to $i group: ";
	       printf "\n\n";
	       aws iam list-attached-group-policies --group-name=$i --output=table --profile=$PROFILE;
       done;
       printf "\n\n\n";
}

group_policies()
{

       for i in $(echo "${groups[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '); 
       do      
	       printf "Group policies for $i: ";
	       printf "\n\n";
	       aws iam list-group-policies --group-name=$i --output=table --profile=$PROFILE;
       done;
       printf "\n\n\n";

}

user_attached_policies()
{
    for i in $(aws iam list-users --profile=$PROFILE | grep -i arn | awk -F '/' '{print $2}' | sed 's/"//g'| sed 's/,//g')
    do
	    printf "\n";
	    printf "%s\n" "User attached policies for: $i";
	    aws iam list-attached-user-policies --user-name=$i --output=table --profile=$PROFILE;
    done;
    printf "\n\n\n";
}


user_policies()
{
    
    for i in $(aws iam list-users --profile=$PROFILE | grep -i arn | awk -F '/' '{print $2}' | sed 's/"//g'| sed 's/,//g')
    do
	    printf "\n";
	    printf "%s\n" "User policies for: $i";
	    aws iam list-user-policies --user-name=$i --output=table --profile=$PROFILE;
    done;
    printf "\n\n\n";
}


title()
{
    cat << "EOF"


▄▀█ █░█░█ █▀   █ ▄▀█ █▀▄▀█   █▀█ █▀▀ █▀█ █▀█ █▀█ ▀█▀
█▀█ ▀▄▀▄▀ ▄█   █ █▀█ █░▀░█   █▀▄ ██▄ █▀▀ █▄█ █▀▄ ░█░
###################################################
EOF
echo $(date)
printf "\n\n"
}

users_title()
{
 
    cat << "EOF"

█░█ █▀ █▀▀ █▀█   ▄▀█ █▀▀ █▀▀ █▀█ █░█ █▄░█ ▀█▀ █▀
█▄█ ▄█ ██▄ █▀▄   █▀█ █▄▄ █▄▄ █▄█ █▄█ █░▀█ ░█░ ▄█
################################################

EOF
}

user_groups_title()
{
    cat << "EOF"

█░█ █▀ █▀▀ █▀█   █▀▀ █▀█ █▀█ █░█ █▀█ █▀
█▄█ ▄█ ██▄ █▀▄   █▄█ █▀▄ █▄█ █▄█ █▀▀ ▄█
#######################################

EOF
}

group_attach_title()
{
   cat << "EOF"
   
▄▀█ ▀█▀ ▀█▀ ▄▀█ █▀▀ █░█ █▀▀ █▀▄   █▀▀ █▀█ █▀█ █░█ █▀█   █▀█ █▀█ █░░ █ █▀▀ █ █▀▀ █▀
█▀█ ░█░ ░█░ █▀█ █▄▄ █▀█ ██▄ █▄▀   █▄█ █▀▄ █▄█ █▄█ █▀▀   █▀▀ █▄█ █▄▄ █ █▄▄ █ ██▄ ▄█
##################################################################################

EOF
}

group_direct_title()
{
    cat << "EOF"

█▀▄ █ █▀█ █▀▀ █▀▀ ▀█▀   █▀▀ █▀█ █▀█ █░█ █▀█   █▀█ █▀█ █░░ █ █▀▀ █ █▀▀ █▀
█▄▀ █ █▀▄ ██▄ █▄▄ ░█░   █▄█ █▀▄ █▄█ █▄█ █▀▀   █▀▀ █▄█ █▄▄ █ █▄▄ █ ██▄ ▄█
########################################################################

EOF
}

user_attach_title()
{
    cat << "EOF"
    
▄▀█ ▀█▀ ▀█▀ ▄▀█ █▀▀ █░█ █▀▀ █▀▄   █░█ █▀ █▀▀ █▀█   █▀█ █▀█ █░░ █ █▀▀ █ █▀▀ █▀
█▀█ ░█░ ░█░ █▀█ █▄▄ █▀█ ██▄ █▄▀   █▄█ ▄█ ██▄ █▀▄   █▀▀ █▄█ █▄▄ █ █▄▄ █ ██▄ ▄█
#############################################################################

EOF
}


user_direct_title()
{
    cat << "EOF"

█▀▄ █ █▀█ █▀▀ █▀▀ ▀█▀   █░█ █▀ █▀▀ █▀█   █▀█ █▀█ █░░ █ █▀▀ █ █▀▀ █▀
█▄▀ █ █▀▄ ██▄ █▄▄ ░█░   █▄█ ▄█ ██▄ █▀▄   █▀▀ █▄█ █▄▄ █ █▄▄ █ ██▄ ▄█    
###################################################################

EOF
}


eof()
{
    cat << "EOF"

█▀▀ █▀█ █▀▀
██▄ █▄█ █▀ ▄

EOF
}

main()
{   
    title;
    users_title;
    users;
    user_groups_title;    
    groups;
    group_attach_title;
    group_attached_policies;
    group_direct_title;
    group_policies;
    user_attach_title;
    user_attached_policies;
    user_direct_title;
    user_policies;
    eof;
}

main


