<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="xs" version="2.0">
   <xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" standalone="yes"/>

   <xsl:param name="file.name"/>
   <xsl:param name="file.fullname"/>
   <xsl:param name="file.type" select="tokenize($file.name,'\.')[last()]"/>
   <xsl:param name="file.checksum"/>

   <!-- checksum maakt een tijdelijk bestand met informatie over het bestand -->

   <xsl:template match="/">
      <xsl:element name="file">
         <xsl:element name="name">
            <xsl:value-of select="$file.name"/>
         </xsl:element>
         <xsl:element name="fullname">
            <xsl:value-of select="fn:string-join(tokenize($file.fullname,'\\'),'/')"/>
         </xsl:element>
         <xsl:element name="type">
            <xsl:value-of select="$file.type"/>
         </xsl:element>
         <xsl:element name="checksum">
            <xsl:value-of select="$file.checksum"/>
         </xsl:element>
      </xsl:element>
   </xsl:template>

   <xsl:template match="*">
      <xsl:element name="{name()}">
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates select="node()"/>
      </xsl:element>
   </xsl:template>

</xsl:stylesheet>