#!/bin/bash
MAHARA_ROOT=/var/www/html/mahara

mkdir /tmp/mahara-plugins && cd /tmp/mahara-plugins

## Artefact

## Adminmessage by TU Darmstadt
git clone https://gitorious.org/didaktik-tu-darmstadt/adminmessage.git
cp -ax adminmessage/artefact/adminmessage $MAHARA_ROOT/artefact/
chown -R www-data:www-data  $MAHARA_ROOT/artefact/adminmessage

## Groupmessages by TU Darmstadt
git clone https://gitorious.org/didaktik-tu-darmstadt/groupmessages.git
cp -ax groupmessages/artefact/groupmessages $MAHARA_ROOT/artefact/
chown -R www-data:www-data  $MAHARA_ROOT/artefact/groupmessages

## Blocktype

## QR-Code-Generator by Emanuel Garcês
git clone https://github.com/effgarces/QR-Code-Generator.git
cp -ax QR-Code-Generator/qrcode $MAHARA_ROOT/blocktype/
chown -R www-data:www-data $MAHARA_ROOT/blocktype/qrcode

## LinkedIn Profil by Gregor Anželj 
wget  --content-disposition  'https://mahara.org/artefact/file/download.php?file=181557&view=35645'
unzip linkedinprofile*
cp -ax linkedinprofile $MAHARA_ROOT/blocktype/ 
chown -R www-data:www-data $MAHARA_ROOT/blocktype/linkedinprofile

## Clean
rm -r /tmp/mahara-plugins
