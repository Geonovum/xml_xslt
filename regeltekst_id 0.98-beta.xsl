<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190801" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:g="http://www.geostandaarden.nl/imow/gebiedsaanwijzing/v20190801" xmlns:g-ref="http://www.geostandaarden.nl/imow/gebiedsaanwijzing-ref/v20190709" xmlns:da="http://www.geostandaarden.nl/imow/datatypenalgemeen/v20190801" xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek/v20190301" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie/v20190801" xmlns:l="http://www.geostandaarden.nl/imow/locatie/v20190801" xmlns:l-ref="http://www.geostandaarden.nl/imow/locatie-ref/v20190709" xmlns:rol-ref="http://www.geostandaarden.nl/imow/regelsoplocatie-ref/v20190709" xmlns:rkow="http://www.geostandaarden.nl/imow/regeltekstkoppelingow/v20190709" xmlns:r="http://www.geostandaarden.nl/imow/regels/v20190801" xmlns:r-ref="http://www.geostandaarden.nl/imow/regels-ref/v20190709" xmlns:p="http://www.geostandaarden.nl/imow/pons/v20190801">
   <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

   <!-- vanuit ant moet er een lijst met bestandsnamen in de parameter doorgegeven worden -->
   <xsl:param name="filename" select="('file:/C:/Users/g.wolbers/Desktop/Bestanden Marco/opdracht Heerde/regeltekst.xml','file:/C:/Users/g.wolbers/Desktop/Bestanden Marco/opdracht Heerde/activiteiten.xml','file:/C:/Users/g.wolbers/Desktop/Bestanden Marco/opdracht Heerde/gebieden.xml')"/>
   
   <!-- node_list bevat de nodes met een onderliggende locatie in de geselecteerd ow-bestanden -->
   <xsl:variable name="node_list" select="document($filename,.)//(r:JuridischeRegel|rol:Activiteit|g:Gebiedsaanwijzing|l:Gebiedengroep)"/>

   <xsl:template match="r:JuridischeRegel">
      <xsl:element name="{name()}">
         <xsl:attribute name="rkow:regeltekstId" select="r:artikelOfLid[1]/r-ref:RegeltekstRef[1]/@xlink:href"/>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="r:Regeltekst">
      <xsl:element name="{name()}">
         <xsl:attribute name="rkow:regeltekstId" select="r:identificatie[1]"/>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="rol:Activiteit">
      <xsl:variable name="id" select="rol:identificatie"/>
      <xsl:element name="{name()}">
         <xsl:attribute name="rkow:regeltekstId">
            <xsl:call-template name="get_RegeltekstId">
               <xsl:with-param name="node" select="$node_list[descendant::*[@xlink:href=$id]][1]"/>
            </xsl:call-template>
         </xsl:attribute>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="g:Gebiedsaanwijzing">
      <xsl:variable name="id" select="g:identificatie"/>
      <xsl:element name="{name()}">
         <xsl:attribute name="rkow:regeltekstId">
            <xsl:call-template name="get_RegeltekstId">
               <xsl:with-param name="node" select="$node_list[descendant::*[@xlink:href=$id]][1]"/>
            </xsl:call-template>
         </xsl:attribute>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="l:Gebiedengroep">
      <xsl:variable name="id" select="l:identificatie"/>
      <xsl:element name="{name()}">
         <xsl:attribute name="rkow:regeltekstId">
            <xsl:call-template name="get_RegeltekstId">
               <xsl:with-param name="node" select="$node_list[descendant::*[@xlink:href=$id]][1]"/>
            </xsl:call-template>
         </xsl:attribute>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="l:Gebied">
      <xsl:variable name="id" select="l:identificatie"/>
      <xsl:element name="{name()}">
         <xsl:attribute name="rkow:regeltekstId">
            <xsl:call-template name="get_RegeltekstId">
               <xsl:with-param name="node" select="$node_list[descendant::*[@xlink:href=$id]][1]"/>
            </xsl:call-template>
         </xsl:attribute>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:element>
   </xsl:template>

   <xsl:template match="p:Pons">
      <xsl:variable name="id" select="descendant::*/@xlink:href[1]"/>
      <xsl:element name="{name()}">
         <xsl:attribute name="rkow:regeltekstId">
            <xsl:call-template name="get_RegeltekstId">
               <xsl:with-param name="node" select="$node_list[descendant::*[@xlink:href=$id]][1]"/>
            </xsl:call-template>
         </xsl:attribute>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:element>
   </xsl:template>

   <xsl:template name="get_RegeltekstId">
      <xsl:param name="node"/>
      <xsl:choose>
         <xsl:when test="$node[self::r:JuridischeRegel]">
            <xsl:value-of select="$node/r:artikelOfLid[1]/r-ref:RegeltekstRef[1]/@xlink:href"/>
         </xsl:when>
         <xsl:when test="$node[self::rol:Activiteit]">
            <xsl:variable name="id" select="$node/rol:identificatie"/>
            <xsl:call-template name="get_RegeltekstId">
               <xsl:with-param name="node" select="$node_list[descendant::*[@xlink:href=$id]][1]"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="$node[self::g:Gebiedsaanwijzing]">
            <xsl:variable name="id" select="$node/g:identificatie"/>
            <xsl:call-template name="get_RegeltekstId">
               <xsl:with-param name="node" select="$node_list[descendant::*[@xlink:href=$id]][1]"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="$node[self::l:Gebiedengroep]">
            <xsl:variable name="id" select="$node/l:identificatie"/>
            <xsl:call-template name="get_RegeltekstId">
               <xsl:with-param name="node" select="$node_list[descendant::*[@xlink:href=$id]][1]"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="$node[self::p:Pons]">
            <xsl:variable name="id" select="$node/descendant::*/@xlink:href[1]"/>
            <xsl:call-template name="get_RegeltekstId">
               <xsl:with-param name="node" select="$node_list[descendant::*[@xlink:href=$id]][1]"/>
            </xsl:call-template>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="@rkow:regeltekstId">
      <!-- doe niets -->
   </xsl:template>

   <!-- Algemene templates -->

   <xsl:template match="element()">
      <xsl:element name="{name()}">
         <xsl:apply-templates select="namespace::*|@*|node()"/>
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

   <xsl:template match="comment()|processing-instruction()">
      <xsl:copy-of select="."/>
   </xsl:template>

</xsl:stylesheet>