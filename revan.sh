
echo "I am Revan, Reborn!"
echo " "
DOMAIN_LIST="$@"

if [[ $DOMAIN_LIST =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]];
then
    for i in $DOMAIN_LIST
    do
        echo "--Domain--"
        dig -x $i +noall +answer | awk '{print $5}'

        whoisoutput=$"whois $i"

        $whoisoutput | grep 'Country'| head -n 1
        $whoisoutput | grep 'City' | head -n 1

        echo " "
    done
else
    for i in $DOMAIN_LIST
    do
        # Check if domain is an IP address
    

        # Check if domain is an email
        if [[ $i == *[@]* ]];
        then
            i=$( echo $i | cut -d '@' -f2 )

        # Check if domain is a website
        elif [[ $i == *[www]* ]];
        then
            echo "it's a website"
            i=$( echo $i | cut -c 5- )
        fi
        echo "--Domain--"
        echo $i 
        whoisoutput=$"whois $i"
        echo " "

        echo "--Domain ID--"
        $whoisoutput | grep 'Domain ID'| head -n 1 | awk '{print $4}'
        echo " "

        echo "--Organization Name--"
        $whoisoutput | grep 'Registrant Name:' | head -n 1 | sed 's/^.*: //'
        echo " "

        echo "--Country--"
        $whoisoutput | grep 'Registrant Country:'| head -n 1 
        echo " "

        echo "--City--"
        $whoisoutput | grep 'Registrant City:' | head -n 1 
        echo " "

        echo "--Phone Number--"
        $whoisoutput | grep 'Phone' | grep -Ev '(Ext)' | sort | uniq
        echo " "

        echo "--email--"
        $whoisoutput | grep 'Email' | sort | uniq
        echo " "

        echo "--Creation Date--"
        $whoisoutput | grep 'Creation Date' | head -n 1 | awk '{print $3}'
        echo " "

        echo "--Expiration Date--"
        $whoisoutput | grep 'Expiry Date' | head -n 1 | awk '{print $4}'
        echo " "

        echo "--Time to live--"
        dig +noall +answer $i | awk '{print $2}' | head -n 1
        echo " "

        echo "--SPF and DMARC--"
        dig txt_spf.$i | grep 'SOA' | awk '{print $5}'
        dig txt_spf.$i | grep 'SOA' | awk '{print $6}'
        echo " "

        echo "--Server IP Addresses--"
        foundIP=$"$whoisoutput | grep 'Name Server'| awk '{print $3}'"
        for index in $foundIP
        do
            dig $index +short
        done
        echo " "

        echo "--Trace Route--"
        traceroute $i
        echo " "
        
        echo " "
    done
fi
    