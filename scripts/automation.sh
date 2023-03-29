#!/bin/bash

# format to use:
# ./automation.sh

start_time=`date +%s`

FILE=../.env
if [ ! -f "$FILE" ]; then
    echo "$FILE does not exist"
    cp ../.env.example ../.env
    echo "Update your ENV VARS!"
    nano ../.env
    exit 1
else 
    echo "$FILE exists"
fi

PS3='Choose an option by entering a # and [Enter]: '

choices=("Test Locally - Setup" "Test Locally - Update" "Deployment - Initial Run" "Deployment - Update" "Deployment - Update Secrets" "Deployment - Update with Admin UI Recompile" "Cleanup" "Nuke Everything" "Exit")

select automation in "${choices[@]}"; do
    case $automation in
        "Test Locally - Setup")

            break
            ;;
        "Test Locally - Update")

            break
            ;;
        "Deployment - Initial Run")
            echo "Parsing ENV VARS"
            source ./parse-env.sh

            # echo "Create GCloud Instance"
            # gcloud compute instances create $SERVICE_NAME \
            #     --project=$GCLOUD_PROJECT \
            #     --zone=$GCLOUD_ZONE \
            #     --image-family=$VM_IMAGE
            #     --custom-cpu=2 \
            #     --custom-memory=5

            gcloud compute ssh \
                --zone=$GCLOUD_ZONE $SERVICE_NAME \
                --project=$GCLOUD_PROJECT
                
            ls

            break
            ;;
        "Deployment - Update")

            break
            ;;
        "Deployment - Update Secrets")

            break
            ;;
        "Deployment - Update with Admin UI Recompile")

            break
            ;;
        "Cleanup")

            break
            ;;
        "Nuke Everything")

            break
            ;;
        "Exit")
            echo "User requested exit"
            exit
            ;;
        *) echo "invalid option $REPLY";;
    esac
done

echo "EL FIN!"

end_time=`date +%s`
runtime=$((end_time-start_time))
runtime_min=$((runtime/60))
runtime_secs=$((runtime%60))
echo "runtime: $runtime_min minutes and $runtime_secs seconds"