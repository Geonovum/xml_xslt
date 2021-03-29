<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0"
    xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/"
    xmlns:gio="https://standaarden.overheid.nl/stop/imop/gio/"
    xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns="http://www.test.com/"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" version="1.0" indent="yes" encoding="UTF-8" standalone="yes"/>

    <xsl:param name="valid.file" select="string('F:\DSO\Geonovum\GitHub\xml_xslt\GML-bestandenBrittBruidschat\valid')"/>
    <!--<xsl:param name="file" select="tokenize(base-uri(),'/')[last()]"/>-->
    <xsl:variable name="valide_bestand" select="document(concat('file:/',$valid.file))"/>
    <!--<xsl:param name="valide_bestand" select="collection(concat('file:/', $valid.dir, '?select=', $bestand_naam))"/>-->
    
    <!--Identity template, kopieer alle inhoud -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- van alle Locaties de inhoud van basisgeo:geometrie vervangen -->
    <xsl:template match="//*[local-name()='Locatie']/*[local-name()='geometrie']/*[local-name()='Geometrie']/*[local-name()='geometrie']/child::element()" >
        <xsl:variable name="positie" as="xs:int">
            <xsl:number select="./../../../.."/>
        </xsl:variable>
        <xsl:variable name="srsName" select="@srsName"/>
        <xsl:variable name="gml_id" select="@gml:id"/>
        <!-- kopieer geo:geometry inhoud van valide bestand -->
        <xsl:copy select="$valide_bestand//*[local-name()='featureMember'][$positie]/*[local-name()='SELECT']/*[local-name()='geometry']/child::element()" inherit-namespaces="no" copy-namespaces="no">
            <xsl:apply-templates select="@*|node()" mode="next">
                <xsl:with-param name="srsName" select="$srsName"/>
                <xsl:with-param name="gml_id" select="$gml_id"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@*|node()" mode="next">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()" mode="next"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@srsName" mode="next">
        <xsl:param name="srsName"/>
        <xsl:attribute name="srsName" select="$srsName"/>
    </xsl:template>
    
    <xsl:template match="@gml:id" mode="next">
        <xsl:param name="gml_id"/>
        <xsl:if test="$gml_id">
            <xsl:attribute name="gml:id" select="$gml_id"/>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>