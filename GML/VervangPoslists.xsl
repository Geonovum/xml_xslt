<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:functx="http://whatever"
    xmlns:gml="http://www.opengis.net/gml/3.2" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0">
    
    <!-- vervangt poslists in een gml bestand gml_naam.gml door de poslists die in een gml_naam_temp.gml staan
        Het oorspronkelijke bestand wordt niet overschreven, maar er wordt een bestand gml_naam_nieuw.gml gecreeerd.
        Voorwaarde is dat het gml_naam_temp.gml bestand evenveel poslists heeft als het bestand gml_naam.gml
        
        De routine zou voor iedere versie van het imop-geo moeten werken, het begint pas met ploegen als het gml-namespace wordt bereikt.
        Ook de structuren die voor de gml-namespace bestaan worden met rust gelaten/overgenomen uit het oorspronkelijke gml_naam.gml bestand
    -->

    <xsl:variable name="basisnaam_document"
        select="substring(document-uri(), 0, string-length(document-uri()) - 3)"/>
    <xsl:variable name="posListDocNaam" select="concat($basisnaam_document, '_temp.gml')"/>
    <xsl:variable name="posListDoc" select="document($posListDocNaam)"/>
    <xsl:variable name="surfaceMemberArrayPosList">
        <xsl:for-each select="$posListDoc//gml:posList">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="nieuwDocNaam" select="concat($basisnaam_document, '_nieuw.gml')"/>

    <xsl:template match="/">
        <xsl:comment select="$basisnaam_document"/>
        <xsl:result-document href="{$nieuwDocNaam}">
            <xsl:apply-templates/>
        </xsl:result-document>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:choose>
            <xsl:when test="name()='gml:posList'">
                <xsl:variable name="text" select="text()"/>
                <xsl:variable name="posPosList">
                    <xsl:for-each select="//gml:posList">
                        <xsl:if test="./text()=$text">
                            <xsl:value-of select="position()"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="replaceWith">
                    <xsl:for-each select="$surfaceMemberArrayPosList/*">
                        <xsl:if test="$posPosList = position()">
                            <xsl:value-of select="."/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:message select="$posPosList"></xsl:message>
                <xsl:message select="text()"></xsl:message>
                <xsl:message select="$replaceWith"></xsl:message>
                <xsl:element name="gml:posList">
                    <xsl:value-of select="$replaceWith"></xsl:value-of>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
