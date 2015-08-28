#!/usr/bin/python -O
###################################
# zpackdb Script
# (c) 2010 by Niels Dettenbach 
# licensed by GPL v2

import sys, urllib, os, shutil
from time import *

###################################
# bitte konfigurieren / please configure

username="zope"
password="zope"
zope="http://localhost:8080"

###################################

class NoGUI_URLopener(urllib.FancyURLopener):
   def __init__(self, username, password, *args):
      apply(urllib.FancyURLopener.__init__, (self,) + args)

      self.username = username
      self.password = password
      self.asked = 0

   def prompt_user_passwd(self, host, realm):
      if self.asked:
         raise "Unauthorised"
      else:
         self.asked = 1
         return self.username, self.password

data = urllib.urlencode({ "days:float" : "10" })
url = zope+'/Control_Panel/Database/main/manage_pack'
urllib._urlopener = NoGUI_URLopener(username, password)
http = urllib.urlopen(url, data)
