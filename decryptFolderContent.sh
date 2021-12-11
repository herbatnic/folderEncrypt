#!/bin/bash

cd toEncrypt

encDictionaryFile=`ls *.enc`

cat $encDictionaryFile | while read line 
do
	 decodedKeys=`echo $line | base64 -d | openssl rsautl -decrypt -inkey ../rsa_key.pri`
	 echo $decodedKeys
done




# string=`openssl rsautl -decrypt -inkey rsa_key.pri -in secret.dat `; echo $string

cd - > /dev/null
