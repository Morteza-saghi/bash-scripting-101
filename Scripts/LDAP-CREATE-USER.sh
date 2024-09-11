#!/bin/sh
# -------- SET LDAP ----------------------------------------------
LDAP_URI="here"
BIND_DN="here"
BIND_PW="here"

# Assigning the positional parameters to variables
OU=$1           # Organizational Unit
USER=$2         # Username
PASS=$3         # Password
NODISK_NUMBER=$4 # Some identifier (like a department number)
GROUP=$5        # Group

echo "Starting LDAP User Creation for $USER in $OU..."

sleep 2

# -------- SET OU ----------------------------------------------
touch ./temp/${OU}_ou.ldif
echo "dn: ou=$OU,ou=users,dc=abrish,dc=org" >> ./temp/${OU}_ou.ldif
echo "objectClass: organizationalUnit" >> ./temp/${OU}_ou.ldif
echo "ou: $OU" >> ./temp/${OU}_ou.ldif
# -------- END SET OU ------------------------------------------
# --------------------------------------------------------------

# -------- SET USER --------------------------------------------
touch ./temp/${OU}_user.ldif
echo "dn: cn=$USER,ou=$OU,ou=users,dc=abrish,dc=org" >> ./temp/${OU}_user.ldif
echo "objectClass: inetOrgPerson" >> ./temp/${OU}_user.ldif
echo "cn: $USER" >> ./temp/${OU}_user.ldif
echo "sn: $USER" >> ./temp/${OU}_user.ldif
echo "departmentNumber: $NODISK_NUMBER" >> ./temp/${OU}_user.ldif
echo "displayName: $USER" >> ./temp/${OU}_user.ldif
# -------- END SET USER ----------------------------------------
# --------------------------------------------------------------

# -------- SET GROUP -------------------------------------------
sleep 1
touch ./temp/${OU}_group.ldif
echo "dn: cn=$GROUP,ou=$OU,ou=users,dc=abrish,dc=org" >> ./temp/${OU}_group.ldif
echo "objectClass: groupOfNames" >> ./temp/${OU}_group.ldif
echo "cn: $GROUP" >> ./temp/${OU}_group.ldif
echo "member: cn=$USER,ou=$OU,ou=users,dc=abrish,dc=org" >> ./temp/${OU}_group.ldif
# -------- END SET GROUP ---------------------------------------

# ------- CREATE Organizational Unit ----------------------------
echo "Creating Organizational Unit..."
ldapadd -x -H $LDAP_URI -D $BIND_DN -w "$BIND_PW" -f ./temp/${OU}_ou.ldif
if [ $? -eq 0 ]; then
  echo "Organizational Unit created successfully."
else
  echo "Error creating Organizational Unit."
fi
sleep 1
# ------- END CREATE Organizational Unit ------------------------

# ------- CREATE USER -------------------------------------------
echo "Creating User $USER..."
ldapadd -x -H $LDAP_URI -D $BIND_DN -w "$BIND_PW" -f ./temp/${OU}_user.ldif
if [ $? -eq 0 ]; then
  echo "User created successfully."
else
  echo "Error creating User."
fi
sleep 1
# ------- END CREATE USER ---------------------------------------

# ------- CREATE GROUP & ADD USER -------------------------------
echo "Creating Group and adding $USER to the group..."
ldapadd -x -H $LDAP_URI -D $BIND_DN -w "$BIND_PW" -f ./temp/${OU}_group.ldif
if [ $? -eq 0 ]; then
  echo "Group created successfully and user added to the group."
else
  echo "Error creating group."
fi
sleep 1

# ------- SET PASSWORD ------------------------------------------
echo "Setting password for $USER..."
USER_DN=$(grep '^dn: ' ./temp/${OU}_user.ldif | sed 's/dn: //')
ldappasswd -H $LDAP_URI -D $BIND_DN -w "$BIND_PW" -S "$USER_DN" -s "$PASS"
if [ $? -eq 0 ]; then
  echo "Password set successfully for $USER."
else
  echo "Error setting password."
fi

echo "LDAP user creation completed for $USER."
