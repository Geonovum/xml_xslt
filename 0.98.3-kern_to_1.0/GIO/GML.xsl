<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/"
    xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/"
    xmlns:imop="https://standaarden.overheid.nl/lvbb/stop/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ogr="http://ogr.maptools.org/"
    xmlns:saxon="http://saxon.sf.net/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901"
    xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns:g-ref="http://www.geostandaarden.nl/imow/geometrie-ref/v20190901"
    xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing/v20190709"
    xmlns:g="http://www.geostandaarden.nl/imow/gebiedsaanwijzing/v20190709"
    xmlns:ga-ref="http://www.geostandaarden.nl/imow/gebiedsaanwijzing-ref/v20190709"
    xmlns:da="http://www.geostandaarden.nl/imow/datatypenalgemeen/v20190709"
    xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek/v20190301"
    xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie/v20190901"
    xmlns:l="http://www.geostandaarden.nl/imow/locatie/v20190901"
    xmlns:l-ref="http://www.geostandaarden.nl/imow/locatie-ref/v20190901"
    xmlns:rol-ref="http://www.geostandaarden.nl/imow/regelsoplocatie-ref/v20190709"
    xmlns:rkow="http://www.geostandaarden.nl/imow/owobject/v20190709"
    xmlns:r="http://www.geostandaarden.nl/imow/regels/v20190901"
    xmlns:r-ref="http://www.geostandaarden.nl/imow/regels-ref/v20190901"
    xmlns:geo="http://www.geostandaarden.nl/basisgeometrie/v20190901"
    xmlns:geo_stop="https://standaarden.overheid.nl/stop/imop/geo/"
    xmlns:gio="https://standaarden.overheid.nl/stop/imop/gio/"
    xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:lvbb="http://www.overheid.nl/2017/lvbb"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xsi:schemaLocation="http://www.overheid.nl/imop/def# ../lvbb/LVBB-stop.xsd"
    xmlns="https://standaarden.overheid.nl/lvbb/stop/">
    <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

    <!-- Pad naar het setje bestanden van de opdracht -->
    <xsl:param name="bron_folder"
        select="'file:///F:/DSO/Geonovum/GitHub/xml_omgevingsplan_gemeentestad_0.98.3-kern/Opdracht'"/>
    <xsl:param name="doel_folder"
        select="'file:///F:/DSO/Geonovum/GitHub/xml_omgevingsplan_gemeentestad_1.0-test/Opdracht'"/>

    <xsl:template mode="locaties" match="/geo:FeatureCollectionGeometrie/geo:featureMember">
        <xsl:element name="geo:Locatie">
            <xsl:element name="geo:geometrie">
                <xsl:element name="basisgeo:Geometrie">
                    <xsl:variable name="gml_id" select="geo:Geometrie[1]/geo:id[1]/text()"/>
                    <xsl:attribute name="gml:id" select="concat('id-', $gml_id, '-xx')"/>
                    <xsl:element name="basisgeo:id">
                        <xsl:value-of select="$gml_id"/>
                    </xsl:element>
                    <xsl:element name="basisgeo:geometrie">
                        <xsl:copy-of select="geo:Geometrie[1]/geo:geometrie/node()"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template mode="root" match=".">
        <xsl:element name="geo:GeoInformatieObjectVaststelling">
            <xsl:element name="geo:context">
                <xsl:element name="gio:GeografischeContext">
                    <xsl:element name="gio:achtergrondVerwijzing">x</xsl:element>
                    <xsl:element name="gio:achtergrondActualiteit">y</xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:element name="geo:vastgestelseVersie">
                <xsl:element name="geo:GeoInformatieObjectVersie">
                    <xsl:element name="geo:FRBRWork">z</xsl:element>
                    <xsl:element name="geo:FRBRExpression">zz</xsl:element>
                    <xsl:element name="geo:locaties">
                        <xsl:apply-templates mode="locaties"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="." mode="GMLFiles">
        <xsl:for-each select="/">
            <xsl:variable name="geo_id"
                select="/geo:FeatureCollectionGeometrie/geo:featureMember[1]/geo:Geometrie[1]/geo:id[1]/text()"/>
            <xsl:variable name="doel"
                select="fn:substring-after(base-uri(), concat(fn:substring($bron_folder, 9), '/'))"/>
            <xsl:result-document href="{$doel_folder}/{$doel}" method="xml">
                <xsl:apply-templates mode="root"/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="/">
        <xsl:apply-templates mode="GMLFiles"
            select="collection(concat($bron_folder, '?select=*.gml;recurse=yes'))"/>
    </xsl:template>
</xsl:stylesheet>
