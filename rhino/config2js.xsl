<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:my="http://www.eigen.nl" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <xsl:output indent="no" omit-xml-declaration="yes" method="text" encoding="utf-8"/>
  <xsl:strip-space elements="*"/>

  <!-- parameter tab bepaalt de inspringing in json, parameter level bepaalt de diepte -->
  <xsl:param name="tab"><xsl:text>  </xsl:text></xsl:param>

  <!-- respec -->

  <xsl:param name="respec">
    <xsl:copy-of select="config/item[1]"/>
  </xsl:param>

  <xsl:template match="root()">
    <xsl:value-of select="string('var respecConfig =&#10;')"/>
    <xsl:apply-templates select="$respec/node()">
      <xsl:with-param name="level" select="0"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="element()">
    <xsl:param name="level" as="xs:integer"/>
    <xsl:variable name="indent" select="for $index in 1 to $level return $tab"/>
    <xsl:choose>
      <xsl:when test="item">
        <!-- element bevat een array -->
        <xsl:value-of select="fn:string-join(($indent,if (self::root|self::item) then '' else concat(name(),': '),'[&#10;'),'')"/>
        <xsl:apply-templates>
          <xsl:with-param name="level" select="$level+1"/>
        </xsl:apply-templates>
        <xsl:value-of select="fn:string-join(($indent,']',if (following-sibling::element()) then ',' else '','&#10;'),'')"/>
      </xsl:when>
      <xsl:when test="element()">
        <xsl:apply-templates select="@name">
          <xsl:with-param name="level" select="$level"/>
        </xsl:apply-templates>
        <xsl:value-of select="fn:string-join(($indent,if (self::root|self::item) then '' else concat(name(),': '),'{&#10;'),'')"/>
        <xsl:apply-templates select="node()">
          <xsl:with-param name="level" select="$level+1"/>
        </xsl:apply-templates>
        <xsl:value-of select="fn:string-join(($indent,'}',if (following-sibling::element()) then ',' else '','&#10;'),'')"/>
      </xsl:when>
      <xsl:when test="text()">
        <xsl:value-of select="fn:string-join(($indent,if (self::root|self::item) then '' else concat(name(),': '),'&quot;'),'')"/>
        <xsl:copy-of select="text()"/>
        <xsl:value-of select="fn:string-join(('&quot;',if (following-sibling::element()) then ',' else '','&#10;'),'')"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="attribute()">
    <xsl:param name="level" as="xs:integer"/>
    <xsl:variable name="indent" select="for $index in 1 to $level return $tab"/>
    <xsl:value-of select="fn:string-join(($indent,'&quot;'),'')"/>
    <xsl:value-of select="."/>
    <xsl:value-of select="fn:string-join(('&quot;:&#10;'),'')"/>
  </xsl:template>

</xsl:stylesheet>