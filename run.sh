
if [ -z "$1" ]; then
    echo "please specify phone number for notification."
    exit -1
fi

PHONE=$1
echo "setting up " $PHONE

aws configure

INSTANCE=$(curl \
  http://169.254.169.254/latest/meta-data/instance-id)

aws sns publish \
  --phone-number $PHONE \
  --message "Starting to watch "$INSTANCE

RES="404"

while [ $RES -eq "404" ]; do 

  RES=$(curl -s -o /dev/null \
    -I -w "%{http_code}" \
    -I "http://169.254.169.254/latest/meta-data/spot/termination-time")

  printf "."
  sleep 10 

done

aws sns publish \
  --phone-number $PHONE \
  --message "You are done! "$INSTANCE" going to die!"
