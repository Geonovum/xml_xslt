<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0" xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" xmlns:l="http://www.geostandaarden.nl/imow/locatie" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/" xmlns:lvbba="https://standaarden.overheid.nl/lvbb/stop/aanlevering/" version="2.0">
   <xsl:output method="text" version="1.0"/>
   <xsl:strip-space elements="*"/>

   <xsl:param name="input.dir" select="string('file:/C:/Werkbestanden/Geonovum/KOOP/owLocatie/input')"/>

   <xsl:param name="gio" select="collection(concat($input.dir,'?select=*.xml;recurse=yes'))//lvbba:InformatieObjectVersie"/>
   <xsl:param name="bg-unique" select="fn:distinct-values($gio//data:eindverantwoordelijke)"/>

   <!-- root -->

   <xsl:template match="/">
      <xsl:for-each select="$bg-unique">
         <xsl:variable name="gio-eindverantwoordelijke" select="fn:tokenize(.,'/')[last()]"/>
         <xsl:variable name="gio-leveringsid" select="fn:string-join(($gio-eindverantwoordelijke,fn:format-date(fn:current-date(),'[Y0001]-[M01]-[D01]')),'_')"/>
         <xsl:variable name="gml" select="collection(concat($input.dir,'?select=*.gml;recurse=yes'))//geo:GeoInformatieObjectVersie[fn:tokenize(geo:FRBRWork,'/')[5]=$gio-eindverantwoordelijke]"/>
         <!-- er is een tijdelijke index van locaties nodig -->
         <xsl:variable name="lijst">
            <xsl:sequence select="$gml//(geo:FRBRWork,geo:Locatie)"/>
         </xsl:variable>
         <xsl:variable name="locaties">
            <xsl:for-each select="$lijst/*">
               <xsl:choose>
                  <xsl:when test="self::geo:FRBRWork">
                     <xsl:element name="gio">
                        <xsl:attribute name="index" select="count(current()|preceding-sibling::geo:FRBRWork)"/>
                        <xsl:attribute name="id" select="current()"/>
                        <xsl:attribute name="gio-id">
                           <xsl:choose>
                              <xsl:when test="contains(fn:tokenize(current(),'/')[7],'ib_aangewezen')">
                                 <xsl:value-of select="concat('nl.imow-',$gio-eindverantwoordelijke,'.gebiedengroep.aangewOppervlaktewaterlichamen')"/>
                              </xsl:when>
                              <xsl:when test="contains(fn:tokenize(current(),'/')[7],'ib_niet_aangewezen')">
                                 <xsl:value-of select="concat('nl.imow-',$gio-eindverantwoordelijke,'.gebiedengroep.nietAangewOppervlaktewaterlichamen')"/>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:value-of select="concat('nl.imow-',$gio-eindverantwoordelijke,'.gebiedengroep.onbekend')"/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="gio-noemer" select="$gio[data:ExpressionIdentificatie/data:FRBRWork=current()]//data:InformatieObjectMetadata/data:naamInformatieObject"/>
                     </xsl:element>
                  </xsl:when>
                  <xsl:when test="self::geo:Locatie">
                     <xsl:element name="locatie">
                        <xsl:attribute name="index" select="count(current()|preceding-sibling::geo:Locatie)"/>
                        <xsl:attribute name="id" select="current()//basisgeo:id"/>
                        <xsl:attribute name="geo-naam" select="current()//geo:naam"/>
                     </xsl:element>
                  </xsl:when>
               </xsl:choose>
            </xsl:for-each>
         </xsl:variable>
         <!-- genereer één owLocatie.xml per bg -->
         <xsl:result-document href="{fn:string-join(($gio-eindverantwoordelijke,concat($gio-eindverantwoordelijke,'Locaties.xml')),'/')}" method="xml" indent="yes">
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
                  <!-- maak een gebiedengroep per gio -->
                  <xsl:for-each-group select="$locaties/*" group-starting-with="gio">
                     <xsl:variable name="test" select="current-group()"/>
                     <xsl:element name="sl:stand">
                        <xsl:element name="ow-dc:owObject">
                           <xsl:element name="l:Gebiedengroep">
                              <xsl:element name="l:identificatie">
                                 <xsl:value-of select="current-group()[1]/@gio-id"/>
                              </xsl:element>
                              <xsl:if test="current-group()[1]/@gio-noemer ne ''">
                                 <xsl:element name="l:noemer">
                                    <xsl:value-of select="current-group()[1]/@gio-noemer"/>
                                 </xsl:element>
                              </xsl:if>
                              <xsl:element name="l:groepselement">
                                 <xsl:for-each select="fn:subsequence(current-group(),2)">
                                    <xsl:element name="l:GebiedRef">
                                       <xsl:attribute name="xlink:href" select="concat('nl.imow-',$gio-eindverantwoordelijke,'.gebied.2020',fn:format-number(@index,'000000'))"/>
                                    </xsl:element>
                                 </xsl:for-each>
                              </xsl:element>
                           </xsl:element>
                        </xsl:element>
                     </xsl:element>
                  </xsl:for-each-group>
                  <!-- maak alle gebieden -->
                  <xsl:for-each select="$locaties/locatie">
                     <xsl:element name="sl:stand">
                        <xsl:element name="ow-dc:owObject">
                           <xsl:element name="l:Gebied">
                              <xsl:element name="l:identificatie">
                                 <xsl:value-of select="concat('nl.imow-',$gio-eindverantwoordelijke,'.gebied.2020',fn:format-number(current()/@index,'000000'))"/>
                              </xsl:element>
                              <xsl:if test="current()/@geo-naam ne ''">
                                 <xsl:element name="l:noemer">
                                    <xsl:value-of select="current()/@geo-naam"/>
                                 </xsl:element>
                              </xsl:if>
                              <xsl:element name="l:geometrie">
                                 <xsl:element name="l:GeometrieRef">
                                    <xsl:attribute name="xlink:href" select="current()/@id"/>
                                 </xsl:element>
                              </xsl:element>
                           </xsl:element>
                        </xsl:element>
                     </xsl:element>
                  </xsl:for-each>
               </xsl:element>
            </xsl:element>
         </xsl:result-document>
         <!-- genereer de afzonderlijke gml-bestanden -->
         <xsl:for-each select="$locaties/locatie">
            <xsl:result-document href="{fn:string-join(($gio-eindverantwoordelijke,concat(current()/@id,'.xml')),'/')}" method="xml" indent="yes">
               <xsl:element name="basisgeo:FeatureCollectionGeometrie">
                  <xsl:namespace name="basisgeo" select="string('http://www.geostandaarden.nl/basisgeometrie/1.0')"/>
                  <xsl:namespace name="gml" select="string('http://www.opengis.net/gml/3.2')"/>
                  <xsl:element name="basisgeo:featureMember">
                     <xsl:copy-of select="$lijst//basisgeo:Geometrie[basisgeo:id=current()/@id]"/>
                  </xsl:element>
               </xsl:element>
            </xsl:result-document>
         </xsl:for-each>
         <!-- genereer het log-bestand -->
         <xsl:value-of select="concat('[BG ',$gio-eindverantwoordelijke,']','&#10;')"/>
         <xsl:for-each select="$locaties/*">
            <xsl:choose>
               <xsl:when test="self::gio">
                  <xsl:value-of select="string('&#10;')"/>
                  <xsl:value-of select="concat('[GIO ',current()/@index,']','&#10;')"/>
                  <xsl:value-of select="concat('FRBRWork: ',current()/@id,'&#10;')"/>
                  <xsl:value-of select="concat('id: ',current()/@gio-id,'&#10;')"/>
                  <xsl:value-of select="concat('noemer: ',current()/@gio-noemer,'&#10;')"/>
               </xsl:when>
               <xsl:when test="self::locatie">
                  <xsl:value-of select="concat('[GML ',current()/@index,']','&#10;')"/>
                  <xsl:value-of select="concat('id: ',current()/@id,'&#10;')"/>
                  <xsl:value-of select="concat('naam: ',(current()/@geo-naam[. ne ''],'[geen]')[1],'&#10;')"/>
                  <xsl:value-of select="concat('srsName: ',($lijst//basisgeo:Geometrie[basisgeo:id=current()/@id]//gml:*[1]/@srsName,'[geen]')[1],'&#10;')"/>
                  <xsl:value-of select="concat('type: ',($lijst//basisgeo:Geometrie[basisgeo:id=current()/@id]//gml:*[1]/local-name(),'[geen]')[1],'&#10;')"/>
               </xsl:when>
            </xsl:choose>
         </xsl:for-each>
         <xsl:value-of select="string('&#10;')"/>
      </xsl:for-each>
   </xsl:template>

</xsl:stylesheet>