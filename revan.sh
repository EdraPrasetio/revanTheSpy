
echo "I am Revan, Reborn!"
echo " "
DOMAIN_LIST="$@"

for i in $DOMAIN_LIST
do
    # Check if input is an ip address
    if [[ $DOMAIN_LIST =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]];
    then
        echo "it's a domain"
        i=$(nslookup $i | grep -E -i -w 'ca|com' | awk '{print $4}' | sort | uniq | rev | cut -d '.' -f -3 | rev)

    # Check if input is an email
    elif [[ $i == *[@]* ]];
    then
        i=$( echo $i | cut -d '@' -f2 )

    # Check if input is a website
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
    $whoisoutput | grep -E -i -w 'Registrant Name:|OrgName:' | head -n 1 | sed 's/^.*: //'
    echo " "

    echo "--Address--"
    $whoisoutput | grep -E -i -w 'address|City|Country' | sort | uniq
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
    