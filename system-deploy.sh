#!/bin/bash

set -e

function f_err {
    local _rc=$1 && shift
    local _msg=$*
    printf "[ ERROR ${_rc} ]t: ${_msg}"
    exit ${_rc}
} #/f_err{}

litTrue="true"
litFalse="false"

litInit="init"
litValidate="validate"
litPlan="plan"
litCreate="create"
litPlanDestroy="plan-destroy"
litDestroy="destroy"
litNothing="nothing"

actions=( "$litPlan", "$litCreate", "$litPlanDestroy", "$litDestroy" )

litPlanMsg="plan resource creation"
litCreateMsg="create planned resources"
litPlanDestroynMsg="plan resource destruction"
litDestroyMsg="destroy resources as planned"
litNothingMsg="do nothing"

# order matters: 'net' is built first and destroyed last
# 'iam' is built second and destroyed just before 'net'
# create runs left to right
# destroy runs right to left
all_layers=( "net" "iam" "c9net" "cluster" "nodeg" )
default_destination="net"

create_steps=( "$litInit" "$litPlan" "$litCreate" )
destroy_steps=( "$litInit" "$litPlanDestroy" "$litDestroy" )

plan_file="tfplan"

action="$litPlan"
msg="$litPlanMsg"

if [ -n "$1" ]; then
    if [ "$1" = "$litPlan" ]; then
        action="$litPlan"
        msg="$litPlanMsg"
        steps=( "${create_steps[@]}" )
    elif [ "$1" = "$litCreate" ]; then
        action="$litCreate"
        msg="$litCreateMsg"
        steps=( "${create_steps[@]}" )
    elif [ "$1" = "$litPlanDestroy" ]; then
        action="$litPlanDestroy"
        msg="$litPlanDestroynMsg"
        steps=( "${destroy_steps[@]}" )
    elif [ "$1" = "$litDestroy" ]; then
        action="$litDestroy"
        msg="$litDestroyMsg"
        steps=( "${destroy_steps[@]}" )
    else
        echo "Unknown action: $1.  Use one of ${litPlan}, ${litCreate}, ${litPlanDestroy}, ${litDestroy}"
        action="$litNothing"
        msg="$litNothingMsg"
        exit 1
    fi
else
    action="$litPlan"
    msg="$litPlanMsg"
    steps=( "${create_steps[@]}" )
fi

if [ -n "$2" ]; then
    for some_layer in ${all_layers[@]}; do
        if [ "$2" = "$some_layer"  ]; then 
            destination_layer=$2
            break
        fi
    done
    if [ -z "$destination_layer" ]; then 
        echo "Unknown layer: $2.  Use one of ${all_layers[@]}"
        exit 1
    fi
else 
    echo "No destination layer specified.  Using default layer ${default_layer}"
fi

layers=()
for i in ${!all_layers[@]}; do
        if [ "$action" = "$litPlan" ] || [ "$action" = "$litCreate" ]; then
            nextLayer=${all_layers[i]}
        else 
            iRev=$(( ${#array[@]} - 1 - ${i} ))
            echo "iRev=${iRev}"
            nextLayer=${all_layers[iRev]}
        fi
        layers+=( $nextLayer )
        
        if [ "$destination_layer" = "$nextLayer" ]; then
            break
        fi
    done
    
# pushd "tf-setup"
#     terraform validate
#     terraform plan -out tfplan
# popd

echo "This script will ${msg} for layers: ${layers[@]}"
read -p "Press enter to continue (^c to quit)"


echo "action: ${action}"

for layer in ${layers[@]};
  do
    pushd "$layer"
    rm -f "$plan_file"
    for step in ${steps[@]};
        do
            echo "Layer $layer Step ${step}"
            if [ "$step" = "$litInit" ]; then
                terraform init -upgrade
            elif [ "$step" = "$litPlan" ]; then
                terraform validate
                plan_out=$(terraform plan -out "$plan_file" 2>&1)
                echo "$plan_out"
                if [ -n $(echo "$plan_out" | grep "No changes. Your infrastructure matches the configuration.") ]; then 
                    # nothing to create
                    echo "No changes. Your infrastructure matches the configuration."
                    break;
                fi
            elif [ "$step" = "$litCreate" ]; then
                read -p "Press enter to $litCreate in layer $layer.  (^c to quit)"
                terraform apply "$plan_file"
            elif [ "$step" = "$litPlanDestroy" ]; then
                unset skippingPlanDestroy
                terraform state list || {
                    skippingPlanDestroy=litTrue
                    echo "layer is not initialized, skipping 'terraform plan -destroy'"
                }
                # error if this layer is not initialized, and has nothing to destroy
                if [ -z "$skippingPlanDestroy" ]; then
                    # we've got state
                    terraform plan -destroy -out "$plan_file"
                fi
            elif [ "$step" = "$litDestroy" ]; then
                unset skippingDestroy
                terraform state list || {
                    skippingDestroy=litTrue
                    echo "layer is not initialized, skipping 'terraform destroy'"
                }
                # error if this layer is not initialized, and has nothing to destroy
                if [ -z "$skippingDestroy" ]; then
                    # we've got state
                    read -p "Press enter to $litDestroy in layer $layer.  (^c to quit)"
                    terraform destroy
                fi
            else
                echo "Unexpected step value: $step"
                exit 1
            fi
            
            if [ "$step" = "$action" ]; then
                break
            fi
        done
        echo 
    popd
  done
