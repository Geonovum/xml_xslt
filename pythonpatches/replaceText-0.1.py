""" 
python3 replaceText-0.1.py

In de folder path wordt in elke .gml en .xml file de tekst orgString vervangen door newString.
De gepatch-te files gaan naar een nieuw gemaakte subdir new.
Ter controle wordt er een lijst ge-ouput naar de console waarin de context letters van de orgString te zien zien. Zie onder #invullen de benodigde prarameters.
In new wordt alles overschreven
"""

import re
import os, fnmatch

#invullen:
path = '/home/wim/Geonovum/voorbeeldbestanden/werkmap/opdracht_g/gmlgio/' #dir met de files (hieronder komt de new dir)
orgString = "gm0297" #de te vervangen string 
newString = "gm0263" #de vervangende waarde
dirSeparator = "/" #unix: '/' windows: '\'



if not os.path.isdir(path + "/new") :
   os.mkdir(path + "/new")

foundFiles = []
for file in os.listdir(path):
    m = re.search(r'(.*)\.(.*)', file)
    filename = path + file
    print(path, file)
    if m : 
      #versie
      if ( (m.group(2) == "gml") or (m.group(2) == "xml") ) :
            with open(filename, encoding = 'utf-8') as reader:
               text = reader.read()
               all = re.findall('(.{3})('+ orgString + ')(.{3})', text)
               for found in all :
                  print(found)
               newText = re.sub(orgString, newString , text)
            with open(path + 'new' + dirSeparator + file, 'w', encoding = 'utf-8') as f:
               f.write(newText)

