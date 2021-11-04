<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="2.0"
    xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" 
    xmlns:ow="http://www.geostandaarden.nl/imow/owobject" 
    xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" 
    xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" 
    xmlns:k="http://www.geostandaarden.nl/imow/kaart" 
    xmlns:l="http://www.geostandaarden.nl/imow/locatie" 
    xmlns:p="http://www.geostandaarden.nl/imow/pons" 
    xmlns:r="http://www.geostandaarden.nl/imow/regels" 
    xmlns:rg="http://www.geostandaarden.nl/imow/regelingsgebied" 
    xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" 
    xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" 
    xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0"
    xmlns:lvbb="http://www.overheid.nl/2017/lvbb"
    xmlns:aanlevering="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"
    xmlns:data="https://standaarden.overheid.nl/stop/imop/data/" 
    xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/"
    xmlns:manifest-ow="http://www.geostandaarden.nl/bestanden-ow/manifest-ow"
    xmlns:gio="https://standaarden.overheid.nl/stop/imop/gio/"
    
    xmlns:foo="http://whatever"
    >
    <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
    
    <xsl:param name="oldIoRefId"/>
    <xsl:param name="oldIoWorkId"/>
    <xsl:param name="alreadyRetrievedDateTime"/>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tekst:ExtIoRef[text()=$oldIoRefId]">
        <xsl:element name="tekst:ExtIoRef">
            <xsl:attribute name="wId">
                <xsl:value-of select="@wId"/>
            </xsl:attribute>
            <xsl:attribute name="eId">
                <xsl:value-of select="@eId"/>
            </xsl:attribute>
            <xsl:attribute name="ref">
                <xsl:value-of select="foo:generateFRBRExpression($oldIoRefId)"/>
            </xsl:attribute>
            <xsl:value-of select="foo:generateFRBRExpression($oldIoRefId)"/>
        </xsl:element>
    </xsl:template>
    
    
    <xsl:template match="data:BeoogdInformatieobject/data:instrumentVersie[text()=$oldIoRefId]">
        <xsl:element name="data:instrumentVersie">
            <xsl:value-of select="foo:generateFRBRExpression($oldIoRefId)"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="data:informatieobjectRefs/data:informatieobjectRef[text()=$oldIoRefId]">
        <xsl:element name="data:informatieobjectRef">
            <xsl:value-of select="foo:generateFRBRExpression($oldIoRefId)"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="data:FRBRExpression[text()=$oldIoRefId]">
        <xsl:element name="data:FRBRExpression">
            <xsl:value-of select="foo:generateFRBRExpression($oldIoRefId)"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="geo:FRBRExpression[text()=$oldIoRefId]">
        <xsl:element name="geo:FRBRExpression">
            <xsl:value-of select="foo:generateFRBRExpression($oldIoRefId)"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="data:FRBRWork[text()=$oldIoWorkId]">
        <xsl:element name="data:FRBRWork">
            <xsl:value-of select="foo:generateFRBRWork($oldIoWorkId)"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="data:InformatieObjectMetadata/data:officieleTitel[text()=$oldIoWorkId]">
        <xsl:element name="data:officieleTitel">
            <xsl:value-of select="foo:generateFRBRWork($oldIoWorkId)"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="geo:FRBRWork[text()=$oldIoWorkId]">
        <xsl:element name="geo:FRBRWork">
            <xsl:value-of select="foo:generateFRBRWork($oldIoWorkId)"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:function name="foo:generateFRBRWork">
        <xsl:param name="oldId" as="xs:string"/>
        <xsl:value-of
            select="concat('/', tokenize($oldId, '/')[2], '/', tokenize($oldId, '/')[3], '/', tokenize($oldId, '/')[4], '/', tokenize($oldId, '/')[5], '/', tokenize($oldId, '/')[6], '/', concat(tokenize($oldId, '/')[7], '-', $alreadyRetrievedDateTime))"
        />
    </xsl:function>
    
    <xsl:function name="foo:generateFRBRExpression">
        <xsl:param name="oldId" as="xs:string"/>
        <xsl:value-of
            select="concat('/', tokenize($oldId, '/')[2], '/', tokenize($oldId, '/')[3], '/', tokenize($oldId, '/')[4], '/', tokenize($oldId, '/')[5], '/', tokenize($oldId, '/')[6], '/', concat(tokenize($oldId, '/')[7], '-', $alreadyRetrievedDateTime), '/', tokenize($oldId, '/')[8])"
        />
    </xsl:function>
    
    
</xsl:stylesheet>