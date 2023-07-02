#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SECRET_ENCRYPTED_ROOT=deploy/secret
SECRET_DECRYPTED_ROOT=deploy/secret-decrypted

# Key is configured in the ansible inventory and deployed on the controller by kubernetes_controller_bootstrap
export SOPS_AGE_KEY_FILE=/root/.sops/key.txt

function encrypt_all() {
    echo "Encrypting all files"
    if [ ! -d $SECRET_DECRYPTED_ROOT ] ; then
        echo "No decrypted folder, nothing to do"
        return
    fi
    find $SECRET_DECRYPTED_ROOT -type f | while read file ; do
        relFile=$(echo $file | sed "s|$SECRET_DECRYPTED_ROOT/||")
        targetFile=$(echo $file | sed "s|$SECRET_DECRYPTED_ROOT|$SECRET_ENCRYPTED_ROOT|")
        targetFolder=$(dirname $targetFile)
        echo "- $relFile"
        mkdir -p $targetFolder
        
        sopsParams="-e"

        customTypeConf=$(grep "^$relFile:type:" .sops.config 2>/dev/null)
        if [ $? -eq 0 ] ; then
            customType=$(echo $customTypeConf | cut -d: -f3)
            echo "Forcing custom type $customType"
            sopsParams=$sopsParams" --input-type $customType"
        fi
        
        sops $sopsParams $file > $targetFile
    done
}

function decrypt_all() {
    echo "Decrypting all files"
    if [ ! -d $SECRET_ENCRYPTED_ROOT ] ; then
        echo "No encrypted folder, nothing to do"
        return
    fi
    find $SECRET_ENCRYPTED_ROOT -type f | while read file ; do
        relFile=$(echo $file | sed "s|$SECRET_ENCRYPTED_ROOT/||")
        targetFile=$(echo $file | sed "s|$SECRET_ENCRYPTED_ROOT|$SECRET_DECRYPTED_ROOT|")
        targetFolder=$(dirname $targetFile)
        echo "- $relFile"
        mkdir -p $targetFolder
        
        sopsParams="-d"

        customTypeConf=$(grep "^$relFile:type:" .sops.config 2>/dev/null)
        if [ $? -eq 0 ] ; then
            customType=$(echo $customTypeConf | cut -d: -f3)
            echo "Forcing custom type $customType"
            sopsParams=$sopsParams" --output-type $customType"
        fi

        sops $sopsParams $file > $targetFile
    done
}

app="$1"
mode="$2"

if [ -z $app ] ; then
    echo "Missing 1st mandatory parameter app"
    exit 1
elif [ ! -d $SCRIPT_DIR/$app ] ; then
    echo "Invalid 1st parameter app, $SCRIPT_DIR/$app doesn't exist"
fi

cd $SCRIPT_DIR/$app

if [ -z $mode ] ; then
    echo "Missing 2nd mandatory parameter mode"
    exit 1
fi

case $mode in
    e|encrypt)
        encrypt_all
        ;;
    d|decrypt)
        decrypt_all
        ;;
    *)
        echo "First parameter must be e(ncrypt), or d(ecrypt), '$mode' is incorrect"
        ;;
esac
