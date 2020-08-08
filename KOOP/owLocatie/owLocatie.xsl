<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0" xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" xmlns:l="http://www.geostandaarden.nl/imow/locatie" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/" xmlns:lvbba="https://standaarden.overheid.nl/lvbb/stop/aanlevering/" version="2.0">
   <xsl:output method="text" version="1.0"/>
   <xsl:strip-space elements="*"/>

   <xsl:param name="fullname" select="document-uri()"/>
   <xsl:param name="filename" select="tokenize($fullname,'/')[last()]"/>
   <xsl:param name="dirname" select="replace($fullname,$filename,'')"/>

   <xsl:param name="gio" select="collection(concat($dirname,'?select=*.xml;recurse=yes'))//lvbba:AanleveringInformatieObject[descendant::data:bestandsnaam=$filename]"/>

   <xsl:param name="gio-eindverantwoordelijke" select="tokenize($gio//data:InformatieObjectMetadata/data:eindverantwoordelijke,'/')[last()]"/>
   <xsl:param name="gio-id" select="concat('nl.imow-',$gio-eindverantwoordelijke,'.gebiedengroep.aangewOppervlaktewaterlichamen')"/>
   <xsl:param name="gio-noemer" select="string($gio//data:InformatieObjectMetadata/data:naamInformatieObject)"/>
   <xsl:param name="gio-leveringsid" select="fn:string-join(($gio-eindverantwoordelijke,fn:format-date(fn:current-date(),'[Y0001]-[M01]-[D01]')),'_')"/>

   <!-- root -->

   <xsl:template match="/">
      <xsl:choose>
         <xsl:when test="$gio">
            <xsl:variable name="dir" select="tokenize($filename,'\.')[1]"/>
            <!-- genereer de afzonderlijke gml-bestanden -->
            <xsl:for-each select="//geo:Locatie">
               <xsl:variable name="id" select=".//basisgeo:id"/>
               <xsl:result-document href="{fn:string-join(($dir,concat($id,'.xml')),'/')}" method="xml" indent="yes">
                  <xsl:element name="basisgeo:FeatureCollectionGeometrie">
                     <xsl:namespace name="basisgeo" select="string('http://www.geostandaarden.nl/basisgeometrie/1.0')"/>
                     <xsl:namespace name="gml" select="string('http://www.opengis.net/gml/3.2')"/>
                     <xsl:element name="basisgeo:featureMember">
                        <xsl:copy-of select=".//basisgeo:Geometrie"/>
                     </xsl:element>
                  </xsl:element>
               </xsl:result-document>
            </xsl:for-each>
            <!-- genereer het owLocatie-bestand -->
            <xsl:result-document href="{fn:string-join(($dir,concat($gio-eindverantwoordelijke,'Locaties.xml')),'/')}" method="xml" indent="yes">
               <xsl:element name="ow-dc:owBestand">
                  <xsl:namespace name="ow-dc" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand')"/>
                  <xsl:namespace name="ow" select="string('http://www.geostandaarden.nl/imow/owobject')"/>
                  <xsl:namespace name="da" select="string('http://www.geostandaarden.nl/imow/datatypenalgemeen')"/>
                  <xsl:namespace name="sl" select="string('http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek')"/>
                  <xsl:namespace name="ga" select="string('http://www.geostandaarden.nl/imow/gebiedsaanwijzing')"/>
                  <xsl:namespace name="k" select="string('http://www.geostandaarden.nl/imow/kaart')"/>
                  <xsl:namespace name="l" select="string('http://www.geostandaarden.nl/imow/locatie')"/>
                  <xsl:namespace name="p" select="string('http://www.geostandaarden.nl/imow/pons')"/>
                  <xsl:namespace name="r" select="string('http://www.geostandaarden.nl/imow/regels')"/>
                  <xsl:namespace name="rol" select="string('http://www.geostandaarden.nl/imow/regelsoplocatie')"/>
                  <xsl:namespace name="vt" select="string('http://www.geostandaarden.nl/imow/vrijetekst')"/>
                  <xsl:namespace name="xlink" select="string('http://www.w3.org/1999/xlink')"/>
                  <xsl:attribute name="xsi:schemaLocation" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand https://register.geostandaarden.nl/xmlschema/tpod/v1.0.2/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd')"/>
                  <xsl:element name="sl:standBestand">
                     <xsl:element name="sl:dataset">
                        <xsl:value-of select="$gio-eindverantwoordelijke"/>
                     </xsl:element>
                     <xsl:element name="sl:inhoud">
                        <xsl:element name="sl:gebied">
                           <xsl:value-of select="$gio-eindverantwoordelijke"/>
                        </xsl:element>
                        <xsl:element name="sl:leveringsId">
                           <xsl:value-of select="$gio-leveringsid"/>
                        </xsl:element>
                        <xsl:element name="sl:objectTypen">
                           <xsl:element name="sl:objectType">
                              <xsl:value-of select="string('Gebied')"/>
                           </xsl:element>
                           <xsl:element name="sl:objectType">
                              <xsl:value-of select="string('Gebiedengroep')"/>
                           </xsl:element>
                        </xsl:element>
                     </xsl:element>
                     <xsl:element name="sl:stand">
                        <xsl:element name="ow-dc:owObject">
                           <xsl:element name="l:Gebiedengroep">
                              <xsl:element name="l:identificatie">
                                 <xsl:value-of select="$gio-id"/>
                              </xsl:element>
                              <xsl:element name="l:noemer">
                                 <xsl:value-of select="$gio-noemer"/>
                              </xsl:element>
                              <xsl:element name="l:groepselement">
                                 <xsl:for-each select=".//geo:Locatie">
                                    <xsl:element name="l:GebiedRef">
                                       <xsl:attribute name="xlink:href" select="concat('nl.imow-',$gio-eindverantwoordelijke,'.gebied.2020',fn:format-number(position(),'000000'))"/>
                                    </xsl:element>
                                 </xsl:for-each>
                              </xsl:element>
                           </xsl:element>
                        </xsl:element>
                     </xsl:element>
                     <xsl:for-each select=".//geo:Locatie">
                        <xsl:element name="sl:stand">
                           <xsl:element name="ow-dc:owObject">
                              <xsl:element name="l:Gebied">
                                 <xsl:element name="l:identificatie">
                                    <xsl:value-of select="concat('nl.imow-',$gio-eindverantwoordelijke,'.gebied.2020',fn:format-number(position(),'000000'))"/>
                                 </xsl:element>
                                 <xsl:element name="l:noemer">
                                    <xsl:value-of select="./geo:naam"/>
                                 </xsl:element>
                                 <xsl:element name="l:geometrie">
                                    <xsl:element name="l:GeometrieRef">
                                       <xsl:attribute name="xlink:href" select=".//basisgeo:id"/>
                                    </xsl:element>
                                 </xsl:element>
                              </xsl:element>
                           </xsl:element>
                        </xsl:element>
                     </xsl:for-each>
                  </xsl:element>
               </xsl:element>
            </xsl:result-document>
            <!-- genereer het log-bestand -->
            <xsl:value-of select="concat('GML-bestand: ',$filename,'&#10;')"/>
            <xsl:value-of select="concat('FRBRWork: ',//geo:GeoInformatieObjectVersie/geo:FRBRWork)"/>
            <xsl:for-each select=".//geo:Locatie">
               <xsl:variable name="id" select=".//basisgeo:id"/>
               <xsl:variable name="srsName" select="(.//gml:*[1]/@srsName,'onbekend')[1]"/>
               <xsl:variable name="gmlType" select="(.//gml:*[1]/local-name(),'onbekend')[1]"/>
               <xsl:value-of select="concat('&#10;&#10;','Locatie: ',$id)"/>
               <xsl:value-of select="concat('&#10;','srsName: ',$srsName)"/>
               <xsl:value-of select="concat('&#10;','GML-type: ',$gmlType)"/>
            </xsl:for-each>
         </xsl:when>
         <xsl:otherwise>
            <!-- genereer foutmelding in het log-bestand -->
            <xsl:value-of select="concat('Error: bij GML-bestand ',$filename,' kon geen GIO-bestand gevonden worden.')"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

</xsl:stylesheet>