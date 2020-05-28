<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
  <xsl:output method="text" encoding="windows-1252"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="/">
    <xsl:value-of select="concat('&quot;','Waardelijst','&quot;',';')"/>
    <xsl:value-of select="concat('&quot;','Waarde','&quot;',';')"/>
    <xsl:value-of select="concat('&quot;','Label','&quot;',';')"/>
    <xsl:value-of select="concat('&quot;','URI','&quot;',';')"/>
    <xsl:value-of select="concat('&quot;','Type','&quot;',';')"/>
    <xsl:value-of select="concat('&quot;','Omschrijving','&quot;',';')"/>
    <xsl:value-of select="concat('&quot;','Definitie','&quot;',';')"/>
    <xsl:value-of select="concat('&quot;','Toelichting','&quot;',';')"/>
    <xsl:value-of select="concat('&quot;','Bron','&quot;',';')"/>
    <xsl:value-of select="concat('&quot;','Domein','&quot;',';')"/>
    <xsl:value-of select="concat('&quot;','Specialisatie van','&quot;',';')"/>
    <xsl:value-of select="concat('&quot;','Symboolcode','&quot;',';')"/>
    <xsl:apply-templates select="waardelijsten/waardelijst"/>
  </xsl:template>

  <xsl:template match="waardelijst">
    <xsl:value-of select="string('&#10;')"/>
    <xsl:value-of select="string('&#10;')"/>
    <xsl:value-of select="concat('&quot;',titel,'&quot;',';')"/>
    <xsl:value-of select="string(';')"/>
    <xsl:value-of select="concat('&quot;',label,'&quot;',';')"/>
    <xsl:value-of select="concat('&quot;',uri,'&quot;',';')"/>
    <xsl:value-of select="concat('&quot;',type,'&quot;',';')"/>
    <xsl:value-of select="concat('&quot;',omschrijving,'&quot;',';')"/>
    <xsl:value-of select="string(';')"/>
    <xsl:value-of select="concat('&quot;',toelichting,'&quot;')"/>
    <xsl:apply-templates select="waarden/waarde">
      <xsl:with-param name="waardelijst" select="titel"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="waarde">
    <xsl:param name="waardelijst"/>
    <xsl:variable name="check" select="term" as="xs:string"/>
    <xsl:variable name="hoofdthema" select="if ($waardelijst='Thema') then preceding-sibling::waarde[starts-with($check,term)]/label else null"/>
    <xsl:value-of select="string('&#10;')"/>
    <xsl:value-of select="string(';')"/>
    <xsl:value-of select="concat('&quot;',term,'&quot;',';')"/>
    <xsl:value-of select="concat('&quot;',fn:string-join(($hoofdthema,label),' - '),'&quot;',';')"/>
    <xsl:value-of select="concat('&quot;',uri,'&quot;',';')"/>
    <xsl:value-of select="string(';')"/>
    <xsl:value-of select="string(';')"/>
    <xsl:value-of select="concat('&quot;',definitie,'&quot;',';')"/>
    <xsl:value-of select="concat('&quot;',toelichting,'&quot;',';')"/>
    <xsl:value-of select="concat('&quot;',bron,'&quot;',';')"/>
    <xsl:value-of select="concat('&quot;',domein,'&quot;',';')"/>
    <xsl:value-of select="concat('&quot;',specialisatie,'&quot;',';')"/>
    <xsl:value-of select="concat('&quot;',symboolcode,'&quot;',';')"/>
  </xsl:template>

</xsl:stylesheet>
