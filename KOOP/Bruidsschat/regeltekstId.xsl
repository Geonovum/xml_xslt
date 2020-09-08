<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:g-ref="http://www.geostandaarden.nl/imow/geometrie-ref/v20190901" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing/v20190709" xmlns:ga-ref="http://www.geostandaarden.nl/imow/gebiedsaanwijzing-ref/v20190709" xmlns:da="http://www.geostandaarden.nl/imow/datatypenalgemeen/v20190709" xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek/v20190301" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie/v20190901" xmlns:l="http://www.geostandaarden.nl/imow/locatie/v20190901" xmlns:l-ref="http://www.geostandaarden.nl/imow/locatie-ref/v20190901" xmlns:rol-ref="http://www.geostandaarden.nl/imow/regelsoplocatie-ref/v20190709" xmlns:ow="http://www.geostandaarden.nl/imow/owobject/v20190709" xmlns:r="http://www.geostandaarden.nl/imow/regels/v20190901" xmlns:r-ref="http://www.geostandaarden.nl/imow/regels-ref/v20190901" xmlns:p="http://www.geostandaarden.nl/imow/pons/v20190901">
   <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
   
   <xsl:param name="base.dir" select="string('file:/C:/Werkbestanden/Geonovum/Bruidsschat/stap_2')"/>

   <xsl:param name="collection">
      <xsl:for-each select="fn:collection(concat($base.dir,'?select=*.xml'))//(r:Instructieregel|r:Omgevingswaarderegel|r:RegelVoorIedereen)">
         <xsl:copy-of select="."/>
      </xsl:for-each>
      <xsl:for-each select="fn:collection(concat($base.dir,'?select=*.xml'))//(rol:Activiteit|ga:Gebiedsaanwijzing)">
         <xsl:copy-of select="."/>
      </xsl:for-each>
      <xsl:for-each select="fn:collection(concat($base.dir,'?select=*.xml'))//(l:Gebiedengroep)">
         <xsl:copy-of select="."/>
      </xsl:for-each>
   </xsl:param>
   <xsl:param name="node_list" select="$collection/element()"/>

   <xsl:template match="r:Instructieregel|r:Omgevingswaarderegel|r:RegelVoorIedereen">
      <xsl:element name="{name()}">
         <xsl:attribute name="ow:regeltekstId" select="r:artikelOfLid[1]/r-ref:RegeltekstRef[1]/@xlink:href"/>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:element>
   </xsl:template>
   
   <xsl:template match="rol:Activiteit">
      <xsl:variable name="id" select="rol:identificatie"/>
      <xsl:element name="{name()}">
         <xsl:attribute name="ow:regeltekstId">
            <xsl:call-template name="get_RegeltekstId">
               <xsl:with-param name="node" select="$node_list[descendant::*[not(parent::rol:bovenliggendeActiviteit)][@xlink:href=$id]][1]"/>
            </xsl:call-template>
         </xsl:attribute>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:element>
   </xsl:template>
   
   <xsl:template match="ga:Gebiedsaanwijzing">
      <xsl:variable name="id" select="ga:identificatie"/>
      <xsl:element name="{name()}">
         <xsl:attribute name="ow:regeltekstId">
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
         <xsl:attribute name="ow:regeltekstId">
            <xsl:call-template name="get_RegeltekstId">
               <xsl:with-param name="node" select="$node_list[descendant::*[@xlink:href=$id]][1]"/>
            </xsl:call-template>
         </xsl:attribute>
         <xsl:apply-templates select="@*|node()"/>
      </xsl:element>
   </xsl:template>
   
   <xsl:template match="l:Gebied">
      <xsl:variable name="id" select="l:identificatie"/>
      <xsl:variable name="node" select="$node_list[descendant::*[@xlink:href=$id]][1]"/>
      <xsl:element name="{name()}">
         <xsl:attribute name="ow:regeltekstId">
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
         <xsl:when test="$node[self::r:Instructieregel]">
            <xsl:value-of select="$node/r:artikelOfLid[1]/r-ref:RegeltekstRef[1]/@xlink:href"/>
         </xsl:when>
         <xsl:when test="$node[self::r:Omgevingswaarderegel]">
            <xsl:value-of select="$node/r:artikelOfLid[1]/r-ref:RegeltekstRef[1]/@xlink:href"/>
         </xsl:when>
         <xsl:when test="$node[self::r:RegelVoorIedereen]">
            <xsl:value-of select="$node/r:artikelOfLid[1]/r-ref:RegeltekstRef[1]/@xlink:href"/>
         </xsl:when>
         <xsl:when test="$node[self::rol:Activiteit]">
            <xsl:variable name="id" select="$node/rol:identificatie"/>
            <xsl:call-template name="get_RegeltekstId">
               <xsl:with-param name="node" select="$node_list[descendant::*[not(parent::rol:bovenliggendeActiviteit)][@xlink:href=$id]][1]"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="$node[self::ga:Gebiedsaanwijzing]">
            <xsl:variable name="id" select="$node/ga:identificatie"/>
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
      </xsl:choose>
   </xsl:template>
   
   <xsl:template match="@ow:regeltekstId">
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