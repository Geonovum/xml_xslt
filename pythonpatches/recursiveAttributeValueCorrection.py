#corrigeert attribute value van parent en descendants

""" De AKN-naamgeving div_o_1 is niet correct voor element Divisietekst cmp_Bijlage_inst9__div_o_1. Pas de naamgeving voor dit element en alle onderliggende elementen aan. Controleer ook de naamgeving van de bijbehorende wId.
eId="cmp_Bijlage_inst9__div_o_1" wId="pv26_1-0__cmp_Bijlage_inst9__div_o_1" wordt 
eId="cmp_Bijlage_inst9__content_o_1" wId="pv26_1-0__cmp_Bijlage_inst9__content_o_1" """


import xml.dom.minidom
from sys import exit
import re
import os
import sys

sys.setrecursionlimit(1000)
print("stack:", sys.getrecursionlimit())

#set global vars
class Globals : #do not use for inheritance or instances
   recursionCounter = 0
   idCounter = 1000
   xmlDoc = None
   divInline = None
   divDisplay = None
   htmlBody = None
   xmlInfile = None
   outputFile = None
   span = None

Globals.xmlInfile = "/home/wim/KOOP/STOP/utrecht/xml_omgevingsverordening_provincie_utrecht_1.0-master/pvUtrechtDemoversie_2/OpdrachtZonderdeGML/OVPU002.xml"
Globals.outputFile = "/home/wim/KOOP/STOP/utrecht/xml_omgevingsverordening_provincie_utrecht_1.0-master/pvUtrechtDemoversie_2/OpdrachtZonderdeGML/OVPU002-out.xml"

#xml doc
Globals.xmlDoc = xml.dom.minidom.parse(Globals.xmlInfile) 
#xml:base does not work; xmlBaseAttr = Globals.xmlDoc.createAttribute("xml:base")
#zoek Bijlage|Divisie/Kop-Inhoud
#Bijlage|Divisie/Kop,Inhoud






def nextElement(nodeIn) : #returns the next elementNode in the list, else None
   nodeIn = nodeIn.nextSibling
   print(">", nodeIn)
   while nodeIn :
      if (nodeIn.nodeType == xml.dom.Node.ELEMENT_NODE) :
         #print("bingo", nodeIn.nodeName)
         return nodeIn
      nodeIn = nodeIn.nextSibling
   return None

# <Lijst eId="cmp_Bijlage_inst9__div_o_1__content_o_1__list_o_1" wId="pv26_1-0__cmp_Bijlage_inst9__div_o_1__content_o_1__list_o_1" type="expliciet">
def vindEnSetKindAtr(ouder, wId, eId) : #vind en corrigeer de eId en wId van childs
   Globals.recursionCounter =  Globals.recursionCounter + 1
   #print("recursion:", Globals.recursionCounter, ouder)
   if (ouder.nodeType != xml.dom.Node.ELEMENT_NODE) :
      return False
   childList = ouder.childNodes
   for child in childList :
      neweId = eId
      newwId = wId
      if (child.nodeType == xml.dom.Node.ELEMENT_NODE and child.hasAttribute("wId")) :
         #neweId = .... eId + "__laag_o_" + str(x + 1)
         localString_eId = re.search(r'.*(__.*)', child.getAttribute("eId"))
         localString_wId = re.search(r'.*(__.*)', child.getAttribute("wId"))
         print(localString_wId.group(1))
         newwId = wId + localString_wId.group(1)
         child.setAttribute("wId", newwId)
         neweId = eId + localString_eId.group(1)
         child.setAttribute("eId", neweId)
      vindEnSetKindAtr(child, newwId, neweId)
   return True


