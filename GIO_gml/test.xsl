<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="text"/>

    <xsl:param name="valid.file" select="'F:/DSO/Geonovum/GitHub/xml_xslt/GML-bestandenBrittBruidschat/valid/Zinkassengebied_Boxtel.gml'"/>
    
    <xsl:template match="/">
        <xsl:message terminate="no"><xsl:value-of select="$valid.file"/></xsl:message>
        <xsl:value-of select="concat($valid.file,'&#xa;')"/>
        <xsl:variable name="bestand" select="document(concat('file:/',$valid.file))"/>
        <xsl:value-of select="string(./element()/local-name())"/>
    </xsl:template>
</xsl:stylesheet>