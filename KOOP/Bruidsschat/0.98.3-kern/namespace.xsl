<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xlink="http://www.w3.org/1999/xlink" version="2.0" xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901" xmlns:ow="http://www.geostandaarden.nl/imow/owobject/v20190709" xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek/v20190301" xmlns:g-ref="http://www.geostandaarden.nl/imow/geometrie-ref/v20190901" xmlns:l="http://www.geostandaarden.nl/imow/locatie/v20190901" xmlns:l-ref="http://www.geostandaarden.nl/imow/locatie-ref/v20190901" xmlns:r="http://www.geostandaarden.nl/imow/regels/v20190901" xmlns:r-ref="http://www.geostandaarden.nl/imow/regels-ref/v20190901" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie/v20190901" xmlns:rol-ref="http://www.geostandaarden.nl/imow/regelsoplocatie-ref/v20190709">
   <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

   <xsl:variable name="template" select="fn:document('template.xml')"/>

   <xsl:template match="ow-dc:owBestand" xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901">
      <xsl:element name="{name()}" namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901">
         <xsl:copy-of select="$template//namespace::*"/>
         <xsl:apply-templates select="node()"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="ow-dc:owBestand" xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190801">
      <xsl:element name="{name()}" namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901">
         <xsl:copy-of select="$template//namespace::*"/>
         <xsl:apply-templates select="node()"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="ow-dc:*" xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190801">
      <xsl:element name="{name()}" namespace="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901">
         <xsl:apply-templates select="@*|node()"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="sl:*" xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek/v20190301">
      <xsl:element name="{name()}" namespace="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek/v20190301">
         <xsl:apply-templates select="@*|node()"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="rol:*" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie/v20190801">
      <xsl:element name="{name()}" namespace="http://www.geostandaarden.nl/imow/regelsoplocatie/v20190901">
         <xsl:apply-templates select="@*|node()"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="rol-ref:*" xmlns:rol-ref="http://www.geostandaarden.nl/imow/regelsoplocatie-ref/v20190709">
      <xsl:element name="{name()}" namespace="http://www.geostandaarden.nl/imow/regelsoplocatie-ref/v20190709">
         <xsl:apply-templates select="@*|node()"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="l-ref:*" xmlns:l-ref="http://www.geostandaarden.nl/imow/locatie-ref/v20190709">
      <xsl:element name="{name()}" namespace="http://www.geostandaarden.nl/imow/locatie-ref/v20190901">
         <xsl:apply-templates select="@*|node()"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="@*[local-name()='regeltekstId']">
      <!-- Doe niets -->
   </xsl:template>

   <!-- Algemene templates -->

   <xsl:template match="element()">
      <xsl:element name="{name()}">
         <xsl:apply-templates select="namespace::*|@*|node()"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="@*">
      <xsl:copy-of select="."/>
   </xsl:template>

   <xsl:template match="text()">
      <xsl:copy-of select="."/>
   </xsl:template>

   <xsl:template match="comment()|processing-instruction()">
      <xsl:copy-of select="."/>
   </xsl:template>

</xsl:stylesheet>