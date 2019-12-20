<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:geo="http://www.geostandaarden.nl/basisgeometrie/v20190901" xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
   <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

   <xsl:param name="element" select="('gml:CompositeCurve','gml:CompositeSurface','gml:Curve','gml:LinearRing','gml:LineString','gml:MultiSurface','gml:OrientableCurve','gml:OrientableSurface','gml:Point','gml:Polygon','gml:PolyhedralSurface','gml:Ring','gml:Shell','gml:Surface','gml:Tin','gml:Triangle','gml:TriangulatedSurface')"/>

   <!-- Vul hieronder de GUID in. -->

   <xsl:param name="GUID" select="string('13B34F36-1C71-4993-BF08-D33122DB2A06')"/>

   <!-- elementen verwerken -->

   <xsl:template match="geo:id">
      <xsl:variable name="index" select="if (count(ancestor::geo:FeatureCollectionGeometrie/geo:featureMember) gt 1) then count(ancestor::geo:featureMember/(.|preceding-sibling::geo:featureMember)) else null"/>
      <xsl:element name="{name()}" namespace="{namespace-uri()}">
         <xsl:apply-templates select="@*"/>
         <xsl:value-of select="fn:string-join(($GUID,$index),'-')"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="geo:FeatureCollectionGeometrie">
      <xsl:element name="{name()}" namespace="{namespace-uri()}">
         <xsl:apply-templates select="@*"/>
         <xsl:apply-templates select="node()"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="geo:featureMember">
      <xsl:element name="{name()}" namespace="{namespace-uri()}">
         <xsl:apply-templates select="@*"/>
         <xsl:apply-templates select="node()"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="element()[fn:index-of($element,name()) gt 0]" priority="1">
      <xsl:variable name="index" select="if (count(ancestor::geo:FeatureCollectionGeometrie/geo:featureMember) gt 1) then count(ancestor::geo:featureMember/(.|preceding-sibling::geo:featureMember)) else null"/>
      <xsl:variable name="count" select="count(ancestor::element()[fn:index-of($element,name()) gt 0]|preceding::element()[fn:index-of($element,name()) gt 0])-count(ancestor::geo:featureMember/preceding-sibling::geo:featureMember/descendant::element()[fn:index-of($element,name()) gt 0])"/>
      <xsl:element name="{name()}" namespace="{namespace-uri()}">
         <xsl:apply-templates select="@*"/>
         <xsl:attribute name="gml:id" select="fn:string-join(('id',$GUID,$index,$count),'-')"/>
         <xsl:attribute name="srsName" select="string('urn:ogc:def:crs:EPSG::28992')"/>
         <xsl:apply-templates select="node()"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="element()">
      <xsl:element name="{name()}" namespace="{namespace-uri()}">
         <xsl:apply-templates select="@* except @gml:id"/>
         <xsl:apply-templates select="node()"/>
      </xsl:element>
   </xsl:template>

   <!-- attributen verwerken -->

   <xsl:template match="@*">
      <xsl:copy-of select="."/>
   </xsl:template>

   <xsl:template match="namespace::*">
      <xsl:copy-of select="."/>
   </xsl:template>

   <!-- tekst opschonen -->

   <xsl:template match="text()">
      <xsl:choose>
         <xsl:when test="(normalize-space(.)='') and contains(.,'&#10;')">
            <!-- lege tekst met een zachte return is indentation -->
            <xsl:value-of select="fn:tokenize(.,'&#10;')[1]"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:variable name="myArray">
               <xsl:value-of select="fn:tokenize(.,'\s+')"/>
            </xsl:variable>
            <xsl:value-of select="fn:concat($myArray,'')"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="comment()">
      <xsl:copy-of select="."/>
      <xsl:text>&#xA;</xsl:text>
   </xsl:template>

   <xsl:template match="processing-instruction()">
      <!-- doe niets -->
   </xsl:template>

</xsl:stylesheet>