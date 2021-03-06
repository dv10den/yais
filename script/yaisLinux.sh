#!/bin/sh
INSTALLPYOIDC="n"
INSTALLPYSAML2="n"
INSTALLSAML2TEST="n"
INSTALLBASE="n"
if [$1 = "-h"]
then
    echo "usage: yaisLinux.sh install_path [group]"
fi
if [ ! -d "$1" ]; then
  echo $1 is not a directory!
  echo "usage: yaisLinux.sh install_path [group]"
  exit
fi
basePath=$1
echo "Do you want to install IdPproxy (Y/n):"
read INSTALLIDPPROXY
if [ $INSTALLIDPPROXY = "Y" ]
then
    INSTALLPYOIDC="Y"
    INSTALLPYSAML2="Y"
    INSTALLBASE="Y"
fi
echo "Do you want to install saml2test (Y/n):"
read INSTALLSAML2TEST
if [ $INSTALLSAML2TEST = "Y" ]
then
    INSTALLPYSAML2="Y"
    INSTALLBASE="Y"
fi
if [ $INSTALLPYOIDC != "Y" ]
then
    echo "Do you want to install pyoidc (Y/n):"
    read INSTALLPYOIDC
    if [ $INSTALLPYOIDC = "Y" ]
    then
        INSTALLBASE="Y"
    fi
fi
if [ $INSTALLPYSAML2 != "Y" ]
then
    echo "Do you want to install pysaml2 (Y/n):"
    read INSTALLPYSAML2
    if [ $INSTALLPYSAML2 = "Y" ]
    then
        INSTALLBASE="Y"
    fi
fi
if [ $INSTALLBASE = "Y" ]
then
    sudo apt-get install python-setuptools
    sudo apt-get install python-dev
    sudo easy_install pip
    sudo apt-get install swig
    sudo easy_install mako
    #sudo apt-get install python-m2crypto
    installM2CryptoLinux.sh
    ############################################################
    echo "______________________________________________________"
    echo "Installing pyjwkest..."
    pyjwkestPath="$basePath/pyjwkest"
    sudo rm -fr $pyjwkestPath
    git clone https://github.com/rohe/pyjwkest $pyjwkestPath
    cd $pyjwkestPath
    echo "Running setup.py (this can take a while)."
    sudo python setup.py install > /dev/null 2> /dev/null
    echo "pyjwkest installed"
fi
############################################################
echo "______________________________________________________"
if [ $INSTALLPYOIDC = "Y" ]
then
    echo "Installing pyoidc..."
    pyoidcPath="$basePath/pyoidc"
    sudo rm -fr $pyoidcPath
    git clone https://github.com/rohe/pyoidc $pyoidcPath
    cd $pyoidcPath
    echo "Running setup.py (this can take a while)."
    sudo python setup.py install > /dev/null 2> /dev/null
    sudo apt-get install python-ldap
    sudo pip install python-ldap
    echo "pyoidc installed"
else
    echo "Skipping pyoidc."
fi
############################################################
echo "______________________________________________________"
if [ $INSTALLPYSAML2 = "Y" ]
then
    echo "Installing pysaml2"
    pysaml2Path="$basePath/pysaml2"
    echo " into the $path $pysaml2Path"
    sudo rm -fr $pysaml2Path
    git clone https://github.com/rohe/pysaml2 $pysaml2Path
    cd $pysaml2Path
    echo "Running setup.py (this can take a while)."
    sudo python setup.py install > /dev/null 2> /dev/null
    sudo easy_install repoze.who
    sudo easy_install ElementTree
    sudo apt-get install python-dateutil libxmlsec1 xmlsec1 libxmlsec1-openssl libxmlsec1-dev
    sudo apt-get install libxml2
    sudo apt-get install libtool
    echo "pysaml2 installed"
else
    echo "Skipping pysaml2."
fi
############################################################
echo "______________________________________________________"
if [ $INSTALLSAML2TEST = "Y" ]
then
    # Install saml2test
    echo "Installing saml2test"
    saml2testPath="$basePath/saml2test"
    echo " into the $path $saml2testPath"
    sudo rm -fr $saml2testPath
    git clone https://github.com/rohe/saml2test $saml2testPath
    cd $saml2testPath
    echo "Running setup.py (this can take a while)."
    sudo python setup.py install > /dev/null 2> /dev/null


    # Installing saml2testGui
    saml2testGuiPath="$basePath/saml2testGui"
    echo " into the $path $saml2testGuiPath"
    sudo rm -fr $saml2testGuiPath
    git clone https://github.com/HaToHo/saml2testGui $saml2testGuiPath
    cd $saml2testGuiPath
    echo "Running setup.py (this can take a while)."
    sudo python setup.py install > /dev/null 2> /dev/null

    echo "saml2test installed"
else
    echo "Skipping saml2test."
fi
############################################################
echo "______________________________________________________"
if [ $INSTALLIDPPROXY = "Y" ]
then
    echo "Installing IdPproxy..."
    oauthPath="$basePath/python-oauth2"
    sudo rm -fr $oauthPath
    git clone https://github.com/simplegeo/python-oauth2 $oauthPath
    cd $oauthPath
    echo "Running setup.py (this can take a while)."
    sudo python setup.py install > /dev/null 2> /dev/null
    IdPproxyPath="$basePath/IdPproxy"
    sudo rm -fr $IdPproxyPath
    git clone https://github.com/rohe/IdPproxy $IdPproxyPath
    cd $IdPproxyPath
    echo "Running setup.py (this can take a while)."
    sudo python setup.py install > /dev/null 2> /dev/null
    echo "IdPproxy installed"
else
    echo "Skipping IdPproxy."
fi
############################################################
if [ $INSTALLPYSAML2 = "Y" ]
then
    configureSaml.sh $basePath
fi