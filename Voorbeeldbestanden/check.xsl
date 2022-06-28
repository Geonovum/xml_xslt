<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:digest="java:org.apache.commons.codec.digest.DigestUtils" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/" version="2.0">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

  <!-- directories -->

  <xsl:param name="base.dir" select="fn:tokenize(fn:base-uri(.),'template.xml')[1]"/>
  <xsl:param name="input.dir" select="concat($base.dir,'input/')"/>
  <xsl:param name="temp.dir" select="concat($base.dir,'temp/')"/>
  <xsl:param name="output.dir" select="concat($base.dir,'output/')"/>

  <!-- maak voor alle elementen met @wId een overzicht met naam, pad, eId, wId, hash, bijbehorend ow-object -->

  <xsl:param name="op_besluit" select="collection(concat($input.dir,'?select=*.xml'))[descendant::AanleveringBesluit]" xpath-default-namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"/>
  <xsl:param name="ow_object" select="collection(concat($input.dir,'?select=*.xml;recurse=yes'))//element()[element()[local-name()='identificatie']]"/>

  <xsl:param name="ow">
    <xsl:apply-templates select="$ow_object[@wId]"/>
  </xsl:param>

  <xsl:param name="op">
    <xsl:apply-templates select="$op_besluit/element()"/>
  </xsl:param>

  <xsl:template match="/">
    <xsl:element name="check">
      <xsl:copy-of select="$op"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="(tekst:Artikel|tekst:Lid|tekst:Divisie|tekst:Divisietekst)[@wId]" priority="10">
    <xsl:variable name="id" select="@wId"/>
    <xsl:element name="{local-name()}">
      <xsl:attribute name="pad" select="fn:string-join(ancestor-or-self::element()/local-name(),'/')"/>
      <xsl:attribute name="hash" select="digest:md5Hex(fn:string-join(descendant-or-self::text()/normalize-space(),' '))"/>
      <xsl:copy-of select="(@*)"/>
      <!-- leg de koppeling naar ow -->
      <xsl:copy-of select="$ow/element()[@wId=$id]"/>
      <xsl:apply-templates select="element()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="(tekst:*)[@wId]">
    <xsl:element name="{local-name()}">
      <xsl:attribute name="pad" select="fn:string-join(ancestor-or-self::element()/local-name(),'/')"/>
      <xsl:attribute name="hash" select="digest:md5Hex(fn:string-join(descendant-or-self::text()/normalize-space(),' '))"/>
      <xsl:copy-of select="(@*)"/>
      <xsl:apply-templates select="element()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="element()">
    <xsl:apply-templates select="element()"/>
  </xsl:template>

  <xsl:template match="element()[element()[local-name()='identificatie']][@wId]">
    <xsl:variable name="id" select="element()[local-name()='identificatie']"/>
    <xsl:element name="{local-name()}">
      <xsl:attribute name="id" select="$id"/>
      <xsl:copy-of select="@wId"/>
      <xsl:for-each select="$ow_object[element()/element()/@xlink:href=$id]">
        <xsl:apply-templates select="."/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="element()[element()[local-name()='identificatie']][not(@wId)]">
    <xsl:element name="{local-name()}">
      <xsl:attribute name="id" select="element()[local-name()='identificatie']"/>
      <xsl:for-each select="element()[./element()/@xlink:href]">
        <xsl:element name="{local-name()}">
          <xsl:for-each select="element()[@xlink:href]">
            <xsl:variable name="id" select="@xlink:href"/>
            <xsl:apply-templates select="($ow_object[not(@wId)][element()[local-name()='identificatie']=$id],$id)[1]"/>
          </xsl:for-each>
          <xsl:for-each select="element()[element()[local-name()='identificatie']]">
            <xsl:apply-templates select="."/>
          </xsl:for-each>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>