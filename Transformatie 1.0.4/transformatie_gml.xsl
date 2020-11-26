<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:xlink="http://www.w3.org/1999/xlink" version="2.0">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="geo:GeoInformatieObjectVaststelling">
    <xsl:element name="{name()}">
      <xsl:copy-of select="@*|namespace::*"/>
      <xsl:attribute name="schemaversie" select="string('1.0.4')"/>
      <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('https://standaarden.overheid.nl/stop/imop/geo/ https://standaarden.overheid.nl/stop/1.0.4/imop-geo.xsd')"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <!-- Algemene templates -->

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="element()">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:copy-of select="."/>
  </xsl:template>

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

  <xsl:template match="comment()|processing-instruction()">
    <xsl:copy-of select="."/>
  </xsl:template>

</xsl:stylesheet>