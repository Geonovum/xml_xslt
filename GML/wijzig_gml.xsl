<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
   xmlns:geo="http://www.geostandaarden.nl/basisgeometrie/v20190901"
   xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:uuid="java.util.UUID">
   <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

   <xsl:param name="element"
      select="('gml:CompositeCurve', 'gml:CompositeSurface', 'gml:Curve', 'gml:LinearRing', 'gml:LineString', 'gml:MultiSurface', 'gml:OrientableCurve', 'gml:OrientableSurface', 'gml:Point', 'gml:Polygon', 'gml:PolyhedralSurface', 'gml:Ring', 'gml:Shell', 'gml:Surface', 'gml:Tin', 'gml:Triangle', 'gml:TriangulatedSurface')"/>
   <!--<xsl:param name="GUID" select="uuid:randomUUID()"/>-->
   <xsl:param name="GUID" select="/geo:FeatureCollection/geo:featureMember[1]/geo:INPUT[1]/geo:id[1]"/>

   <xsl:template match="geo:FeatureCollection">
      <xsl:element name="geo:FeatureCollectionGeometrie">
         <xsl:attribute name="xsi:schemaLocation"
            namespace="http://www.w3.org/2001/XMLSchema-instance"
            select="string('https://standaarden.overheid.nl/stop/imop/geo/ ../xsd/basisgeometrie/v20190901/geometrie.xsd')"/>
         <xsl:attribute name="gml:id" select="string('main')"/>
         <xsl:apply-templates select="gml:boundedBy | geo:featureMember"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="geo:featureMember">
      <xsl:element name="geo:featureMember">
         <xsl:apply-templates select="namespace::* | @* | node()"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="geo:id">
      <!-- wis geo:id -->
   </xsl:template>

   <xsl:template match="element()[parent::geo:featureMember]">
      <xsl:variable name="index"
         select="
            if (count(ancestor::geo:FeatureCollectionGeometrie/geo:featureMember) gt 1) then
               count(ancestor::geo:featureMember/(. | preceding-sibling::geo:featureMember))
            else
               null"/>
      <xsl:element name="geo:Geometrie">
         <xsl:element name="geo:id">
            <xsl:value-of select="fn:string-join(($GUID, $index), '-')"/>
         </xsl:element>
         <xsl:apply-templates select="element()"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="element()[fn:index-of($element, name()) gt 0]" priority="1">
      <xsl:variable name="index"
         select="
            if (count(ancestor::geo:FeatureCollectionGeometrie/geo:featureMember) gt 1) then
               count(ancestor::geo:featureMember/(. | preceding-sibling::geo:featureMember))
            else
               null"/>
      <xsl:variable name="count"
         select="count(ancestor::element()[fn:index-of($element, name()) gt 0] | preceding::element()[fn:index-of($element, name()) gt 0]) - count(ancestor::geo:featureMember/preceding-sibling::geo:featureMember/descendant::element()[fn:index-of($element, name()) gt 0])"/>
      <xsl:element name="{name()}">
         <xsl:attribute name="gml:id" select="fn:string-join(('id', $GUID, $index, $count), '-')"/>
         <xsl:attribute name="srsName" select="string('urn:ogc:def:crs:EPSG::28992')"/>
         <xsl:apply-templates select="node()"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="geo:geometryProperty">
      <xsl:element name="geo:geometrie">
         <xsl:apply-templates select="namespace::* | @* | node()"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="@gml:id">
      <!-- wis @gml:id -->
   </xsl:template>

   <xsl:template match="@srsName">
      <!-- wis @srsName -->
   </xsl:template>

   <!-- Algemene templates -->

   <xsl:template match="element()">
      <xsl:element name="{name()}">
         <xsl:apply-templates select="namespace::* | @* | node()"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="namespace::*">
      <xsl:copy-of select="."/>
   </xsl:template>

   <xsl:template match="@*">
      <xsl:copy-of select="."/>
   </xsl:template>

   <xsl:template match="text()">
      <xsl:copy-of select="."/>
   </xsl:template>

   <xsl:template match="comment() | processing-instruction()">
      <xsl:copy-of select="."/>
   </xsl:template>

</xsl:stylesheet>