#In Divisietekst
divisietekstList = Globals.xmlDoc.getElementsByTagNameNS("https://standaarden.overheid.nl/stop/imop/tekst/", "Divisietekst")
print(">>>", len(divisietekstList))
for divisietekst in divisietekstList :
    #corrigeer eigen eId en wId
    neweIdvalue = re.sub("div", "content", divisietekst.getAttribute("eId"))
    divisietekst.setAttribute("eId", neweIdvalue)
    newwIdvalue = re.sub("div", "content", divisietekst.getAttribute("wId"))
    divisietekst.setAttribute("wId", newwIdvalue)
    #en nu de (klein)kinderen
    vindEnSetKindAtr(divisietekst, divisietekst.getAttribute("wId"), divisietekst.getAttribute("eId"))

""" 
#bijlage
for bijlage in bijlageList :
   x = 0
   volgendElement = nextElement(bijlage.firstChild) # Kop and volgendElement.nodeName == "Inhoud" 
   if (volgendElement.nodeName == "Kop") :
      print(volgendElement.namespaceURI, ":", volgendElement.nodeName) #Kop
      nextEl = nextElement(volgendElement)
      if (nextEl.nodeName == "Inhoud") : 
         print(nextEl.namespaceURI, ":", nextEl.nodeName) #Inhoud
#create <Divisietekst eId="cmp_1" wId="pv26_1-0__cmp_1">
         tempDivisieTekst = Globals.xmlDoc.createElement("Divisietekst")
         #eId="cmp_2" wId="pv26_1-0__cmp_2"
         eId = Globals.xmlDoc.createAttribute("eId")
         wId = Globals.xmlDoc.createAttribute("wId")
         tempDivisieTekst.setAttributeNode(eId)
         tempDivisieTekst.setAttributeNode(wId)
         tempDivisieTekst.setAttribute("eId", bijlage.getAttribute("eId") + "__dvtkst_o_1")
         tempDivisieTekst.setAttribute("wId", bijlage.getAttribute("wId") + "__dvtkst_o_1")

         inhoudCopy = nextEl.cloneNode(deep=True)
         divisieTekst = bijlage.insertBefore(tempDivisieTekst, nextEl)
         divisieTekst.appendChild(inhoudCopy)
         bijlage.removeChild(nextEl)
      else :
         print("geen Inhoud gevonden bij Kop")
   vindEnSetKindAtr(bijlage, bijlage.getAttribute("wId"), bijlage.getAttribute("eId"))


#divisie
for divisie in divisieList :
   x = 0
   volgendElement = nextElement(divisie.firstChild) # Kop and volgendElement.nodeName == "Inhoud" 
   if (volgendElement.nodeName == "Kop") :
      print(volgendElement.namespaceURI, ":", volgendElement.nodeName) #Kop
      nextEl = nextElement(volgendElement)
      if (nextEl.nodeName == "Inhoud") : 
         print(nextEl.namespaceURI, ":", nextEl.nodeName) #Inhoud
#create <Divisietekst eId="cmp_1" wId="pv26_1-0__cmp_1">
         tempDivisieTekst = Globals.xmlDoc.createElement("Divisietekst")
         #eId="cmp_2" wId="pv26_1-0__cmp_2"
         eId = Globals.xmlDoc.createAttribute("eId")
         wId = Globals.xmlDoc.createAttribute("wId")
         tempDivisieTekst.setAttributeNode(eId)
         tempDivisieTekst.setAttributeNode(wId)
         tempDivisieTekst.setAttribute("eId", divisie.getAttribute("eId") + "__dvtkst_o_1")
         tempDivisieTekst.setAttribute("wId", divisie.getAttribute("wId") + "__dvtkst_o_1")

         inhoudCopy = nextEl.cloneNode(deep=True)
         divisieTekst = divisie.insertBefore(tempDivisieTekst, nextEl)
         divisieTekst.appendChild(inhoudCopy)
         divisie.removeChild(nextEl)
      else :
         print("geen Inhoud gevonden bij Kop")
   vindEnSetKindAtr(divisie, divisie.getAttribute("wId"), divisie.getAttribute("eId"))

 """


print("writing to ", Globals.outputFile)
with open(Globals.outputFile, 'w', encoding = 'utf-8') as f:
   f.write(Globals.xmlDoc.toxml())
