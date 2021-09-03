<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:lvbb="http://www.overheid.nl/2017/lvbb" version="2.0">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

  <xsl:param name="temp.dir"/>

  <!-- haal mapping akn op -->

  <xsl:param name="akn" select="collection(concat($temp.dir,'?select=akn.xml'))//node[@gewijzigd=true()]" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/"/>

  <!-- controleer @ref -->

  <xsl:template match="IntRef/@ref" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/tekst/">
    <xsl:variable name="eId" select="."/>
    <xsl:variable name="node" select="$akn[$eId=./fn:tokenize(@oud,'\|')]"/>
    <xsl:attribute name="ref" select="($node/@eId,$eId)[1]"/>
  </xsl:template>

  <!-- controleer eId -->

  <xsl:template match="BeoogdInformatieobject/eId" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:variable name="componentnaam" select="fn:tokenize(.,'#')[1]"/>
    <xsl:variable name="eId" select="fn:tokenize(.,'#')[2]"/>
    <xsl:variable name="node" select="$akn[$eId=./fn:tokenize(@oud,'\|')]"/>
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:value-of select="fn:string-join(($componentnaam,($node/@eId,$eId)[1]),'#')"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="BeoogdeRegeling/eId" xpath-default-namespace="https://standaarden.overheid.nl/stop/imop/data/">
    <xsl:variable name="eId" select="."/>
    <xsl:variable name="node" select="$akn[$eId=./fn:tokenize(@oud,'\|')]"/>
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:value-of select="($node/@eId,$eId)[1]"/>
    </xsl:element>
  </xsl:template>

  <!-- Algemene templates -->

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
        <xsl:copy-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="comment()|processing-instruction()">
    <xsl:copy-of select="."/>
  </xsl:template>

</xsl:stylesheet>