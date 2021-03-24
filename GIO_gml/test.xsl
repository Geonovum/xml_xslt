<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="text"/>

    <xsl:param name="src" select="'F:/DSO/Geonovum/GitHub/xml_xslt/GML-bestandenBrittBruidschat'"/>
    <xsl:param name="valid" select="'valid'"/>
    <xsl:param name="file" select="'Zinkassengebied_Boxtel.gml'"/>
    
    <xsl:template match="/">
        <xsl:message select="$valid"/>
        <xsl:message select="$file"/>
        <xsl:value-of select="concat($src,'&#xa;')"/>
        <xsl:value-of select="concat($valid,'&#xa;')"/>
        <xsl:value-of select="concat($file,'&#xa;')"/>
        <xsl:variable name="bestand" select="collection(concat('file:/',$src,'/',$valid,'?select=',$file))"/>
        <xsl:value-of select="$bestand"/>
    </xsl:template>
</xsl:stylesheet>