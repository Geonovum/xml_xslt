<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

  <xsl:param name="file.list"/>

  <!-- namespaces -->
  <xsl:param name="lvbb" select="string('http://www.overheid.nl/2017/lvbb')"/>

  <!-- mapping -->
  <xsl:param name="extensions" select="('gml','jpeg','jpg','xml','pdf','png')"/>
  <xsl:param name="type" select="('application/gml+xml','image/jpeg','image/jpeg','application/xml','application/pdf','image/png')"/>

  <!-- algemeen -->

  <xsl:template match="/">
    <xsl:element name="manifest" namespace="{$lvbb}">
      <xsl:element name="bestand" namespace="{$lvbb}">
        <xsl:element name="bestandsnaam" namespace="{$lvbb}">
          <xsl:value-of select="string('manifest.xml')"/>
        </xsl:element>
        <xsl:element name="contentType" namespace="{$lvbb}">
          <xsl:value-of select="$type[fn:index-of($extensions,'xml')]"/>
        </xsl:element>
      </xsl:element>
      <xsl:for-each select="fn:tokenize($file.list,';')">
        <xsl:variable name="file" select="fn:tokenize(.,'/')[last()]"/>
        <xsl:variable name="extension" select="fn:tokenize(.,'\.')[last()]"/>
        <xsl:element name="bestand" namespace="{$lvbb}">
          <xsl:element name="bestandsnaam" namespace="{$lvbb}">
            <xsl:value-of select="$file"/>
          </xsl:element>
          <xsl:element name="contentType" namespace="{$lvbb}">
            <xsl:value-of select="$type[fn:index-of($extensions,$extension)]"/>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>