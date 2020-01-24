<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901"
    xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek/v20190301"
    xmlns:l="http://www.geostandaarden.nl/imow/locatie/v20190901"
    xmlns:l-ref="http://www.geostandaarden.nl/imow/locatie-ref/v20190901"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:g-ref="http://www.geostandaarden.nl/imow/geometrie-ref/v20190901"
    xmlns:rkow="http://www.geostandaarden.nl/imow/owobject/v20190709" exclude-result-prefixes="xs"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0">

    <xsl:output encoding="UTF-8"/>

    <xsl:variable name="baseGebiedRef" select="'nl.imow-mnre1034.gebiedengroep.201912011101'"/>

    <xsl:template match="/">
        <xsl:variable name="Tijdelijk">
            <xsl:element name="ow-dc:owBestand"
                xmlns:rkow="http://www.geostandaarden.nl/imow/owobject/v20190709"
                xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901">
                <xsl:namespace name="rkow"
                    select="'http://www.geostandaarden.nl/imow/owobject/v20190709'"/>
                <xsl:namespace name="ow-dc"
                    select="'http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901'"/>
                <xsl:namespace name="l"
                    select="'http://www.geostandaarden.nl/imow/locatie/v20190901'"/>
                <xsl:for-each
                    select="/ow-dc:owBestand/sl:standBestand/sl:stand/ow-dc:owObject/l:Gebiedengroep">
                    <xsl:element name="ow-dc:Gebiedengroep">
                        <xsl:attribute name="rkow:regeltekstId" select="@rkow:regeltekstId"/>
                        <xsl:variable name="noemer">
                            <xsl:choose>
                                <xsl:when test="../../preceding-sibling::comment()[1]">
                                    <xsl:value-of select="../../preceding-sibling::comment()[1]"/>
                                </xsl:when>
                                <xsl:otherwise><xsl:value-of select="'Locatie-NL'"/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:element name="l:identificatie">
                            <xsl:value-of select="l:identificatie"/>
                        </xsl:element>
                        <xsl:variable name="pre"
                            select="substring-before(l:identificatie, 'gebiedengroep')"/>
                        <xsl:variable name="post"
                            select="substring-after(l:identificatie, 'gebiedengroep')"/>
                        <xsl:variable name="gebied">
                            <xsl:value-of select="concat($pre, 'gebied', $post)"/>
                        </xsl:variable>
                        <xsl:element name="l:groepselement">
                            <xsl:for-each select="l:groepselement/l-ref:GebiedRef">
                                <xsl:element name="Gebied">
                                    <xsl:element name="identificatie">
                                        <xsl:value-of
                                            select="concat($gebied, format-number(position(), '000'))"
                                        />
                                    </xsl:element>
                                    <xsl:element name="noemer">
                                        <xsl:value-of
                                            select="replace($noemer, '^\s*(.+?)\s*$', '$1')"/>
                                    </xsl:element>
                                    <xsl:element name="geometrie">
                                        <xsl:value-of select="@xlink:href"/>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:variable>

        <xsl:variable name="Gebiedengroepen">
            <xsl:element name="ow-dc:owBestand">
                <xsl:namespace name="ow-dc"
                    select="'http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901'"/>
                <xsl:namespace name="xlink" select="'http://www.w3.org/1999/xlink'"/>
                <xsl:namespace name="g-ref"
                    select="'http://www.geostandaarden.nl/imow/geometrie-ref/v20190901'"/>
                <xsl:namespace name="ga"
                    select="'http://www.geostandaarden.nl/imow/gebiedsaanwijzing/v20190709'"/>
                <xsl:namespace name="ga-ref"
                    select="'http://www.geostandaarden.nl/imow/gebiedsaanwijzing-ref/v20190709'"/>
                <xsl:namespace name="da"
                    select="'http://www.geostandaarden.nl/imow/datatypenalgemeen/v20190709'"/>
                <xsl:namespace name="sl"
                    select="'http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek/v20190301'"/>
                <xsl:namespace name="rol"
                    select="'http://www.geostandaarden.nl/imow/regelsoplocatie/v20190901'"/>
                <xsl:namespace name="l"
                    select="'http://www.geostandaarden.nl/imow/locatie/v20190901'"/>
                <xsl:namespace name="l-ref"
                    select="'http://www.geostandaarden.nl/imow/locatie-ref/v20190901'"/>
                <xsl:namespace name="rol-ref"
                    select="'http://www.geostandaarden.nl/imow/regelsoplocatie-ref/v20190709'"/>
                <xsl:namespace name="rkow"
                    select="'http://www.geostandaarden.nl/imow/owobject/v20190709'"/>
                <xsl:namespace name="r"
                    select="'http://www.geostandaarden.nl/imow/regels/v20190901'"/>
                <xsl:namespace name="r-ref"
                    select="'http://www.geostandaarden.nl/imow/regels-ref/v20190901'"/>
                <xsl:namespace name="xsi" select="'http://www.w3.org/2001/XMLSchema-instance'"/>
                <xsl:attribute name="xsi:schemaLocation"
                    select="'http://www.geostandaarden.nl/imow/0.98.1 https://raw.githubusercontent.com/Geonovum/xml_ow_xsd_0.98.2-kern/master/xsd/bestanden-ow/deelbestand-ow/v20190901/IMOW_Deelbestand_v0_9_8_2.xsd'"/>
                <xsl:element name="sl:standBestand">
                    <xsl:copy-of select="ow-dc:owBestand/sl:standBestand/sl:dataset"/>
                    <xsl:copy-of select="ow-dc:owBestand/sl:standBestand/sl:inhoud"/>
                    <xsl:for-each select="$Tijdelijk/ow-dc:owBestand/ow-dc:Gebiedengroep">
                        <xsl:element name="sl:stand">
                            <xsl:element name="ow-dc:owObject">
                                <xsl:element name="l:Gebiedengroep">
                                    <xsl:attribute name="rkow:regeltekstId"
                                        select="@rkow:regeltekstId"/>
                                    <xsl:element name="l:identificatie">
                                        <xsl:value-of select="l:identificatie"/>
                                    </xsl:element>
                                    <xsl:element name="l:groepselement">
                                        <xsl:for-each select="l:groepselement/Gebied">
                                            <xsl:element name="l-ref:GebiedRef">
                                                <xsl:attribute name="xlink:href"
                                                  select="identificatie"/>
                                            </xsl:element>
                                        </xsl:for-each>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
        </xsl:variable>
        <xsl:variable name="Gebieden">
            <xsl:element name="ow-dc:owBestand">
                <xsl:namespace name="ow-dc"
                    select="'http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901'"/>
                <xsl:namespace name="xlink" select="'http://www.w3.org/1999/xlink'"/>
                <xsl:namespace name="g-ref"
                    select="'http://www.geostandaarden.nl/imow/geometrie-ref/v20190901'"/>
                <xsl:namespace name="ga"
                    select="'http://www.geostandaarden.nl/imow/gebiedsaanwijzing/v20190709'"/>
                <xsl:namespace name="ga-ref"
                    select="'http://www.geostandaarden.nl/imow/gebiedsaanwijzing-ref/v20190709'"/>
                <xsl:namespace name="da"
                    select="'http://www.geostandaarden.nl/imow/datatypenalgemeen/v20190709'"/>
                <xsl:namespace name="sl"
                    select="'http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek/v20190301'"/>
                <xsl:namespace name="rol"
                    select="'http://www.geostandaarden.nl/imow/regelsoplocatie/v20190901'"/>
                <xsl:namespace name="l"
                    select="'http://www.geostandaarden.nl/imow/locatie/v20190901'"/>
                <xsl:namespace name="l-ref"
                    select="'http://www.geostandaarden.nl/imow/locatie-ref/v20190901'"/>
                <xsl:namespace name="rol-ref"
                    select="'http://www.geostandaarden.nl/imow/regelsoplocatie-ref/v20190709'"/>
                <xsl:namespace name="rkow"
                    select="'http://www.geostandaarden.nl/imow/owobject/v20190709'"/>
                <xsl:namespace name="r"
                    select="'http://www.geostandaarden.nl/imow/regels/v20190901'"/>
                <xsl:namespace name="r-ref"
                    select="'http://www.geostandaarden.nl/imow/regels-ref/v20190901'"/>
                <xsl:namespace name="g-ref" select="'http://www.geostandaarden.nl/imow/geometrie-ref/v20190901'"></xsl:namespace>
                <xsl:namespace name="xsi" select="'http://www.w3.org/2001/XMLSchema-instance'"/>
                <xsl:attribute name="xsi:schemaLocation"
                    select="'http://www.geostandaarden.nl/imow/0.98.1 https://raw.githubusercontent.com/Geonovum/xml_ow_xsd_0.98.2-kern/master/xsd/bestanden-ow/deelbestand-ow/v20190901/IMOW_Deelbestand_v0_9_8_2.xsd'"/>
                <xsl:element name="sl:standBestand">
                    <xsl:copy-of select="ow-dc:owBestand/sl:standBestand/sl:dataset"/>
                    <xsl:element name="sl:inhoud">
                        <xsl:copy-of select="ow-dc:owBestand/sl:standBestand/sl:inhoud/sl:gebied"/>
                        <xsl:copy-of
                            select="ow-dc:owBestand/sl:standBestand/sl:inhoud/sl:leveringsId"/>
                        <xsl:element name="sl:objectTypen">
                            <xsl:element name="sl:objectType">Gebied</xsl:element>
                        </xsl:element>
                    </xsl:element>
                    <xsl:for-each select="$Tijdelijk/ow-dc:owBestand/ow-dc:Gebiedengroep/l:groepselement/Gebied">
                        <xsl:element name="sl:stand">
                            <xsl:element name="ow-dc:owObject">
                                <xsl:element name="l:Gebied">
                                    <xsl:attribute name="rkow:regeltekstId"
                                        select="../../@rkow:regeltekstId"/>
                                    <xsl:element name="l:identificatie">
                                        <xsl:value-of select="identificatie"/>
                                    </xsl:element>
                                    <xsl:element name="l:noemer">
                                        <xsl:value-of select="noemer"/>
                                    </xsl:element>
                                    <xsl:element name="l:geometrie">
                                        <xsl:element name="g-ref:GeometrieRef">
                                            <xsl:attribute name="xlink:href" select="geometrie"></xsl:attribute>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
        </xsl:variable>
        <xsl:result-document href="Gebiedengroep.xml">
            <xsl:copy-of select="$Gebiedengroepen"/>
        </xsl:result-document>
        <xsl:result-document href="Gebied.xml">
            <xsl:copy-of select="$Gebieden"/>
        </xsl:result-document>
        <xsl:result-document href="Tijdelijk.xml">
            <xsl:copy-of select="$Tijdelijk"/>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>
