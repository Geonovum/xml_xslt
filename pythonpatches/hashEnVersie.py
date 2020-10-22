"""
Aanpassen alle files voor versie
zie nwVersie

"""

import re
import os
#from xml.dom import pulldom
import xml.dom.minidom
import hashlib
import argparse

def sha512(fileName):
    hash_sha512 = hashlib.sha512()
    with open(fileName, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_sha512.update(chunk)
    return hash_sha512.hexdigest()


#set global vars
class Globals : #do not use for inheritance or instances
   xmlDoc = None
   path = None
   nwVersie = "1.0.3"

def firstElementInNodeList(nodeList) :
   for node in nodeList :
      if (node.nodeType == xml.dom.Node.ELEMENT_NODE) : 
         return node
   return None   

def firstSiblingElement(node) :
   while node :
      node = node.nextSibling
      if (node.nodeType == xml.dom.Node.ELEMENT_NODE) : 
         return node
   return None   

def correctSchemaVersion(filename) :
   #print("processing ",filename)
   topEl = Globals.xmlDoc.documentElement
   #verwijder xsi:schemaLocation
   locationRW = False
   if (topEl.hasAttribute("xsi:schemaLocation")) :
      topEl.removeAttribute("xsi:schemaLocation")
      locationRW = True
   #set de goede versie
   if (topEl.hasAttribute("schemaversie")) :
      topEl.setAttribute("schemaversie", Globals.nwVersie)
      return True
   else :
      print(filename, " heeft geen schemaversie")
      if (locationRW) : 
         return True
      else :
         return False

#parse args
parser = argparse.ArgumentParser(description='Geef het volle folder pad aan, bv /home/wim/folder')
parser.add_argument("folder", help="De folder waarin de bestanden zitten")
args = parser.parse_args()
Globals.path = args.folder


#corrigeer files
#versie wordt Globals.nwVersie
#set nwe SHA512 hash van gml's
#path = r"/home/wim/Geonovum/scripts/versieConversie/pvUtrechtDemoversie1 versie 1.0.1/"

for file in os.listdir(Globals.path):
    m = re.search(r'(.*)\.(.*)', file)
    filename = Globals.path + file
    if m : 
      #versie
      if ( (m.group(2) == "gml") or (m.group(2) == "xml") ) :
         Globals.xmlDoc = xml.dom.minidom.parse(filename)
         topEl = Globals.xmlDoc.documentElement
         #hash
         correctSchemaVersion(filename)
         if (topEl.localName == "AanleveringInformatieObject" and Globals.xmlDoc.getElementsByTagName("heeftBestanden") and Globals.xmlDoc.getElementsByTagName("Bestand") ) :  
            heeftBestanden = Globals.xmlDoc.getElementsByTagName("heeftBestanden")[0] #just one
            for bestand in heeftBestanden.getElementsByTagName("Bestand") :
               bestandsnaam = bestand.getElementsByTagName("bestandsnaam")[0]
               #print(bestandsnaam.firstChild.data)
               hash = sha512(Globals.path + bestandsnaam.firstChild.data)
               #print(hash)
               hashEl = bestand.getElementsByTagName("hash")[0]
               newHash = Globals.xmlDoc.createElement("hash")
               newHashText = Globals.xmlDoc.createTextNode(hash)
               newHash.appendChild(newHashText)
               bestand.replaceChild(newHash, hashEl)
         with open(filename, 'w', encoding = 'utf-8') as f:
            f.write(Globals.xmlDoc.toxml())#toxml
      
    else :
      print("skipped: ", file)


