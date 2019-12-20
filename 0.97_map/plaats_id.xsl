<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:gml="http://www.opengis.net/gml/3.2" exclude-result-prefixes="#all">
    
    <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>   
    <xsl:param name="alginelement" select="('tgroup','entry')"/>
    
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>   
    
    <!-- add Regeling id -->
    <!--
    <xsl:template match="/Besluit/Regeling">
        <xsl:copy>
            <xsl:variable name="regelingId" select="fn:generate-id()"/>
            <xsl:attribute name="id" select="$regelingId"> </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
   -->
    
    <!-- add attribute align to tgroup and entry -->
    
    <xsl:template match="tgroup" priority="1">      
        <xsl:copy>
            <xsl:attribute name="align">left</xsl:attribute>
            <xsl:apply-templates select="@*"/>          
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="entry" priority="1">      
        <xsl:copy>
            <xsl:attribute name="align">left</xsl:attribute>
            <xsl:apply-templates select="@*"/>          
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- add attribute type to lijst -->
    
    <xsl:template match="Lijst" priority="1">      
        <xsl:copy>
            <xsl:attribute name="type">ongemarkeerd</xsl:attribute>
            <xsl:apply-templates select="@*"/>          
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- add attribute type to lijst -->
    
    <xsl:template match="thead" priority="1">      
        <xsl:copy>
            <xsl:attribute name="valign">top</xsl:attribute>
            <xsl:apply-templates select="@*"/>          
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    
    
    <!-- add value of Waarde imop:Geometrie -->
    <!--
    <xsl:variable name="werkingsgebiedID" select="fn:generate-id()"/>
    <xsl:variable name="Dateid"
        select="translate(substring(string(current-dateTime()), 1, 23), '-:T.', '')"/>
    
   -->
    <!-- add Regeling id -->
    <!--
    <xsl:template match="/Besluit/Regeling">
        <xsl:copy>
            <xsl:variable name="regelingId" select="fn:generate-id()"/>
            <xsl:attribute name="id" select="$regelingId">
            </xsl:attribute>
            <xsl:apply-templates/>    
        </xsl:copy>
    </xsl:template>  
    -->
</xsl:stylesheet>
