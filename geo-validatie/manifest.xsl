<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0" xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:gvmb="http://www.kadaster.nl/schemas/geovalidaties/manifestbestand/v20181101" xmlns:gvt="http://www.kadaster.nl/schemas/geovalidaties/typen/v20181101" xmlns:gve="http://www.kadaster.nl/schemas/geovalidaties/validatieelement" version="2.0">
   <xsl:output method="text" version="1.0"/>
   <xsl:strip-space elements="*"/>

   <xsl:param name="srsName" select="('onbekend','http://www.opengis.net/def/crs/EPSG/0/28992','urn:ogc:def:crs:EPSG::28992','EPSG:28992','http://www.opengis.net/def/crs/EPSG/0/4258','urn:ogc:def:crs:EPSG::4258','EPSG:4258')"/>
   <xsl:param name="srsName.code" select="(0,1,1,1,2,2,2)"/>
   <xsl:param name="srsName.waarde" select="('onbekend','RD','RD','RD','ETRS89','ETRS89','ETRS89')"/>

   <xsl:param name="gmlType" select="('onbekend','Polygon','Surface','MultiPolygon','MultiSurface','Point','Curve','LinearRing','MultiPoint','MultiCurve','Ring','LineString')"/>
   <xsl:param name="gmlType.code" select="(0,1,2,3,4,5,6,7,8,9,10,11)"/>
   <xsl:param name="gmlType.waarde" select="('onbekend','Polygon','Surface','MultiPolygon','MultiSurface','Point','Curve','LinearRing','MultiPoint','MultiCurve','Ring','LineString')"/>

   <!-- root -->

   <xsl:template match="/">
      <xsl:variable name="FRBRWork" select="tokenize(//geo:GeoInformatieObjectVersie/geo:FRBRWork,'/')"/>
      <xsl:variable name="dir" select="fn:string-join(($FRBRWork[5],$FRBRWork[7]),'_')"/>
      <!-- genereer de afzonderlijke gml-bestanden -->
      <xsl:for-each select="//geo:Locatie">
         <xsl:variable name="id" select="(descendant::gml:*[1]/@gml:id,fn:string-join(('onbekend',position()),'_'))[1]"/>
         <xsl:result-document href="{fn:string-join(($dir,concat($id,'.xml')),'/')}" method="xml" indent="yes">
            <xsl:element name="gve:GeoValidatieElement">
               <xsl:namespace name="gve" select="string('http://www.kadaster.nl/schemas/geovalidaties/validatieelement')"/>
               <xsl:namespace name="gml" select="string('http://www.opengis.net/gml/3.2')"/>
               <xsl:copy-of select="descendant::gml:*[1]" copy-namespaces="no"/>
            </xsl:element>
         </xsl:result-document>
      </xsl:for-each>
      <!-- genereer het manifest-bestand -->
      <xsl:result-document href="{fn:string-join(($dir,'manifest.xml'),'/')}" method="xml">
         <xsl:element name="gvmb:manifest">
            <xsl:namespace name="gvmb" select="string('http://www.kadaster.nl/schemas/geovalidaties/manifestbestand/v20181101')"/>
            <xsl:namespace name="gvt" select="string('http://www.kadaster.nl/schemas/geovalidaties/typen/v20181101')"/>
            <xsl:for-each select="//geo:Locatie">
               <xsl:variable name="id" select="(descendant::gml:*[1]/@gml:id,fn:string-join(('onbekend',position()),'_'))[1]"/>
               <xsl:variable name="srsName.index" select="fn:index-of($srsName,(descendant::gml:*[1]/@srsName,'onbekend')[1])"/>
               <xsl:variable name="gmlType.index" select="fn:index-of($gmlType,(descendant::gml:*[1]/local-name(),'onbekend')[1])"/>
               <xsl:element name="gvmb:bestand">
                  <xsl:element name="bestandsnaam">
                     <xsl:value-of select="concat($id,'.xml')"/>
                  </xsl:element>
                  <xsl:element name="geovalidatieconfiguratie">
                     <xsl:element name="crs">
                        <xsl:element name="gvt:code">
                           <xsl:value-of select="$srsName.code[$srsName.index]"/>
                        </xsl:element>
                        <xsl:element name="gvt:waarde">
                           <xsl:value-of select="$srsName.waarde[$srsName.index]"/>
                        </xsl:element>
                     </xsl:element>
                     <xsl:element name="geostandaard">
                        <xsl:element name="gvt:code">
                           <xsl:value-of select="1"/>
                        </xsl:element>
                        <xsl:element name="gvt:waarde">
                           <xsl:value-of select="string('GML321SF2')"/>
                        </xsl:element>
                     </xsl:element>
                     <xsl:element name="gmlType">
                        <xsl:element name="gvt:code">
                           <xsl:value-of select="$gmlType.code[$gmlType.index]"/>
                        </xsl:element>
                        <xsl:element name="gvt:waarde">
                           <xsl:value-of select="$gmlType.waarde[$gmlType.index]"/>
                        </xsl:element>
                     </xsl:element>
                  </xsl:element>
               </xsl:element>
            </xsl:for-each>
         </xsl:element>
      </xsl:result-document>
      <!-- genereer het log-bestand -->
      <xsl:value-of select="concat('GML-bestand: ',document-uri(),'&#10;')"/>
      <xsl:value-of select="concat('FRBRWork: ',//geo:GeoInformatieObjectVersie/geo:FRBRWork)"/>
      <xsl:for-each select="//geo:Locatie">
         <xsl:variable name="id" select="(descendant::gml:*[1]/@gml:id,fn:string-join(('onbekend',position()),'_'))[1]"/>
         <xsl:variable name="srsName" select="(descendant::gml:*[1]/@srsName,'onbekend')[1]"/>
         <xsl:variable name="gmlType" select="(descendant::gml:*[1]/local-name(),'onbekend')[1]"/>
         <xsl:value-of select="concat('&#10;&#10;','Locatie: ',$id)"/>
         <xsl:value-of select="concat('&#10;','srsName: ',$srsName)"/>
         <xsl:value-of select="concat('&#10;','GML-type: ',$gmlType)"/>
      </xsl:for-each>
   </xsl:template>

</xsl:stylesheet>