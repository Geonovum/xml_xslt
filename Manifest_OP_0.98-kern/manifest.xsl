<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns="http://www.overheid.nl/2017/lvbb"
    >
    <!--  
    
    Maak met commandline opdracht een tekstbestand met bestandsnamen,
    voer in de folder met de OP en OW bestanden de volgende opdracht uit:
    dir /B | findstr /v /i "dir.txt$" >dir.txt
    
    Bestanden die niet in de levering meegaan verwijderen uit tekstbestand
    
    -->
    <xsl:output indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!-- Volledig pad naar dir.txt opnemen achter file:/// -->
    <xsl:param name="text-uri" as="xs:string" select="'file:///'"/>
    <xsl:param name="text-encoding" as="xs:string" select="'UTF-8'"/>
    
    <xsl:template name="wrapLines">
        <xsl:param name="pText" select="."/>
        <xsl:param name="pNumLines" select="10"/>
        <xsl:if test="string-length($pText) and $pNumLines > 0">
            <xsl:variable name="vLine" select="substring-before($pText, '&#xD;')"/>
                <xsl:element name="bestand">
                    <xsl:element name="bestandsnaam">
                        <xsl:value-of select="$vLine"/>
                    </xsl:element>
                    <xsl:element name="contentType">
                        <xsl:if test="substring($vLine,string-length($vLine)-2)='gml'">
                            <xsl:value-of select="'application/gml+xml'"/> <!-- TODO: voorwaardelijk maken adhv extensie -->
                        </xsl:if>
                        <xsl:if test="substring($vLine,string-length($vLine)-2)='xml'">
                            <xsl:value-of select="'application/xml'"/> <!-- TODO: voorwaardelijk maken adhv extensie -->
                        </xsl:if>
                    </xsl:element>
                </xsl:element>
            <xsl:call-template name="wrapLines">
                <xsl:with-param name="pNumLines" select="$pNumLines"/>
                <xsl:with-param name="pText" select="substring-after($pText, '&#xA;')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:element name="manifest" xpath-default-namespace="http://www.overheid.nl/2017/lvbb" inherit-namespaces="yes">
            <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
            <xsl:namespace name="stop">http://www.overheid.nl/2017/stop</xsl:namespace>
            <xsl:attribute name="xsi:schemaLocation">http://www.overheid.nl/2017/lvbb ../lvbb/lvbb-transport.xsd</xsl:attribute>
            <xsl:choose>
                <xsl:when test="unparsed-text-available($text-uri, $text-encoding)">
                    <xsl:call-template name="wrapLines">
                        <xsl:with-param name="pText" select="unparsed-text($text-uri, $text-encoding)"/>
                    </xsl:call-template>                                
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="error">
                        <xsl:text>Error reading "</xsl:text>
                        <xsl:value-of select="$text-uri"/>
                        <xsl:text>" (encoding "</xsl:text>
                        <xsl:value-of select="$text-encoding"/>
                        <xsl:text>").</xsl:text>
                    </xsl:variable>
                    <xsl:message><xsl:value-of select="$error"/></xsl:message>
                    <xsl:value-of select="$error"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
            
</xsl:stylesheet>