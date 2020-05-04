<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
  <xsl:output method="text" encoding="windows-1252"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="/">
    <xsl:value-of select="concat('&quot;','Waardelijst','&quot;',';')"/>
    <xsl:value-of select="concat('&quot;','Waarde','&quot;',';')"/>
    <xsl:value-of select="concat('&quot;','Toelichting','&quot;',';')"/>
    <xsl:value-of select="concat('&quot;','Definitie','&quot;',';')"/>
    <xsl:value-of select="concat('&quot;','Bron','&quot;',';')"/>
    <xsl:value-of select="concat('&quot;','URI','&quot;',';')"/>
    <xsl:value-of select="concat('&quot;','Symboolcode exact','&quot;',';')"/>
    <xsl:value-of select="concat('&quot;','Symboolcode indicatief','&quot;')"/>
    <xsl:apply-templates select="waardelijsten/waardelijst"/>
  </xsl:template>

  <xsl:template match="waardelijst">
    <xsl:value-of select="string('&#10;')"/>
    <xsl:value-of select="string('&#10;')"/>
    <xsl:value-of select="concat('&quot;',concat(titel,' [',type,']'),'&quot;',';')"/>
    <xsl:value-of select="string(';')"/>
    <xsl:value-of select="concat('&quot;',toelichting,'&quot;',';')"/>
    <xsl:value-of select="concat('&quot;',omschrijving,'&quot;',';')"/>
    <xsl:value-of select="string(';')"/>
    <xsl:value-of select="concat('&quot;',uri,'&quot;',';')"/>
    <xsl:value-of select="string(';')"/>
    <xsl:apply-templates select="waarden/waarde"/>
  </xsl:template>

  <xsl:template match="waarde">
    <xsl:value-of select="string('&#10;')"/>
    <xsl:value-of select="string(';')"/>
    <xsl:choose>
      <xsl:when test="(ancestor::waardelijst[1]/titel eq 'Thema') and (label ne lower-case(term))">
        <xsl:variable name="hoofdthema" select="preceding-sibling::waarde[label eq lower-case(term)][1]/label"/>
        <xsl:value-of select="concat('&quot;',concat($hoofdthema,' - ',label),'&quot;',';')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('&quot;',label,'&quot;',';')"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="concat('&quot;',toelichting,'&quot;',';')"/>
    <xsl:value-of select="concat('&quot;',definitie,'&quot;',';')"/>
    <xsl:value-of select="concat('&quot;',bron,'&quot;',';')"/>
    <xsl:value-of select="concat('&quot;',uri,'&quot;',';')"/>
    <xsl:value-of select="concat('&quot;',symboolcode/exact,'&quot;',';')"/>
    <xsl:value-of select="concat('&quot;',symboolcode/indicatief,'&quot;')"/>
  </xsl:template>

</xsl:stylesheet>
