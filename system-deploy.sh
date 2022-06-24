#!/bin/bash

set -e

litTrue="true"
litFalse="false"

litInit="init"
litValidate="validate"
litPlan="plan"
litCreate="create"
litPlanDestroy="plan-destroy"
litDestroy="destroy"
litNothing="nothing"

litPlanMsg="plan resource creation"
litCreateMsg="create planned resources"
litPlanDestroynMsg="plan resource destruction"
litDestroyMsg="destroy resources as planned"
litNothingMsg="do nothing"

# layers=( "net" "iam" "c9net" "cluster" "nodeg" )
layers=( "net" )

create_steps=( "$litInit" "$litPlan" "$litCreate" )
destroy_steps=( "$litPlanDestroy" "$litDestroy" )

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
        echo "Unexpected parameter value: $1"
        action="$litNothing"
        msg="$litNothingMsg"
        exit 1
    fi
else
    action="$litPlan"
    msg="$litPlanMsg"
    steps=( "${create_steps[@]}" )
fi

echo "This script will ${msg} for layers: ${layers[@]}"
read -p "Press enter to continue (^c to quit)"

echo "action: ${action}"

for layer in "${layers[@]}";
  do
    read -p "Press enter to ${msg} in layer ${layer}.  (^c to quit)"
    pushd "$layer"
    rm -f "$plan_file"
    for step in "${steps[@]}";
        do
            echo "Step ${step}"
            if [ "$step" = "$litInit" ]; then
                terraform init
            elif [ "$step" = "$litPlan" ]; then
                terraform plan -out "$plan_file"
            elif [ "$step" = "$litCreate" ]; then
                terraform create "$plan_file"
            elif [ "$step" = "$litPlanDestroy" ]; then
                terraform plan -destroy -out "$plan_file"
            elif [ "$step" = "$litDestroy" ]; then
                terraform destroy "$plan_file"
            else
                echo "Unexpected step value: $step"
                exit 1
            fi
            
            if [ "$step" = "$action" ]; then
                break
            fi
        done
    popd
  done
