<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0"
    xmlns:da="http://www.geostandaarden.nl/imow/datatypenalgemeen/v20190709"
    xmlns:data="https://standaarden.overheid.nl/stop/imop/data/"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:g-ref="http://www.geostandaarden.nl/imow/geometrie-ref/v20190901"
    xmlns:g="http://www.geostandaarden.nl/imow/gebiedsaanwijzing/v20190709"
    xmlns:ga-ref="http://www.geostandaarden.nl/imow/gebiedsaanwijzing-ref/v20190709"
    xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing/v20190709"
    xmlns:geo="http://www.geostandaarden.nl/basisgeometrie/v20190901"
    xmlns:geo_stop="https://standaarden.overheid.nl/stop/imop/geo/"
    xmlns:gio="https://standaarden.overheid.nl/stop/imop/gio/"
    xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns:imop="https://standaarden.overheid.nl/lvbb/stop/"
    xmlns:l-ref="http://www.geostandaarden.nl/imow/locatie-ref/v20190901"
    xmlns:l="http://www.geostandaarden.nl/imow/locatie/v20190901"
    xmlns:lvbb="http://www.overheid.nl/2017/lvbb"
    xmlns:ogr="http://ogr.maptools.org/"
    xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand/v20190901"
    xmlns:r-ref="http://www.geostandaarden.nl/imow/regels-ref/v20190901"
    xmlns:r="http://www.geostandaarden.nl/imow/regels/v20190901"
    xmlns:rkow="http://www.geostandaarden.nl/imow/owobject/v20190709"
    xmlns:rol-ref="http://www.geostandaarden.nl/imow/regelsoplocatie-ref/v20190709"
    xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie/v20190901"
    xmlns:saxon="http://saxon.sf.net/" 
    xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek/v20190301"
    xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:uit="https://standaarden.overheid.nl/lvbb/DSO-PI12"
    
    xsi:schemaLocation="http://www.overheid.nl/imop/def# ../lvbb/LVBB-stop.xsd"
    >
    <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
    <xsl:strip-space elements="*"/>
    
    <!-- Pad naar het setje bestanden van de opdracht -->
    <xsl:param name="bron_folder"
        select="'file:///F:/DSO/Geonovum/GitHub/xml_omgevingsplan_gemeentestad_0.98.3-kern/Opdracht'"/>
    <xsl:param name="doel_folder"
        select="'file:///F:/DSO/Geonovum/GitHub/xml_omgevingsplan_gemeentestad_1.0-test/Opdracht'"/>
    
    <xsl:param name="GMLbestanden" select="collection(concat($bron_folder, '?select=*.gml;recurse=yes'))"/>
    <xsl:param name="XMLbestanden" select="collection(concat($bron_folder, '?select=*.xml;recurse=yes'))"/>
    
    <xsl:template mode="GIO_root" match=".">
        <xsl:param name="GML"/>
        <xsl:param name="Besluit"/>
        <xsl:element name="AanleveringInformatieObject" namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/">
            <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
            <xsl:attribute name="xsi:schemaLocation">https://standaarden.overheid.nl/lvbb/stop/ ../lvbb/lvbb-stop-aanlevering.xsd</xsl:attribute>
            <xsl:namespace name="geo">https://standaarden.overheid.nl/stop/imop/gio/</xsl:namespace>
            <xsl:namespace name="data">https://standaarden.overheid.nl/stop/imop/data/</xsl:namespace>
            <xsl:namespace name="uit">https://standaarden.overheid.nl/lvbb/stop/aanlevering/</xsl:namespace>
            <xsl:attribute name="schemaversie">1.0</xsl:attribute>
            
            <xsl:element name="InformatieObjectVersie" namespace="https://standaarden.overheid.nl/lvbb/stop/aanlevering/">
                <xsl:copy-of select="/uit:AanleveringGIO/uit:InformatieObjectVersie[1]/data:ExpressionIdentificatie[1]" copy-namespaces="no"/>
                <xsl:copy select="/uit:AanleveringGIO/uit:InformatieObjectVersie[1]/data:InformatieObjectMetadata[1]" copy-namespaces="no">
                    <xsl:copy-of select="data:eindverantwoordelijke" copy-namespaces="no"/>
                    <xsl:copy-of select="data:maker" copy-namespaces="no"/>
                    <xsl:element name="data:alternatieveTitels" inherit-namespaces="no">
                        <xsl:element name="data:alternatieveTitel" inherit-namespaces="no">
                            <xsl:value-of select="data:officieleTitel"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:copy-of select="data:officieleTitel" copy-namespaces="no"/>
                    <xsl:copy-of select="data:publicatieinstructie" copy-namespaces="no"/>
                    <xsl:element name="data:formaatInformatieobject" inherit-namespaces="no">/join/id/stop/informatieobject/gio_002</xsl:element>
                    <xsl:element name="data:soortenInformatieobject" inherit-namespaces="no">
                        <xsl:copy-of select="data:soortInformatieobject" copy-namespaces="no"/>
                    </xsl:element>
                    <xsl:element name="data:heeftGeboorteregeling">
                        <xsl:value-of select="$Besluit/uit:AanleveringBesluit/uit:RegelingVersieInformatie[1]/data:ExpressionIdentificatie[1]/data:FRBRWork[1]/text()"/>
                    </xsl:element>
                    <xsl:copy-of select="data:heeftBestanden" copy-namespaces="no"/>
                </xsl:copy>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template mode="locaties" match="/geo:FeatureCollectionGeometrie/geo:featureMember">
        <xsl:element name="geo:Locatie" namespace="https://standaarden.overheid.nl/stop/imop/geo/">
            <xsl:element name="geo:geometrie" namespace="https://standaarden.overheid.nl/stop/imop/geo/">
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
    
    <xsl:template mode="GML_root" match=".">
        <xsl:param name="GIO"/>
        <xsl:element name="geo:GeoInformatieObjectVaststelling" namespace="https://standaarden.overheid.nl/stop/imop/geo/">
            <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
            <xsl:attribute name="xsi:schemaLocation">https://standaarden.overheid.nl/stop/imop/geo/ ../stop/imop-geo.xsd http://www.geostandaarden.nl/basisgeometrie/1.0 ../xsd/basisgeometrie/basisgeometrie.xsd</xsl:attribute>
            <xsl:namespace name="geo">https://standaarden.overheid.nl/stop/imop/geo/</xsl:namespace>
            <xsl:namespace name="gio">https://standaarden.overheid.nl/stop/imop/gio/</xsl:namespace>
            <xsl:namespace name="rsc">https://standaarden.overheid.nl/stop/imop/resources/</xsl:namespace>
            <xsl:namespace name="basisgeo">http://www.geostandaarden.nl/basisgeometrie/1.0/</xsl:namespace>
            <xsl:attribute name="schemaversie">1.0</xsl:attribute>
            
            <xsl:element name="geo:context"  namespace="https://standaarden.overheid.nl/stop/imop/geo/">
                <xsl:element name="gio:GeografischeContext">
                    <xsl:element name="gio:achtergrondVerwijzing">
                        <xsl:value-of select="$GIO/uit:AanleveringGIO/uit:InformatieObjectVersie[1]/data:Achtergrond[1]/data:bronbeschrijving[1]/text()"/>
                    </xsl:element>
                    <xsl:element name="gio:achtergrondActualiteit">
                        <xsl:value-of select="$GIO/uit:AanleveringGIO/uit:InformatieObjectVersie[1]/data:Achtergrond[1]/data:bronactualiteit[1]/text()"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            
            <xsl:element name="geo:vastgesteldeVersie" namespace="https://standaarden.overheid.nl/stop/imop/geo/">
                <xsl:element name="geo:GeoInformatieObjectVersie" namespace="https://standaarden.overheid.nl/stop/imop/geo/">
                    <xsl:element name="geo:FRBRWork" namespace="https://standaarden.overheid.nl/stop/imop/geo/">
                        <xsl:value-of select="$GIO/uit:AanleveringGIO/uit:InformatieObjectVersie[1]/data:ExpressionIdentificatie[1]/data:FRBRWork[1]/text()"/>
                    </xsl:element>
                    <xsl:element name="geo:FRBRExpression" namespace="https://standaarden.overheid.nl/stop/imop/geo/">
                        <xsl:value-of select="$GIO/uit:AanleveringGIO/uit:InformatieObjectVersie[1]/data:ExpressionIdentificatie[1]/data:FRBRExpression[1]/text()"/>
                    </xsl:element>
                    <xsl:element name="geo:locaties" namespace="https://standaarden.overheid.nl/stop/imop/geo/">
                        <xsl:apply-templates mode="locaties"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="/" mode="GIO">
        <xsl:param name="GML"/>
        <xsl:param name="Besluit"/>
        <!-- haal naam GIO bestand op -->
        <xsl:variable name="gio_bestand"
            select="fn:substring-after(base-uri(), concat(fn:substring($bron_folder, 9), '/'))"/>
        <!-- maak nieuw GIO bestand met zelfde naam in doel folder -->
        <xsl:result-document href="{$doel_folder}/{$gio_bestand}" method="xml" indent='yes'>
            <xsl:apply-templates mode="GIO_root">
                <xsl:with-param name="GML" select="$GML"/>
                <xsl:with-param name="Besluit" select="$Besluit"></xsl:with-param>
            </xsl:apply-templates>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="/" mode="GML">
        <xsl:param name="GIO"/>
        <!-- haal naam gml bestand op -->
        <xsl:variable name="gml_bestand"
            select="fn:substring-after(base-uri(), concat(fn:substring($bron_folder, 9), '/'))"/>
        <!-- maak nieuw gml bestand met zelfde naam in doel folder -->
        <xsl:result-document href="{$doel_folder}/{$gml_bestand}" method="xml" indent='yes'>
            <xsl:apply-templates mode="GML_root">
                <xsl:with-param name="GIO" select="$GIO"/>
            </xsl:apply-templates>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="/" mode="XML">
        <xsl:param name="Besluit"/>
        <!-- naam van GML bestand uit heeftbestanden ophalen -->
        <xsl:variable name="GML_naam" select="/uit:AanleveringGIO/uit:InformatieObjectVersie[1]/data:InformatieObjectMetadata[1]/data:heeftBestanden[1]/data:heeftBestand[1]/data:Bestand[1]/data:bestandsnaam[1]/text()"/>
        <!-- match naam op collectie gml bestanden -->
        <xsl:apply-templates select="$GMLbestanden[fn:substring-after(base-uri(), concat(fn:substring($bron_folder, 9), '/'))=$GML_naam]" mode="GML" >
            <xsl:with-param name="GIO" select="."/>
        </xsl:apply-templates>
        <xsl:apply-templates select="." mode="GIO">
            <xsl:with-param name="GML" select="$GMLbestanden[fn:substring-after(base-uri(), concat(fn:substring($bron_folder, 9), '/'))=$GML_naam]"/>
            <xsl:with-param name="Besluit" select="$Besluit"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <!-- match op alle xml bestanden waarvan het root element een 'AanleveringGIO' is -->
    <xsl:template match="/">
        
        <xsl:apply-templates select="$XMLbestanden[root()/element()/name()='AanleveringGIO']" mode="XML">
            <xsl:with-param name="Besluit" select="$XMLbestanden[root()/element()/name()='AanleveringBesluit']"/>
        </xsl:apply-templates>
    </xsl:template>
</xsl:stylesheet>
